using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Services;
using PaypalServerSdk.Standard;
using PaypalServerSdk.Standard.Authentication;
using PaypalServerSdk.Standard.Controllers;
using PaypalServerSdk.Standard.Models;
using StackExchange.Profiling;
using System.Globalization;
using System.Text.RegularExpressions;

namespace MillionsOfRecordsApp.Controllers;

[Route("api/[controller]")]
[ApiController]
public class CheckoutController : ControllerBase
{
    private readonly Microsoft.Extensions.Configuration.IConfiguration _config;
    private readonly IReggaeDbContextProcedures _procedures;
    private readonly OrderService _orderService;
    private readonly CartService _cartService;
    private readonly ShippingService _shippingService;
    private readonly TaxService _taxService;
    private readonly PayPalOrderRecordingService _orderRecordingService;
    private readonly ReggaeDbContext _context;

    private readonly OrdersController _ordersController;

    public CheckoutController(Microsoft.Extensions.Configuration.IConfiguration config, IReggaeDbContextProcedures procedures,
        OrderService orderService, CartService cartService, ShippingService shippingService, TaxService taxService, PayPalOrderRecordingService orderRecordingService, ReggaeDbContext context)
    {
        _config = config;
        _orderService = orderService;
        _cartService = cartService;
        _shippingService = shippingService;
        _taxService = taxService;
        _procedures = procedures;
        _orderRecordingService = orderRecordingService;
        _context = context;
        PaypalServerSdkClient client = new PaypalServerSdkClient.Builder()
          .Environment(PaypalServerSdk.Standard.Environment.Sandbox)
          .ClientCredentialsAuth(
            new ClientCredentialsAuthModel.Builder(_paypalClientId, _paypalClientSecret).Build()
          )
          .LoggingConfig(config =>
            config
            .LogLevel(LogLevel.Information)
            .RequestConfig(reqConfig => reqConfig.Body(true))
            .ResponseConfig(respConfig => respConfig.Headers(true))
          )
          .Build();

        _ordersController = client.OrdersController;

    }

    private string _paypalClientId
    {
        get
        {
            return _config.GetValue<string>("PayPal:ClientId")!;
        }
    }
    private string _paypalClientSecret
    {
        get
        {
            return _config.GetValue<string>("PayPal:Secret")!;
        }
    }
    private async Task<spGetCustomerDetailsByServerCounterResult> GetCustomerDetailsAsync()
    {
        var counter = HttpContext.Session.GetCustomerServerCounter();
        var spResults = await _procedures.spGetCustomerDetailsByServerCounterAsync(counter);
        var customerDetails = spResults.First();
        return customerDetails;
    }
    private async Task<(decimal ProductsPrice, decimal ShippingCost, decimal TaxAmount)> CalculateCheckoutTotals(string shippingCode, List<(Cart Cart, Inventory Inv)> cartResults)
    {
        var customerDetails = await GetCustomerDetailsAsync();

        decimal productsPrice = cartResults.Sum(x => x.Cart.Price * x.Cart.Quantity);
        int totalItems = cartResults.Sum(x => x.Cart.Quantity);

        var results = await _procedures.spGetWeightOfProductAsync(HttpContext.Session.GetActiveCartName());
        var result = results.FirstOrDefault();
        if (result != null)
        {
            HttpContext.Session.SetTotalWeightGrams((int)(result.sumweight));
        }


        var shippingMethods = await _shippingService.CalculateShippingOptionsAsync(customerDetails, productsPrice, totalItems, HttpContext.Session.GetTotalWeightGrams());
        decimal shippingCost = shippingMethods.FirstOrDefault(x => x.Code == shippingCode)?.Price ?? 0m;
        //decimal shippingCost = await _shippingService.GetCostByCodeAsync(shippingCode, productsPrice, totalItems, customerDetails);

        decimal taxAmount = await _taxService.CalculateTaxAsync(customerDetails, productsPrice, shippingCost);

        return (productsPrice, shippingCost, taxAmount);
    }
    public record CreateOrderRequest(string ShippingCode);

