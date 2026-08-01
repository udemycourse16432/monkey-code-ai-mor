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
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly IReggaeDbContextProcedures _procedures;
    private readonly OrderService _orderService;
    private readonly CartService _cartService;
    private readonly ShippingService _shippingService;
    private readonly ReggaeDbContext _context;

    private readonly Dictionary<string, CheckoutPaymentIntent> _paymentIntentMap;
    private readonly OrdersController _ordersController;
    private readonly PaymentsController _paymentsController;

    public CheckoutController(Microsoft.Extensions.Configuration.IConfiguration config, IHttpClientFactory httpClientFactory, IReggaeDbContextProcedures procedures,
        OrderService orderService, CartService cartService, ShippingService shippingService, ReggaeDbContext context)
    {
        _config = config;
        _httpClientFactory = httpClientFactory;
        _orderService = orderService;
        _cartService = cartService;
        _shippingService = shippingService;
        _procedures = procedures;
        _context = context;
        _paymentIntentMap = new Dictionary<string, CheckoutPaymentIntent> {
            {
                "CAPTURE",
                CheckoutPaymentIntent.Capture
            },
            {
                "AUTHORIZE",
                CheckoutPaymentIntent.Authorize
            }
        };
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
        _paymentsController = client.PaymentsController;

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
    private async Task<(decimal ProductsPrice, decimal ShippingCost)> CalculateCheckoutTotals(string shippingCode, List<(Cart Cart, Inventory Inv)> cartResults)
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

        return (productsPrice, shippingCost);
    }
    public record CreateOrderRequest(string ShippingCode);

    [HttpPost("create-order")]
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
            return StatusCode((int)result.StatusCode, new
            {
                message = "PayPal Order Creation Failed",
                details = result.Data // The SDK maps the error JSON into the Data property on failure
            });
        }
        catch (Exception ex)
        {
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
                Intent = _paymentIntentMap["CAPTURE"],
                Payer = new Payer
                {
                    Name = new Name
                    {
                        GivenName = "",
                        Surname = ""
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
                            MValue = (checkoutData.ProductsPrice + checkoutData.ShippingCost).ToString("F2"),
                            Breakdown = new AmountBreakdown {
                              ItemTotal = new Money("USD", checkoutData.ProductsPrice.ToString("F2")),
                              Shipping = new Money("USD", checkoutData.ShippingCost.ToString("F2"))
                            },
                        },
                        Shipping = new ShippingDetails {
                            Type = FulfillmentType.Shipping,
                            Name = new ShippingName(customerDetails.BillingFullName),
                            PhoneNumber = new PhoneNumberWithCountryCode("1", cleanedPhone),
                            Address = new Address {
                                AddressLine1 = customerDetails.BillingStreetAddress1,
                                AddressLine2 = customerDetails.BillingStreetAddress2,
                                AdminArea1 = (await GetStateCode(customerDetails.BillingStateProvince)),
                                AdminArea2 = customerDetails.BillingCity,
                                PostalCode = customerDetails.BillingPostalCode,
                                CountryCode = GetCountryCode(customerDetails.BillingCountry)
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
        return result;
#if DEBUG
        }
#endif
    }
    private static string SanitizePhoneNumber(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;

        // Removes everything except 0-9
        return Regex.Replace(phone, @"\D", "");
    }
    
    private readonly Dictionary<string, string?> _stateCodeCache = new(StringComparer.OrdinalIgnoreCase);

    private async Task<string?> GetStateCode(string stateName)
    {
        if (string.IsNullOrWhiteSpace(stateName)) return null;

        // 2. Check if we already looked this up during this request
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

            var result = await _CaptureOrder(orderId);

            // 1. Success Path (200-299)
            if (result.StatusCode >= 200 && result.StatusCode < 300)
            {
                string userAgent = Request.Headers["User-Agent"].ToString();
                var totalWeightGrams = HttpContext.Session.GetTotalWeightGrams();
                decimal? weight = 0m;
                var weightResults = await _procedures.spGetWeightOfProductAsync(activeCartName);
                string notChangedAddress = "-";
                string noCreditCardNumber = "";
                string noExpDate = "";
                string poNumber = null;
                string yesPrintedInvoice = "y";
                string noHowFoundUs = "-";
                string remHost = Request.Headers["X-Forwarded-For"].FirstOrDefault() ?? HttpContext.Connection.RemoteIpAddress?.ToString() ?? null;
                string sessionId = HttpContext.Session.Id;
                string selectedShippingMethod = HttpContext.Session.GetSelectedShippingCode() ?? "Not Selected";
                string orderedStatus = "ordered";
                var ipAddress = remHost ?? "Unknown";
                string noOrderNotes = ""; // TODO: You can implement logic to generate order notes based on the order details and pass that here instead of an empty string.
                
                var purchaseUnit = result.Data.PurchaseUnits.First();
                var orderNumber = purchaseUnit.InvoiceId ?? result.Data.Id; // Fallback to Order ID if Invoice ID is not set
                decimal? shipping = purchaseUnit.Amount.Breakdown.Shipping.MValue != null ? decimal.Parse(purchaseUnit.Amount.Breakdown.Shipping.MValue) : 0m;
                decimal? orderTotal = purchaseUnit.Amount.MValue != null ? decimal.Parse(purchaseUnit.Amount.MValue) : 0m;
                decimal? creditCardAmountPaid = orderTotal; // Since we just captured the payment, the amount paid is equal to the order total
                decimal? totalPrice = purchaseUnit.Amount.Breakdown.ItemTotal.MValue != null ? decimal.Parse(purchaseUnit.Amount.Breakdown.ItemTotal.MValue) : 0m;
                int? totalQuantity = purchaseUnit.Items?.Sum(x => int.Parse(x.Quantity)) ?? 0;
                
                await _procedures.spRecordPurchaseAsync(
                    c.LogInEmail, 
                    c.Password, 
                    c.PriceGroup,
                    userAgent,
                    weightResults.FirstOrDefault()?.sumweight ?? weight,
                    DateTime.UtcNow,
                    customerServerCounter,
                    notChangedAddress,
                    c.PowerUserName,
                    remHost,
                    sessionId,
                    selectedShippingMethod,
                    noCreditCardNumber,
                    noExpDate,
                    creditCardAmountPaid,
                    poNumber,
                    yesPrintedInvoice,
                    c.Email,
                    "Mail", // ShippingMethodPullSheetText TODO: This is currently hardcoded because we don't have a "pull sheet text" value from the shipping options. You may want to map your shipping codes to pull sheet texts in the future and store that in the session as well.
                    c.Phone,
                    c.FullName,
                    c.StreetAddress1,
                    c.StreetAddress2,
                    c.City,
                    c.Island,
                    c.StateProvince,
                    c.PostalCode,
                    c.Country,
                    c.BillingFullName,
                    c.BillingStreetAddress1,
                    c.BillingStreetAddress2,
                    c.BillingCity,
                    c.BillingIsland,
                    c.BillingStateProvince,
                    c.BillingPostalCode,
                    c.BillingCountry,
                    noHowFoundUs,
                    orderedStatus,
                    orderNumber,
                    "201", // OrderProcessChoice TODO: This is currently hardcoded because we don't have multiple order process choices. You may want to determine this value based on the order details in the future and store it in the session as well.
                    customerID.ToString(),
                    0m, // PayPalAmountDue is 0 because we just captured the payment successfully
                    0m, // GoogleCheckoutAmountDue (not used)
                    0m, // WesternUnionAmountDue (not used)
                    0m, // CheckCashorMoneyOrderAmountDue (not used
                    ipAddress,
                    noOrderNotes,
                    shipping,
                    0m, // Tax is 0 because we are not calculating tax in this example. You may want to implement tax calculation logic in the future and pass the calculated tax amount here instead of 0.
                    totalPrice,
                    orderTotal,
                    totalQuantity,
                    0m, // GiftCardAmount is 0 because we are not handling gift cards in this example. You may want to implement gift card logic in the future and pass the gift card amount here instead of 0.
                    null, // GiftCardNumber is null because we are not handling gift cards in this example. You may want to implement gift card logic in the future and pass the gift card number here instead of null.
                    0, // GiftCardAccountsServerCounter is 0 because we are not handling gift cards in this example. You may want to implement gift card logic in the future and pass the appropriate server counter here instead of 0.
                    1, // NumberOfLineItems is 1 for simplicity since we are not currently summing up the quantities of individual items in the order. You may want to implement logic to calculate the total number of line items based on the order details in the future and pass that value here instead of 1.
                    activeCartName
                    );
                
                // This returns the Order object containing capture details,
                var deleteCount = await _procedures.DeleteBackordersAsync(activeCartName, customerID);
                Console.WriteLine($"DeleteBackordersAsync result count: {deleteCount}");

                // spOrderedQueries
                var orderedQueriesCount = await _procedures.spOrderedQueriesAsync(activeCartName, guestCartName, customerServerCounter);
                Console.WriteLine($"spOrderedQueriesAsync result count: {orderedQueriesCount}");


                return StatusCode((int)result.StatusCode, result.Data);
            }

            // 2. Failure Path (Descriptive Error)
            // This mimics your old 'BadRequest(errorBody)' logic
            return StatusCode((int)result.StatusCode, new
            {
                message = "PayPal Capture Failed",
                details = result.Data // The SDK maps error JSON into Data on failure
            });
        }
        catch (Exception ex)
        {
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
            // Idempotency Key (Prevents double-charging if the user clicks twice)
            PaypalRequestId = Guid.NewGuid().ToString(),
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