using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Services;
using PaypalServerSdk.Standard;
using PaypalServerSdk.Standard.Authentication;
using PaypalServerSdk.Standard.Controllers;
using PaypalServerSdk.Standard.Models;
using System.Globalization;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.Json;

namespace MillionsOfRecordsApp.Controllers;

// PayPal webhook delivery endpoint (registered in the PayPal developer portal
// to POST to /api/paypal/webhook). Primary purpose: record a confirmation even
// when the buyer's browser abandons checkout after PayPal captured the payment,
// which the synchronous capture endpoint otherwise relies on the session for.
[Route("api/paypal")]
[ApiController]
public class PayPalWebhookController : ControllerBase
{
    private readonly IReggaeDbContextProcedures _procedures;
    private readonly Microsoft.Extensions.Configuration.IConfiguration _config;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly PayPalOrderRecordingService _orderRecordingService;

    public PayPalWebhookController(IReggaeDbContextProcedures procedures, Microsoft.Extensions.Configuration.IConfiguration config, IHttpClientFactory httpClientFactory, PayPalOrderRecordingService orderRecordingService)
    {
        _procedures = procedures;
        _config = config;
        _httpClientFactory = httpClientFactory;
        _orderRecordingService = orderRecordingService;
    }

    private string _paypalClientId => _config.GetValue<string>("PayPal:ClientId")!;
    private string _paypalClientSecret => _config.GetValue<string>("PayPal:Secret")!;

    // Built lazily so a webhook that fails signature verification never pays
    // the cost of constructing the SDK client.
    private OrdersController? _ordersController;
    private OrdersController OrdersController => _ordersController ??= new PaypalServerSdkClient.Builder()
        .Environment(PaypalServerSdk.Standard.Environment.Sandbox)
        .ClientCredentialsAuth(
            new ClientCredentialsAuthModel.Builder(_paypalClientId, _paypalClientSecret).Build()
        )
        .Build()
        .OrdersController;

    [HttpPost("webhook")]
    public async Task<IActionResult> Webhook()
    {
        string rawBody;
        using (var reader = new StreamReader(Request.Body, Encoding.UTF8))
        {
            rawBody = await reader.ReadToEndAsync();
        }

        if (string.IsNullOrWhiteSpace(rawBody))
        {
            return BadRequest();
        }

        // Never trust a webhook without first verifying PayPal's signature.
        if (!await VerifyWebhookSignatureAsync(rawBody))
        {
            Console.Error.WriteLine("PayPal webhook rejected: signature verification failed.");
            return Unauthorized();
        }

        using var doc = JsonDocument.Parse(rawBody);
        var root = doc.RootElement;

        string eventType = root.TryGetProperty("event_type", out var eventTypeElement)
            ? eventTypeElement.GetString() ?? string.Empty
            : string.Empty;

        Console.WriteLine($"PayPal webhook received: {eventType}");

        if (eventType == "PAYMENT.CAPTURE.COMPLETED")
        {
            await HandleCaptureCompletedAsync(root);
        }

        // Other events (PAYMENT.CAPTURE.DENIED, PAYMENT.CAPTURE.PENDING,
        // CHECKOUT.ORDER.APPROVED, ...) are acknowledged but not acted on.
        // PayPal retries non-2xx responses, so return 200 once verified.
        return Ok();
    }