    [HttpPost("create-order")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> CreateOrder([FromBody] CreateOrderRequest req)
    {
        try
        {
            // 1. Call your private helper (ensure it returns ApiResponse<Order>)
            var result = await _CreateOrder(req);

            // 2. Check if the status code indicates success (200-299)
            if (result.StatusCode >= 200 && result.StatusCode < 300)
            {
                return StatusCode((int)result.StatusCode, result.Data);
            }

            // 3. If it failed, return the error data back to the client
            // This is equivalent to your old 'BadRequest(error)' logic
            await UpdatePayFlowRequestAnswerAsync(order: null, isSuccess: false, failureMessage: "PayPal order creation returned a non-success status.");
            return StatusCode((int)result.StatusCode, new
            {
                message = "PayPal Order Creation Failed",
                details = result.Data // The SDK maps the error JSON into the Data property on failure
            });
        }
        catch (Exception ex)
        {
            await UpdatePayFlowRequestAnswerAsync(order: null, isSuccess: false, failureMessage: ex.Message);
            Console.Error.WriteLine($"Failed to create order: {ex.Message}");
            return StatusCode(500, new { error = "Internal server error during order creation." });
        }
    }
    private async Task<List<(Cart Cart, Inventory Inv)>> GetCartResults()
    {
        return await _cartService.GetCartDetailsAsync(HttpContext.Session.GetActiveCartName());
    }
    private async Task<dynamic> _CreateOrder(CreateOrderRequest req)
    {
        HttpContext.Session.SetSelectedShippingCode(req.ShippingCode);

        var cartResults = await GetCartResults();
        var checkoutData = await CalculateCheckoutTotals(req.ShippingCode, cartResults);
        var customerDetails = await GetCustomerDetailsAsync();
        string refId = await _orderService.GenerateUniqueOrderNumberAsync();
        var cleanedPhone = SanitizePhoneNumber(customerDetails.Phone);
        var payerName = SplitBillingName(customerDetails.BillingFullName);

        // Persist the server-computed total and order number for the capture
        // step: the captured amount is cross-checked against this expected
        // total before the purchase is recorded (anti-tampering).
        decimal expectedTotal = checkoutData.ProductsPrice + checkoutData.ShippingCost + checkoutData.TaxAmount;
        HttpContext.Session.SetCheckoutOrderNumber(refId);
        HttpContext.Session.SetExpectedCheckoutTotal(expectedTotal);
        HttpContext.Session.SetOrderCaptured(false);

        var items = new List<ItemRequest>();
        foreach (var cart in cartResults)
        {
            var item = new ItemRequest
            {
                Name = cart.Inv.ArtistTitle.Split('-')[0],
                Quantity = cart.Cart.Quantity.ToString(),
                Category = ItemCategory.PhysicalGoods,
                Description = cart.Inv.Label,
                UnitAmount = new Money("USD", cart.Cart.Price.ToString("F2"))
            };
            items.Add(item);
        }

        CreateOrderInput createOrderInput = new CreateOrderInput
        {
            Body = new OrderRequest
            {
                Intent = CheckoutPaymentIntent.Capture,
                Payer = new Payer
                {
                    // A4: PayPal requires a payer name; populate it from the
                    // customer's billing name rather than sending empty strings.
                    Name = new Name
                    {
                        GivenName = payerName.GivenName,
                        Surname = payerName.Surname
                    },
                    EmailAddress = customerDetails.LogInEmail
                },
                PaymentSource = new PaymentSource
                {
                    Card = new CardRequest
                    {
                        Name = customerDetails.BillingFullName,
                        BillingAddress = new Address
                        {
                            AddressLine1 = customerDetails.BillingStreetAddress1,
                            AddressLine2 = customerDetails.BillingStreetAddress2,
                            AdminArea2 = customerDetails.BillingCity,
                            AdminArea1 = (await GetStateCode(customerDetails.BillingStateProvince)),
                            PostalCode = customerDetails.BillingPostalCode,
                            CountryCode = GetCountryCode(customerDetails.BillingCountry)
                        },
                    },
                    Paypal = new PaypalWallet
                    {
                        ExperienceContext = new PaypalWalletExperienceContext
                        {
                            ShippingPreference = PaypalWalletContextShippingPreference.NoShipping,
                            UserAction = PaypalExperienceUserAction.PayNow,
                            BrandName = "Millions of Records",
                        }
                    }
                },
                PurchaseUnits = new List<PurchaseUnitRequest> {
                    new PurchaseUnitRequest {
                        ReferenceId=refId,
                        CustomId = refId,
                        InvoiceId = refId,
                        Description = $"Order {refId} from Millions of Records",
                        Amount = new AmountWithBreakdown {
                            CurrencyCode = "USD",
                            MValue = (checkoutData.ProductsPrice + checkoutData.ShippingCost + checkoutData.TaxAmount).ToString("F2"),
                            Breakdown = new AmountBreakdown {
                              ItemTotal = new Money("USD", checkoutData.ProductsPrice.ToString("F2")),
                              Shipping = new Money("USD", checkoutData.ShippingCost.ToString("F2")),
                              TaxTotal = new Money("USD", checkoutData.TaxAmount.ToString("F2"))
                            },
                        },
                        Shipping = new ShippingDetails {
                            Type = FulfillmentType.Shipping,
                            Name = new ShippingName(customerDetails.FullName),
                            PhoneNumber = new PhoneNumberWithCountryCode("1", cleanedPhone),
                            Address = new Address {
                                AddressLine1 = customerDetails.StreetAddress1,
                                AddressLine2 = customerDetails.StreetAddress2,
                                AdminArea1 = (await GetStateCode(customerDetails.StateProvince)),
                                AdminArea2 = customerDetails.City,
                                PostalCode = customerDetails.PostalCode,
                                CountryCode = GetCountryCode(customerDetails.Country)
                            }
                        },
                        Items = items,
                    },
                },
            },
        };

#if DEBUG
        using (StackExchange.Profiling.MiniProfiler.Current?.CustomTiming("paypal", "POST /v2/checkout/orders"))
        {
#endif
            PaypalServerSdk.Standard.Http.Response.ApiResponse<Order> result = await _ordersController.CreateOrderAsync(createOrderInput);
        // Persist a PayFlow request row for the order. It is the reconciliation
        // anchor the webhook uses when a browser abandons checkout after PayPal
        // has captured the payment, so it is written from the created order.
        await LogPayFlowRequestAsync(customerDetails, refId, checkoutData, result.Data);
        return result;
#if DEBUG
        }
#endif
    }
    private async Task LogPayFlowRequestAsync(spGetCustomerDetailsByServerCounterResult customer, string webOrderNumber, (decimal ProductsPrice, decimal ShippingCost, decimal TaxAmount) checkoutData, Order order)
    {
        var counterOutput = new OutputParameter<int>();
        var totals = checkoutData;

        // A1: PayPal REST v2 never exposes the full PAN or CVV2 to the server
        // (card data is tokenized in the browser), so Request_ACCT/Request_CVV2
        // are always empty here. What IS available for a card payment is the
        // last 4 digits and expiry from the payment source, which we persist
        // instead of encrypting fake values.
        string cardLastFour = order.PaymentSource?.Card?.LastDigits ?? string.Empty;
        string requestExpDate = order.PaymentSource?.Card?.Expiry ?? string.Empty;

        string[] nameParts = string.IsNullOrWhiteSpace(customer.BillingFullName)
            ? Array.Empty<string>()
            : customer.BillingFullName.Split(new[] { ' ' }, 2, StringSplitOptions.RemoveEmptyEntries);
        string firstName = nameParts.Length > 0 ? nameParts[0] : string.Empty;
        string lastName = nameParts.Length > 1 ? nameParts[1] : string.Empty;

        // A1: do not pretend to encrypt with an empty passphrase. The legacy
        // PayFlow Pro encryption columns are only meaningful when a real key is
        // configured; pass NULL so EncryptByPassphrase stores NULL instead of a
        // fake blob.
        string? encryptionKey = _config.GetValue<string>("PayFlow:EncryptionKey");
        if (string.IsNullOrWhiteSpace(encryptionKey)) encryptionKey = null;
        string? iv = _config.GetValue<string>("PayFlow:IV");
        if (string.IsNullOrWhiteSpace(iv)) iv = null;

        await _procedures.spPayFlowRequests_InsertAsync(
            encryptionKey: encryptionKey,
            status: "pending",
            userAgent: Request.Headers["User-Agent"].ToString(),
            request_TRXTYPE: "S",
            request_TENDER: "C",
            request_ACCT: string.Empty,
            request_EXPDATE: requestExpDate,
            request_AMT: totals.ProductsPrice + totals.ShippingCost + totals.TaxAmount,
            request_CVV2: string.Empty,
            request_BILLTOFIRSTNAME: firstName,
            request_BILLTOLASTNAME: lastName,
            request_BILLTOSTREET: customer.BillingStreetAddress1,
            request_BILLTOSTREET2: customer.BillingStreetAddress2,
            request_BILLTOCITY: customer.BillingCity,
            request_BILLTOSTATE: customer.BillingStateProvince,
            request_BILLTOZIP: customer.BillingPostalCode,
            request_BILLTOCOUNTRY: customer.BillingCountry,
            request_CUSTIP: HttpContext.Connection.RemoteIpAddress?.ToString() ?? string.Empty,
            request_ORDERID: webOrderNumber,
            request_COMMENT1: "PayPal REST v2",
            // Persist the selected shipping code so the webhook reconciliation
            // path can record the order without relying on the (lost) session.
            request_COMMENT2: HttpContext.Session.GetSelectedShippingCode() ?? string.Empty,
            webOrderNumber: webOrderNumber,
            customerID: HttpContext.Session.GetCustomerServerCounter(),
            rightFour: cardLastFour,
            iV: iv,
            counterOUTPUT: counterOutput);

        HttpContext.Session.SetPayFlowRequestCounter(counterOutput.Value);
    }

    // A4: split a full billing name into the given name and surname PayPal
    // expects. Handles "FirstName LastName" and "FirstName Middle LastName".
    private static (string GivenName, string Surname) SplitBillingName(string fullName)
    {
        if (string.IsNullOrWhiteSpace(fullName))
        {
            return (string.Empty, string.Empty);
        }

        string[] parts = fullName.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 1)
        {
            return (parts[0], string.Empty);
        }

        return (parts[0], string.Join(" ", parts.Skip(1)));
    }

