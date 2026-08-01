using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.DTOs;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages
{
    public class CheckoutModel : MillionsBasePageModel
    {
        private readonly IConfiguration _config;
        private readonly ShippingService _shippingService;
        private readonly OrderService _orderService;
        public CheckoutModel(ReggaeDbContext context, IReggaeDbContextProcedures procedures, ShippingService shippingService, CartService cartService, IConfiguration config, OrderService orderService) :
            base(context, cartService, procedures)
        {
            _shippingService = shippingService;
            _config = config;
            _orderService = orderService;
        }
        public List<ShippingMethodDto> ShippingMethods { get; set; } = new();

        [BindProperty]
        public string SelectedShippingCode { get; set; } = ""; // Syncs with radio buttons
        [BindProperty]
        public decimal SelectedShippingCost { get; set; } = 10.45m;
        public string FullName { get; set; } = "";
        public string StreetAddress1 { get; set; } = "";
        public string StreetAddress2 { get; set; } = "";
        public string City { get; set; } = "";
        public string StateProvince { get; set; } = "";
        public string PostalCode { get; set; } = "";
        public string Country { get; set; } = "";
        public string Email { get; set; } = "";
        public string Phone { get; set; } = "";
        public string BillingFullName { get; set; } = "";
        public string BillingStreetAddress1 { get; set; } = "";
        public string BillingStreetAddress2 { get; set; } = "";
        public string BillingCity { get; set; } = "";
        public string BillingStateProvince { get; set; } = "";
        public string BillingPostalCode { get; set; } = "";
        public string BillingCountry { get; set; } = "";
        public decimal ProductsPrice { get; set; }
        public decimal ShippingCost { get; set; }
        public decimal TotalAmount => ProductsPrice + ShippingCost;
        public string SearchId { get; set; } = string.Empty;
        public List<CartItemDto> CartItems { get; set; } = new();

        public string varOrderNumber { get; set; } = string.Empty;

        public async Task<IActionResult> OnGetAsync()
        {
            SearchId = HttpContext.Session.GetSearchId();

            if (!HttpContext.Session.IsLoggedIn())
            {
                return RedirectToPage("/SignIn", new { returnUrl = "/checkout" });
            }
            else
            {
                varOrderNumber = await _orderService.GenerateUniqueOrderNumberAsync();

                var counter = HttpContext.Session.GetCustomerServerCounter();
                List<spGetCustomerDetailsByServerCounterResult> spGetCustomerDetailsByServerCounterResults = await _procedures.spGetCustomerDetailsByServerCounterAsync(counter);
                if (spGetCustomerDetailsByServerCounterResults.Count > 0)
                {
                    var customerDetails = spGetCustomerDetailsByServerCounterResults.First();
                    FullName = customerDetails.FullName;
                    StreetAddress1 = customerDetails.StreetAddress1;
                    StreetAddress2 = customerDetails.StreetAddress2;
                    City = customerDetails.City;
                    StateProvince = customerDetails.StateProvince;
                    PostalCode = customerDetails.PostalCode;
                    Country = customerDetails.Country;
                    Email = customerDetails.Email;
                    Phone = customerDetails.Phone;
                    BillingFullName = customerDetails.BillingFullName;
                    BillingStreetAddress1 = customerDetails.BillingStreetAddress1;
                    BillingStreetAddress2 = customerDetails.BillingStreetAddress2;
                    BillingCity = customerDetails.BillingCity;
                    BillingStateProvince = customerDetails.BillingStateProvince;
                    BillingPostalCode = customerDetails.BillingPostalCode;
                    BillingCountry = customerDetails.BillingCountry;

                    var cartName = HttpContext.Session.GetActiveCartName();

                    List<(Cart Cart, Inventory Inv)> cartResults = await _cartService.GetCartDetailsAsync(cartName);

                    ProductsPrice = cartResults.Sum(x => x.Cart.Price * x.Cart.Quantity);
                    int totalCartItems = cartResults.Sum(x => x.Cart.Quantity);
                    var results = await _procedures.spGetWeightOfProductAsync(cartName);
                    var result = results.FirstOrDefault();
                    if (result != null)
                    {
                        HttpContext.Session.SetTotalWeightGrams((int)(result.sumweight));
                    }
                    ShippingMethods = await _shippingService.CalculateShippingOptionsAsync(customerDetails, ProductsPrice, totalCartItems, HttpContext.Session.GetTotalWeightGrams());
                    SelectedShippingCode = ShippingMethods.FirstOrDefault()?.Code ?? "";
                    ShippingCost = await _shippingService.FindZoneAndCalculateShippingChargeAsync(ProductsPrice, totalCartItems);
                    var imgBase = _config["Appsettings:ImagesPath"] ?? "https://cdn.millionsofrecords.com/inventory_images/";
                    CartItems = cartResults.Select(r => new CartItemDto
                    {
                        ID = r.Inv.Id,
                        ArtistTitle = r.Inv.ArtistTitle,
                        Format = r.Inv.Format,
                        Price = r.Cart.Price,
                        Quantity = r.Cart.Quantity,
                        Label = r.Inv.Label,
                        YearFrom = r.Inv.YearFrom,
                        YearTo = r.Inv.YearTo,
                        Genre1 = r.Inv.Genre1,
                        SaveForLater = r.Cart.SaveForLater,
                        FrontImg = $"{imgBase}{r.Inv.GetImagePath(size: "SMALL")}",
                    }).ToList();
                }
            }
            return Page();
        }
    }
}