    private async Task HandleCaptureCompletedAsync(JsonElement root)
    {
        if (!root.TryGetProperty("resource", out var resource))
        {
            Console.Error.WriteLine("PayPal webhook PAYMENT.CAPTURE.COMPLETED missing resource.");
            return;
        }

        // The purchase unit's CustomId/InvoiceId are both our generated web
        // order number (refId), set at create-order time.
        string orderNumber = GetString(resource, "custom_id");
        if (string.IsNullOrWhiteSpace(orderNumber))
        {
            orderNumber = GetString(resource, "invoice_id");
        }
        if (string.IsNullOrWhiteSpace(orderNumber))
        {
            Console.Error.WriteLine("PayPal webhook PAYMENT.CAPTURE.COMPLETED has no custom_id/invoice_id to reconcile.");
            return;
        }

        string captureId = GetString(resource, "id");
        string paypalStatus = GetString(resource, "status");
        if (string.IsNullOrWhiteSpace(paypalStatus))
        {
            paypalStatus = "COMPLETED";
        }
        decimal capturedTotal = resource.TryGetProperty("amount", out var amount) && amount.TryGetProperty("value", out var value)
            ? ParseMoney(value.GetString())
            : 0m;
        string payerEmail = resource.TryGetProperty("payer", out var payer)
            ? GetString(payer, "email_address")
            : string.Empty;

        // Idempotency: if the synchronous capture path already recorded the
        // order (possibly moments ago), just fill in the PayPal payment details.
        bool orderExists = (await _procedures.spSeeIfOrderNumberExistsAsync(orderNumber)).Count > 0;
        if (orderExists)
        {
            await _procedures.spUpdatePayPalPaymentInfoAsync(
                orderNumber: orderNumber,
                paypalTransactionID: captureId,
                payPalPaymentStatus: paypalStatus,
                payPalEmail: payerEmail,
                payPalAmountPaid: capturedTotal,
                paypalAmountDue: paypalStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase) ? capturedTotal : 0m,
                payPalPendingReason: string.Empty);
            Console.WriteLine($"PayPal webhook: order {orderNumber} already recorded; updated PayPal payment info (capture {captureId}).");
            return;
        }