    private async Task UpdatePayFlowRequestAnswerAsync(Order? order, bool isSuccess, string? failureMessage = null)
    {
        int counter = HttpContext.Session.GetPayFlowRequestCounter();
        if (counter <= 0)
        {
            return;
        }

        HttpContext.Session.ClearPayFlowRequestCounter();

        string responsePnref = order?.PurchaseUnits?.FirstOrDefault()?.Payments?.Captures?.FirstOrDefault()?.Id ?? string.Empty;
        string responsePpref = order?.Id ?? string.Empty;
        string responseRespmsg = isSuccess
            ? (order?.PurchaseUnits?.FirstOrDefault()?.Payments?.Captures?.FirstOrDefault()?.Status?.ToString() ?? "COMPLETED")
            : (failureMessage ?? "PayPal capture failed");
        string responseCvv2Match = order?.PaymentSource?.Card?.LastDigits != null ? "Y" : "X";

        await _procedures.spPayFlowRequests_Update_AnswerAsync(
            status: isSuccess ? "COMPLETED" : "FAILED",
            response_PNREF: responsePnref,
            response_PPREF: responsePpref,
            response_RESULT: isSuccess ? 0 : 1,
            response_CVV2MATCH: responseCvv2Match,
            response_RESPMSG: responseRespmsg,
            response_DUPLICATE: 0,
            response_PROCAVS: null,
            vBNETPostType: "REST",
            counter: counter);
    }

