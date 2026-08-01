using Microsoft.AspNetCore.Mvc;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages
{
    public class WholesaleAcceptedModel : MillionsBasePageModel
    {
        private readonly CartService _cartService;

        public WholesaleAcceptedModel(
            ReggaeDbContext context,
            CartService cartService,
            IReggaeDbContextProcedures procedures)
            : base(context, cartService, procedures)
        {
            _cartService = cartService;
        }

        public int QuantityTotal { get; private set; }
        public string CartItemText { get; private set; } = "Cart: $0.00";

        public async Task<IActionResult> OnGetAsync()
        {
            // Execute cart migration logic if migrating from retail guest cart to wholesale customer cart
            await MigrateCartIfNecessaryAsync();

            // Clear 'Chosen' cookie as in legacy code
            Response.Cookies.Delete("Chosen");

            // Retrieve cart total item count
            string cartName = GetCartName();
            var totals = await _procedures.spGetCartTotalsWholesalePriceAsync(cartName);

            if (totals != null && totals.Any())
            {
                QuantityTotal = totals.Sum(x => x.Quantity ?? 0);
            }

            // Format cart text output
            if (QuantityTotal == 1)
            {
                CartItemText = "1 Item";
            }
            else if (QuantityTotal > 1)
            {
                CartItemText = $"{QuantityTotal} Items";
            }
            else
            {
                CartItemText = "Cart: $0.00";
            }

            return Page();
        }

        private async Task MigrateCartIfNecessaryAsync()
        {
            string powerUser = HttpContext.Session.GetString("PowerUserName") ?? string.Empty;
            string priceGroup = HttpContext.Session.GetString("PriceGroup") ?? string.Empty;
            int? customerServerCounter = HttpContext.Session.GetInt32("CustomerServerCounter");

            bool isWholesaleGroup = string.Equals(priceGroup, "StorePrice", StringComparison.OrdinalIgnoreCase) ||
                                   string.Equals(priceGroup, "ExportPrice", StringComparison.OrdinalIgnoreCase);

            if (string.IsNullOrEmpty(powerUser) && isWholesaleGroup && customerServerCounter.HasValue)
            {
                string extension = HttpContext.Session.GetString("CartRandomNumbersExtension") ?? string.Empty;
                string retailCartName = $"CART{HttpContext.Session.Id}{extension}";
                string wholesaleCartName = $"W_CART_{customerServerCounter.Value}";

                // 1. Fetch retail cart items
                var cartItems = await _procedures.spGetCartItemsAsync(retailCartName);

                if (cartItems != null && cartItems.Any())
                {
                    foreach (var item in cartItems)
                    {
                        if ((item.Quantity) <= 0)
                        {
                            await _procedures.spDeleteCartItemAsync(retailCartName, item.ItemID);
                        }
                        else
                        {
                            decimal wholesalePrice = 0;
                            var invResults = await _procedures.spGetInventoryItemAsync(item.ItemID);
                            var inv = invResults?.FirstOrDefault();

                            if (inv != null)
                            {
                                bool isOnSale = false;
                                if (inv.Sale_WholesalePrice.HasValue && inv.Sale_WholesaleEndDate.HasValue)
                                {
                                    if ((inv.Sale_WholesaleEndDate.Value - DateTime.Now).TotalDays >= 0)
                                    {
                                        isOnSale = true;
                                    }
                                }

                                if (isOnSale)
                                {
                                    wholesalePrice = inv.Sale_WholesalePrice ?? 0;
                                }
                                else if (string.Equals(priceGroup, "StorePrice", StringComparison.OrdinalIgnoreCase))
                                {
                                    wholesalePrice = inv.StorePrice;
                                }
                                else if (string.Equals(priceGroup, "ExportPrice", StringComparison.OrdinalIgnoreCase))
                                {
                                    wholesalePrice = inv.ExportPrice ?? 0;
                                }
                            }

                            await _procedures.spAddRetailCartItemToWholesaleCartAsync(
                                wholesaleCartName,
                                item.ItemID,
                                item.Quantity,
                                wholesalePrice,
                                item.SearchCriteriaStatisticsID,
                                item.IPAddress
                            );
                        }
                    }

                    // 2. Clean up retail cart and update customer record
                    await _procedures.spDeleteCartAsync(retailCartName);
                    await _procedures.spUpdateCartQuantityInCustomersTableAsync(customerServerCounter.Value);
                }
            }
        }

        private string GetCartName()
        {
            int? customerServerCounter = HttpContext.Session.GetInt32("CustomerServerCounter");
            if (customerServerCounter.HasValue && customerServerCounter.Value > 0)
            {
                return $"W_CART_{customerServerCounter.Value}";
            }

            string extension = HttpContext.Session.GetString("CartRandomNumbersExtension") ?? string.Empty;
            return $"CART{HttpContext.Session.Id}{extension}";
        }
    }
}