        // Browser abandoned checkout after the payment was captured. Recreate
        // the order from the persisted PayFlow request row + the customer row.
        // NOTE: if the synchronous capture is in-flight at the same moment, this
        // best-effort path may race it; duplicate OrderNumber inserts fail
        // harmlessly and are caught below.
        await ReconcileAbandonedOrderAsync(resource, orderNumber, captureId, paypalStatus, capturedTotal, payerEmail);
    }

    private async Task ReconcileAbandonedOrderAsync(JsonElement resource, string orderNumber, string captureId, string paypalStatus, decimal capturedTotal, string payerEmail)
    {
        var payFlowResults = await _procedures.spGetPayFlowRequestByWebOrderNumberAsync(orderNumber);
        var payFlow = payFlowResults.FirstOrDefault();
        if (payFlow == null)
        {
            Console.Error.WriteLine($"PayPal webhook: order {orderNumber} not recorded and no PayFlow request row to reconcile from.");
            return;
        }

        int? customerServerCounter = payFlow.CustomerID;
        if (customerServerCounter == null || customerServerCounter <= 0)
        {
            Console.Error.WriteLine($"PayPal webhook: order {orderNumber} has no customer server counter in the PayFlow row; cannot reconcile.");
            return;
        }

        // C1 parity: never record an order whose captured amount differs from
        // the total the server computed at create time (stored as Request_AMT).
        decimal expectedTotal = payFlow.REQUEST_Amt ?? 0m;
        if (expectedTotal <= 0m || capturedTotal != expectedTotal)
        {
            Console.Error.WriteLine($"CHECKOUT AMOUNT MISMATCH (webhook): order {orderNumber}, expected {expectedTotal:F2}, captured {capturedTotal:F2}. Not recorded.");
            return;
        }

        var customerResults = await _procedures.spGetCustomerDetailsByServerCounterAsync(customerServerCounter);
        var customer = customerResults.FirstOrDefault();
        if (customer == null)
        {
            Console.Error.WriteLine($"PayPal webhook: customer {customerServerCounter} not found for order {orderNumber}.");
            return;
        }

        int customerID = int.TryParse(customer.CustomerID, out int parsedCustomerId) ? parsedCustomerId : customerServerCounter.Value;

        // Checkout requires a signed-in customer, so the wholesale cart name is
        // deterministic from the server counter (no browser session available).
        string activeCartName = $"W_CART_{customerServerCounter}";

        // The capture webhook resource only carries the total, so fetch the
        // PayPal order (via its supplementary_data.related_ids.order_id) for the
        // authoritative item/shipping/tax breakdown used on the receipt.
        decimal shipping = 0m;
        decimal tax = 0m;
        decimal totalPrice = capturedTotal;
        int totalQuantity = 1;
        try
        {
            string paypalOrderId = GetRelatedOrderId(resource);
            if (!string.IsNullOrWhiteSpace(paypalOrderId))
            {
                var order = await OrdersController.GetOrderAsync(new GetOrderInput { Id = paypalOrderId });
                var purchaseUnit = order.Data?.PurchaseUnits?.FirstOrDefault();
                if (purchaseUnit?.Amount?.Breakdown != null)
                {
                    decimal fetchedItemTotal = ParseMoney(purchaseUnit.Amount.Breakdown.ItemTotal?.MValue);
                    if (fetchedItemTotal > 0m)
                    {
                        totalPrice = fetchedItemTotal;
                    }
                    shipping = ParseMoney(purchaseUnit.Amount.Breakdown.Shipping?.MValue);
                    tax = ParseMoney(purchaseUnit.Amount.Breakdown.TaxTotal?.MValue);
                }
                if (purchaseUnit?.Items != null)
                {
                    int fetchedQuantity = purchaseUnit.Items.Sum(x => int.TryParse(x.Quantity, NumberStyles.Any, CultureInfo.InvariantCulture, out int qty) ? qty : 0);
                    if (fetchedQuantity > 0)
                    {
                        totalQuantity = fetchedQuantity;
                    }
                }
                if (string.IsNullOrWhiteSpace(payerEmail))
                {
                    payerEmail = order.Data?.Payer?.EmailAddress ?? string.Empty;
                }
            }
        }
        catch (Exception ex)
        {
            // Non-fatal: fall back to the captured total breakdown above.
            Console.Error.WriteLine($"PayPal webhook: could not fetch order breakdown for {orderNumber}: {ex.Message}");
        }

        string userAgent = payFlow.UserAgent ?? string.Empty;
        string remHost = payFlow.Request_CUSTIP ?? string.Empty;
        string ipAddress = remHost;
        string selectedShippingMethod = payFlow.Request_COMMENT2 ?? string.Empty;
        string sessionId = string.Empty;

        try
        {
            await _orderRecordingService.RecordPurchaseAsync(
                customer: customer,
                orderNumber: orderNumber,
                customerServerCounter: customerServerCounter.Value,
                customerID: customerID,
                activeCartName: activeCartName,
                guestCartName: string.Empty,
                orderTotal: capturedTotal,
                shipping: shipping,
                tax: tax,
                totalPrice: totalPrice,
                totalQuantity: totalQuantity,
                userAgent: userAgent,
                remHost: remHost,
                sessionId: sessionId,
                selectedShippingMethod: selectedShippingMethod,
                ipAddress: ipAddress,
                paypalTransactionId: captureId,
                paypalStatus: paypalStatus,
                paypalEmail: payerEmail,
                paypalAmountDue: paypalStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase) ? capturedTotal : 0m,
                paypalPendingReason: string.Empty);
            Console.WriteLine($"PayPal webhook: reconciled abandoned order {orderNumber} (capture {captureId}).");
        }
        catch (Exception ex)
        {
            // e.g. duplicate OrderNumber from an in-flight synchronous capture.
            Console.Error.WriteLine($"PayPal webhook reconciliation FAILED for order {orderNumber}: {ex.Message}");
        }
    }

    private static string GetRelatedOrderId(JsonElement resource)
    {
        if (!resource.TryGetProperty("supplementary_data", out var supplementary) ||
            !supplementary.TryGetProperty("related_ids", out var relatedIds))
        {
            return string.Empty;
        }
        return GetString(relatedIds, "order_id");
    }

    private async Task<bool> VerifyWebhookSignatureAsync(string rawBody)
    {
        string transmissionId = Request.Headers["PayPal-Transmission-Id"].ToString();
        string transmissionTime = Request.Headers["PayPal-Transmission-Time"].ToString();
        string transmissionSig = Request.Headers["PayPal-Transmission-Sig"].ToString();
        string certUrl = Request.Headers["PayPal-Cert-Url"].ToString();
        string authAlgo = Request.Headers["PayPal-Auth-Algo"].ToString();

        if (string.IsNullOrWhiteSpace(transmissionId) || string.IsNullOrWhiteSpace(transmissionTime) ||
            string.IsNullOrWhiteSpace(transmissionSig) || string.IsNullOrWhiteSpace(certUrl) ||
            string.IsNullOrWhiteSpace(authAlgo))
        {
            return false;
        }

        string webhookId = _config.GetValue<string>("PayPal:WebhookId") ?? string.Empty;
        if (string.IsNullOrWhiteSpace(webhookId))
        {
            Console.Error.WriteLine("PayPal webhook cannot be verified: PayPal:WebhookId is not configured.");
            return false;
        }

        byte[] signatureBytes;
        try
        {
            signatureBytes = Convert.FromBase64String(transmissionSig);
        }
        catch (FormatException)
        {
            return false;
        }

        // SSRF guard: only ever fetch verification certificates from PayPal's
        // own hosts; the cert URL comes from a request header.
        if (!Uri.TryCreate(certUrl, UriKind.Absolute, out var certUri) || !IsPayPalHost(certUri.Host))
        {
            return false;
        }

        string certPem;
        using (var httpClient = _httpClientFactory.CreateClient())
        {
            try
            {
                certPem = await httpClient.GetStringAsync(certUri);
            }
            catch
            {
                return false;
            }
        }

        X509Certificate2 certificate;
        try
        {
            certificate = X509Certificate2.CreateFromPem(certPem);
        }
        catch
        {
            return false;
        }

        using (certificate)
        using (var rsa = certificate.GetRSAPublicKey())
        {
            if (rsa == null)
            {
                return false;
            }

            // PayPal signs the concatenation of transmission id + transmission
            // time + webhook id + raw event body.
            string message = transmissionId + transmissionTime + webhookId + rawBody;
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);

            if (string.Equals(authAlgo, "sha256", StringComparison.OrdinalIgnoreCase))
            {
                return rsa.VerifyData(messageBytes, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            }

            if (string.Equals(authAlgo, "crc32", StringComparison.OrdinalIgnoreCase))
            {
                // Legacy certs sign a CRC32 hash of the message (SHA256withRSA).
                byte[] crcBytes = Crc32.ComputeHash(messageBytes);
                return rsa.VerifyData(crcBytes, signatureBytes, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            }

            return false;
        }
    }

    private static bool IsPayPalHost(string host)
    {
        return host.Equals("api.paypal.com", StringComparison.OrdinalIgnoreCase)
            || host.Equals("api-m.paypal.com", StringComparison.OrdinalIgnoreCase)
            || host.EndsWith(".paypal.com", StringComparison.OrdinalIgnoreCase)
            || host.Equals("api.paypalobjects.com", StringComparison.OrdinalIgnoreCase)
            || host.EndsWith(".paypalobjects.com", StringComparison.OrdinalIgnoreCase);
    }

    private static string GetString(JsonElement element, string propertyName)
        => element.TryGetProperty(propertyName, out var value) ? value.GetString() ?? string.Empty : string.Empty;

    private static decimal ParseMoney(string? value)
        => decimal.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out var parsed) ? parsed : 0m;

    /// <summary>
    /// Minimal CRC32 (IEEE 802.3) implementation. The PayPal webhook
    /// "crc32" auth algorithm signs a CRC32 of the verification message.
    /// </summary>
    private static class Crc32
    {
        private static readonly uint[] Table = BuildTable();

        private static uint[] BuildTable()
        {
            var table = new uint[256];
            for (uint i = 0; i < 256; i++)
            {
                uint value = i;
                for (int j = 0; j < 8; j++)
                {
                    value = (value & 1) != 0 ? 0xEDB88320u ^ (value >> 1) : value >> 1;
                }
                table[i] = value;
            }
            return table;
        }

        public static byte[] ComputeHash(byte[] data)
        {
            uint crc = 0xFFFFFFFFu;
            foreach (byte b in data)
            {
                crc = Table[(crc ^ b) & 0xFF] ^ (crc >> 8);
            }
            crc ^= 0xFFFFFFFFu;

            return new[]
            {
                (byte)(crc & 0xFF),
                (byte)((crc >> 8) & 0xFF),
                (byte)((crc >> 16) & 0xFF),
                (byte)((crc >> 24) & 0xFF)
            };
        }
    }
}