    private static string SanitizePhoneNumber(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;

        // Removes everything except 0-9
        return Regex.Replace(phone, @"\D", "");
    }
    
    // A3: shared across all controller instances (controllers are transient) so
    // the state-code DB lookups are cached process-wide, not rebuilt per request.
    private static readonly System.Collections.Concurrent.ConcurrentDictionary<string, string?> _stateCodeCache = new(StringComparer.OrdinalIgnoreCase);

    private async Task<string?> GetStateCode(string stateName)
    {
        if (string.IsNullOrWhiteSpace(stateName)) return null;

        // 2. Check if we already looked this up
        if (_stateCodeCache.TryGetValue(stateName, out var cachedCode))
        {
            return cachedCode;
        }

        // 3. Database lookup
        var stateCode = await _context.WebCountryStateProvincesLists
            .Where(s => s.StateProvince == stateName)
            .Select(x => x.StateProvinceAbbreviation)
            .FirstOrDefaultAsync();

        // 4. Store the result (even if null to avoid re-querying missing states)
        _stateCodeCache[stateName] = stateCode;

        return stateCode;
    }
    private string GetCountryCode(string countryName)
    {
        var cultures = CultureInfo.GetCultures(CultureTypes.SpecificCultures);

        var region = cultures
            .Select(c => new RegionInfo(c.Name))
            .FirstOrDefault(r =>
                string.Equals(r.EnglishName, countryName, StringComparison.OrdinalIgnoreCase) ||
                string.Equals(r.ThreeLetterISORegionName, countryName, StringComparison.OrdinalIgnoreCase) ||
                string.Equals(r.DisplayName, countryName, StringComparison.OrdinalIgnoreCase));

        return region?.TwoLetterISORegionName!; // Returns "US" for "USA" or "United States"
    }

