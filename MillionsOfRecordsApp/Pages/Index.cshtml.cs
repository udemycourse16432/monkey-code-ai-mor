using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.Shared;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages
{
    public class IndexModel : MillionsBasePageModel
    {
        public IndexModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures) : base(context, cartService, procedures)
        {
        }

        public Dictionary<string, (string Title, List<Inventory> Items, string FormatLink, string Order, string? UsedItem, string HeaderTitle)> Sections { get; set; } = new();
        public HashSet<int> ItemsInCart { get; set; } = new();
        // In Legacy app: varWeightOfProductInGrams
        public int TotalCartWeight { get; set; }
        public string SearchId { get; set; } = string.Empty;
        public async Task OnGetAsync()
        {
            string nameOfCart = HttpContext.Session.GetActiveCartName();

            // Get all ItemIDs in this cart in ONE query
            var itemIds = await _context.Carts
                .Where(c => c.CartName == nameOfCart)
                .Select(c => c.ItemId)
                .ToListAsync();

            ItemsInCart = new HashSet<int>(itemIds);

            SearchId = HttpContext.Session.GetSearchId();
            // 1. Define the base filters
            var baseQuery = _context.Inventories.Where(x => x.Inventory1 > 0 && x.Deleted == "n" && x.ShowOnWebsite == "y");
            var isNew = baseQuery.Where(x => x.UsedItem == null || x.UsedItem == "n");

            // 2. Execute categorized methods
            await LoadLpSections(isNew);
            await LoadCdSections(isNew);
            await LoadSevenInchSections(baseQuery, isNew);
            await LoadTenTwelveInchSections(isNew);

            ////////////////////////////////////////////////
        }

        private async Task LoadLpSections(IQueryable<Inventory> isNew)
        {
            var lpQuery = isNew.Where(x => x.Format == "LP");

            Sections.Add("BestSellingLPs", ("Best Selling LP's",
                await lpQuery.OrderByDescending(x => x.SalesLast30Days).ThenByDescending(x => x.Inventory1).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.LP, AppConstants.ShopSortOrders.BestSellers, "n", "\"Best Selling LPs\""));

            Sections.Add("NewReleaseLPs", ("New Release LP's",
                await lpQuery.OrderByDescending(x => x.InStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.LP, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"New Arrival LPs\""));

            Sections.Add("BackInStockLPs", ("Back In Stock LP's",
                await lpQuery.OrderByDescending(x => x.BackInStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.LP, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"Back In Stock LPs\""));
        }
        private async Task LoadCdSections(IQueryable<Inventory> isNew)
        {
            var cdQuery = isNew.Where(x => x.Format == "CD");

            Sections.Add("BestSellingCDs", ("Best Selling CD's",
                await cdQuery.OrderByDescending(x => x.SalesLast30Days).ThenByDescending(x => x.Inventory1).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.CD, AppConstants.ShopSortOrders.BestSellers, "n", "\"Best Selling CDs\""));

            Sections.Add("NewReleaseCDs", ("New Release CD's",
                await cdQuery.OrderByDescending(x => x.InStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.CD, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"New Arrival CDs\""));

            Sections.Add("BackInStockCDs", ("Back In Stock CD's",
                await cdQuery.OrderByDescending(x => x.BackInStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.CD, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"Back In Stock CDs\""));
        }
        private async Task LoadSevenInchSections(IQueryable<Inventory> baseQuery, IQueryable<Inventory> isNew)
        {
            var sevenQuery = isNew.Where(x => x.Format == "7\"");

            Sections.Add("BestSelling7", ("Best Selling 7\"",
                await sevenQuery.OrderByDescending(x => x.SalesLast30Days).ThenByDescending(x => x.Inventory1).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.SevenInch, AppConstants.ShopSortOrders.BestSellers, "n", "\"Best Selling 7 Inch\""));

            Sections.Add("NewRelease7", ("New Release 7\"",
                await sevenQuery.OrderByDescending(x => x.InStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.SevenInch, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"New Arrival 7 Inch\""));

            Sections.Add("UsedCollectible7", ("Used Collectible 7\"",
                await baseQuery.Where(x => x.Format == "7\"" && x.UsedItem == "y").OrderByDescending(x => x.InStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.SevenInch, AppConstants.ShopSortOrders.NewestArrivals, "y", "\"Used-Collectible 7 Inch\""));

            Sections.Add("BackInStock7", ("Back In Stock 7\"",
                await sevenQuery.OrderByDescending(x => x.BackInStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.SevenInch, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"Back In Stock 7 Inch\""));
        }
        private async Task LoadTenTwelveInchSections(IQueryable<Inventory> isNew)
        {
            var multiQuery = isNew.Where(x => x.Format == "12\"" || x.Format == "10\"");

            Sections.Add("BestSelling12_10", ("Best Selling 12\" / 10\"",
                await multiQuery.OrderByDescending(x => x.SalesLast30Days).ThenByDescending(x => x.Inventory1).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.TwelveAndTenInch, AppConstants.ShopSortOrders.BestSellers, "n", "\"Best Selling 12 Inch/10 Inch\""));

            Sections.Add("NewRelease12_10", ("New Release 12\" / 10\"",
                await multiQuery.OrderByDescending(x => x.InStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.TwelveAndTenInch, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"New Arrival 12 Inch/10 Inch\""));

            Sections.Add("BackInStock12_10", ("Back In Stock 12\" / 10\"",
                await multiQuery.OrderByDescending(x => x.BackInStockDate).ThenByDescending(x => x.Id).Take(4).ToListAsync(), AppConstants.ShopFormats.TwelveAndTenInch, AppConstants.ShopSortOrders.NewestArrivals, "n", "\"Back In Stock 12 Inch/10 Inch\""));
        }
    }
}
