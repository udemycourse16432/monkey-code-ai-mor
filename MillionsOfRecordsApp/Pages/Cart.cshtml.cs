using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.DTOs;
using MillionsOfRecordsApp.Models.Shared;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.Data;

namespace MillionsOfRecordsApp.Pages
{
    public class CartModel : MillionsBasePageModel
    {
        private readonly IConfiguration _config;
        private readonly ShippingService _shippingService;
        public CartModel(ReggaeDbContext context, IConfiguration config, CartService cartService, ShippingService shippingService, IReggaeDbContextProcedures procedures) :
            base(context, cartService, procedures)
        {
            _config = config;
            _shippingService = shippingService;
        }
        public List<CartItemDto> CartItems { get; set; } = new();
        public decimal ShippingFee { get; set; }
        public decimal ProductsPrice => CartItems.Sum(x => x.Price * x.Quantity);
        public decimal TotalAmount => ProductsPrice + ShippingFee;
        public async Task OnGetAsync()
        {
            string cartName = this.HttpContext.Session.GetActiveCartName();
            bool isLoggedIn = HttpContext.Session.IsLoggedIn();

            // Get Weight
            var results = await _procedures.spGetWeightOfProductAsync(cartName);
            var result = results.FirstOrDefault();
            if (result != null)
            {
                HttpContext.Session.SetTotalWeightGrams((int)(result.sumweight));
            }

            if (isLoggedIn)
            {
                List<spResidentialDeliveryResult> spResidentialDeliveryResults = await _procedures.spResidentialDeliveryAsync(HttpContext.Session.GetCustomerServerCounter());
                if (spResidentialDeliveryResults.Any())
                {
                    var residentialDelivery = spResidentialDeliveryResults.First().ResidentialDelivery == AppConstants.Y ? AppConstants.YES : AppConstants.NO;
                    HttpContext.Session.SetResidentialDelivery(residentialDelivery);
                }
            }

            await _cartService.UpdateCartsPriceAsync(cartName, isLoggedIn);

            await _procedures.spCartPricesSalePricesTooAsync(cartName);


            // 3. Step 4 from your Profiler: Calculate Totals (Internal to DB usually, or fetch here)
            // For now, we fetch the items directly to match your UI
            await LoadCartItemsAsync(cartName);

        }
        private async Task LoadCartItemsAsync(string cartName)
        {
            var priceGroup = HttpContext.Session.GetPriceGroupWithFallback();
            decimal cartTotal = 0;
            int totalCartItems = 0;
            if (priceGroup == AppConstants.PriceGroups.RetailPrice)
            {
                List<Models.spGetCartTotalsRetailPriceResult> cartRetailTotals = await _procedures.spGetCartTotalsRetailPriceAsync(cartName);
                cartTotal = cartRetailTotals.Sum(x => (x.PriceForCart ?? 0) * (x.Quantity ?? 0));
                totalCartItems = cartRetailTotals.Sum(x => x.Quantity ?? 0);
            }
            else
            {
                List<Models.spGetCartTotalsWholesalePriceResult> cartWholesaleTotals = await _procedures.spGetCartTotalsWholesalePriceAsync(cartName);
                cartTotal = cartWholesaleTotals.Sum(x => (x.PriceForCart ?? 0) * (x.Quantity ?? 0));
                totalCartItems = cartWholesaleTotals.Sum(x => x.Quantity ?? 0);
            }


            //var cartTotal = cartResults.Sum(x => x.Cart.Price * x.Cart.Quantity);
            //int totalCartItems = cartResults.Sum(x => x.Cart.Quantity);
            ShippingFee = await _shippingService.FindZoneAndCalculateShippingChargeAsync(cartTotal, totalCartItems, isV1: false, WeightInGrams: HttpContext.Session.GetTotalWeightGrams());

            var cartResults = await _cartService.GetCartDetailsAsync(cartName);

            var imgBase = _config["Appsettings:ImagesPath"] ?? "https://cdn.millionsofrecords.com/inventory_images/";

            CartItems = cartResults.Select(r => new CartItemDto
            {
                ID = r.Inv.Id,
                ArtistTitle = r.Inv.ArtistTitle,
                Price = r.Cart.Price,
                Quantity = r.Cart.Quantity,
                Label = r.Inv.Label,
                YearFrom = r.Inv.YearFrom,
                YearTo = r.Inv.YearTo,
                Genre1 = r.Inv.Genre1,
                SaveForLater = r.Cart.SaveForLater,
                FrontImg = $"{imgBase}{r.Inv.GetImagePath(size: "MEDIUM")}",
                BackImg = $"{imgBase}{r.Inv.GetImagePath(size: "MEDIUM", letter: "B")}",
                LargeFrontImg = $"{imgBase}{r.Inv.GetImagePath(size: "LARGE")}",
                LargeBackImg = $"{imgBase}{r.Inv.GetImagePath(size: "LARGE", letter: "B")}",
                Features = r.Inv.GetParsedFeatures(),
                ShowSimilarItems = r.Inv.ShouldShowSimilarItemsAvailability()
            }).ToList();

            /*
             'Similar Items
                varSimilarItemsAvailable = 0
                If IsDBSomething(xx("YearFrom"), "") <> "" Then
                    If varListYearToOriginal <> "" Then
                        If Not IsDBNull(xx("Genre1")) And IsNumeric(IsDBSomething(xx("YearFrom"), "")) And IsNumeric(IsDBSomething(xx("YearTo"), "")) Then
                            If CInt(IsDBSomething(xx("YearTo"), "")) - CInt(IsDBSomething(xx("YearFrom"), "")) < 6 Then
                                varSimilarItemsAvailable = 1
                            End If
                        End If
                    Else
                        If Not IsDBNull(xx("Genre1")) And IsNumeric(IsDBSomething(xx("YearFrom"), "")) Then
                            varSimilarItemsAvailable = 1
                        End If
                    End If
                End If
                z = z + 1
                RecordNumber = RecordNumber + 1
                If varSimilarItemsAvailable = 1 Then
                    If IsDBSomething(xx("FormatOrder"), 0) < varCVFormatOrder Then
                        varCVFormatOrder = IsDBSomething(xx("FormatOrder"), 0)
                        varCVSalesLast30Days = IsDBSomething(xx("SalesLast30Days"), 0)
                        varCVItemID = xx("ID")
                    End If
                    If IsDBSomething(xx("SalesLast30Days"), 0) > varCVSalesLast30Days And IsDBSomething(xx("FormatOrder"), 0) <= varCVFormatOrder Then
                        varCVFormatOrder = IsDBSomething(xx("FormatOrder"), 0)
                        varCVSalesLast30Days = IsDBSomething(xx("SalesLast30Days"), 0)
                        varCVItemID = xx("ID")
                    End If
                End If
             */
        }
    }
}