    [HttpPost("capture-order/{orderId}")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> CaptureOrder(string orderId)
    {
        try
        {
            string activeCartName = HttpContext.Session.GetActiveCartName();
            string guestCartName = HttpContext.Session.GetGuestCartName();
            int.TryParse(HttpContext.Session.GetCustomerID(), out int customerID);
            int customerServerCounter = HttpContext.Session.GetCustomerServerCounter();
            var customerResults = await _procedures.spGetCustomerDetailsByServerCounterAsync(customerServerCounter);
            spGetCustomerDetailsByServerCounterResult c = customerResults.FirstOrDefault() ?? throw new InvalidOperationException("cusomer server counter is null in the session. CRITICAL ERROR!!");

            // C4: short-circuit a retry/double-click once the order has already
            // been captured and recorded, instead of capturing/recording again.
            string sessionOrderNumber = HttpContext.Session.GetCheckoutOrderNumber();
            if (HttpContext.Session.GetOrderCaptured() ||
                (!string.IsNullOrWhiteSpace(sessionOrderNumber) &&
                 (await _procedures.spSeeIfOrderNumberExistsAsync(sessionOrderNumber)).Count > 0))
            {
                return Ok(new
                {
                    message = "This order has already been processed.",
                    orderNumber = sessionOrderNumber,
                    alreadyProcessed = true
                });
            }

            var result = await _CaptureOrder(orderId);

            // 1. Success Path (200-299)
            if (result.StatusCode >= 200 && result.StatusCode < 300)
            {
                string userAgent = Request.Headers["User-Agent"].ToString();
                // SECURITY: Only use the IP resolved by UseForwardedHeaders from a configured
                // trusted proxy. Never read X-Forwarded-For directly - it is spoofable by any client.
                string remHost = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
                string sessionId = HttpContext.Session.Id;
                string selectedShippingMethod = HttpContext.Session.GetSelectedShippingCode() ?? "Not Selected";
                string ipAddress = remHost;

                var purchaseUnit = result.Data.PurchaseUnits.First();
                var capture = purchaseUnit.Payments?.Captures?.FirstOrDefault();
                var orderNumber = purchaseUnit.InvoiceId ?? result.Data.Id; // Fallback to Order ID if Invoice ID is not set

                // C2: parse PayPal decimal/int values culture-invariantly so a
                // non-US server (e.g. comma decimal separator) cannot throw.
                decimal? shipping = purchaseUnit.Amount?.Breakdown?.Shipping?.MValue is { } shippingValue
                    ? decimal.Parse(shippingValue, NumberStyles.Any, CultureInfo.InvariantCulture)
                    : 0m;
                decimal? orderTotal = purchaseUnit.Amount?.MValue is { } orderTotalValue
                    ? decimal.Parse(orderTotalValue, NumberStyles.Any, CultureInfo.InvariantCulture)
                    : 0m;
                decimal? totalPrice = purchaseUnit.Amount?.Breakdown?.ItemTotal?.MValue is { } itemTotalValue
                    ? decimal.Parse(itemTotalValue, NumberStyles.Any, CultureInfo.InvariantCulture)
                    : 0m;
                decimal? tax = purchaseUnit.Amount?.Breakdown?.TaxTotal?.MValue is { } taxValue
                    ? decimal.Parse(taxValue, NumberStyles.Any, CultureInfo.InvariantCulture)
                    : 0m;
                int? totalQuantity = purchaseUnit.Items?.Sum(x => int.Parse(x.Quantity, CultureInfo.InvariantCulture)) ?? 0;

                // C1: verify the captured amount matches the total the server
                // computed at create time before recording the purchase. If it
                // does not match, treat it as a mismatch/fraud attempt and do
                // NOT mark the order as paid.
                decimal expectedTotal = HttpContext.Session.GetExpectedCheckoutTotal();
                decimal capturedTotal = orderTotal ?? 0m;
                if (expectedTotal <= 0m || capturedTotal != expectedTotal)
                {
                    await UpdatePayFlowRequestAnswerAsync(result.Data, isSuccess: false,
                        failureMessage: $"Captured amount {capturedTotal:F2} does not match expected total {expectedTotal:F2} for order {orderNumber}. Possible tampering.");
                    Console.Error.WriteLine($"CHECKOUT AMOUNT MISMATCH: order {orderNumber}, expected {expectedTotal:F2}, captured {capturedTotal:F2}");
                    return StatusCode(422, new
                    {
                        message = "Captured amount does not match the expected order total. The purchase was not recorded.",
                        orderNumber,
                        expectedTotal,
                        capturedTotal
                    });
                }

                await UpdatePayFlowRequestAnswerAsync(result.Data, isSuccess: true);

                // C5: derive the PayPal payment details, then record the order
                // (order + line items + PayPal payment info) via the shared
                // service so the webhook reconciliation path reuses the same
                // logic.
                string paypalStatus = capture?.Status?.ToString() ?? result.Data.Status?.ToString() ?? "COMPLETED";
                string paypalPendingReason = capture?.StatusDetails?.Reason?.ToString() ?? string.Empty;
                decimal? paypalAmountDue = paypalStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase) ? orderTotal : 0m;

                await _orderRecordingService.RecordPurchaseAsync(
                    customer: c,
                    orderNumber: orderNumber,
                    customerServerCounter: customerServerCounter,
                    customerID: customerID,
                    activeCartName: activeCartName,
                    guestCartName: guestCartName,
                    orderTotal: orderTotal,
                    shipping: shipping,
                    tax: tax,
                    totalPrice: totalPrice,
                    totalQuantity: totalQuantity,
                    userAgent: userAgent,
                    remHost: remHost,
                    sessionId: sessionId,
                    selectedShippingMethod: selectedShippingMethod,
                    ipAddress: ipAddress,
                    paypalTransactionId: capture?.Id ?? string.Empty,
                    paypalStatus: paypalStatus,
                    paypalEmail: result.Data.Payer?.EmailAddress ?? string.Empty,
                    paypalAmountDue: paypalAmountDue,
                    paypalPendingReason: paypalPendingReason);

                // The capture is verified and the purchase recorded; mark it so a
                // retry/double-click short-circuits instead of charging again.
                HttpContext.Session.SetOrderCaptured(true);
                HttpContext.Session.ClearExpectedCheckoutTotal();

                return StatusCode((int)result.StatusCode, result.Data);
            }

            // 2. Failure Path (Descriptive Error)
            // This mimics your old 'BadRequest(errorBody)' logic
            await UpdatePayFlowRequestAnswerAsync(order: null, isSuccess: false, failureMessage: "PayPal capture returned a non-success status.");
            return StatusCode((int)result.StatusCode, new
            {
                message = "PayPal Capture Failed",
                details = result.Data // The SDK maps error JSON into Data on failure
            });
        }
        catch (Exception ex)
        {
            await UpdatePayFlowRequestAnswerAsync(order: null, isSuccess: false, failureMessage: ex.Message);
            var paypalErrEx = ex as PaypalServerSdk.Standard.Exceptions.ErrorException;
            if (paypalErrEx != null)
            {
                return StatusCode(paypalErrEx.ResponseCode, new
                {
                    paypalErrEx.Message,
                    paypalErrEx.Details,
                    paypalErrEx.Data,
                    paypalErrEx.DebugId,
                    paypalErrEx.Links,
                    paypalErrEx.Source
                });
            }
            Console.Error.WriteLine($"Failed to capture order {orderId}: {ex.Message}");
            return StatusCode(500, new
            {
                ex.Message,
                ex.Data,
                ex.Source
            });
        }
    }
    private async Task<PaypalServerSdk.Standard.Http.Response.ApiResponse<Order>> _CaptureOrder(string orderID)
    {
        CaptureOrderInput captureOrderInput = new CaptureOrderInput
        {
            Id = orderID,
            // Idempotency Key (Prevents double-charging if the user clicks twice).
            // Must be deterministic per order so a timeout/retry reuses the same
            // key and PayPal returns the original capture instead of charging again.
            PaypalRequestId = $"{orderID}-capture",
            // Tells PayPal to return the full order object in the response
            Prefer = "return=representation"
        };
#if DEBUG
        using (StackExchange.Profiling.MiniProfiler.Current?.CustomTiming("paypal", "POST /v2/checkout/orders/capture"))
        {
#endif
            // This handles the auth token, headers, and body formatting automatically
            return await _ordersController.CaptureOrderAsync(captureOrderInput);
#if DEBUG
        }
#endif
    }


}