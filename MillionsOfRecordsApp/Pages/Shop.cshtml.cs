using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Models.Shared;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;

namespace MillionsOfRecordsApp.Pages;

public class PriceFilterItem
{
    public string Label { get; set; } = string.Empty;
    public int Value { get; set; }
    public decimal Price { get; set; }
    public bool IsOverPrice { get; set; }
}

public class ShopModel : MillionsBasePageModel
{
    public ShopModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures)
        : base(context, cartService, procedures) { }

    public const int PageSize = 48;

    public ShowListViewModel ViewModel { get; set; } = new ShowListViewModel();
    public HashSet<int> ItemsInCart { get; set; } = new();
    public string SearchId { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "order")]
    public string Order { get; set; } = string.Empty;

    [FromQuery(Name = "page")]
    public int PageNum { get; set; } = 1;

    [BindProperty(SupportsGet = true, Name = "format")]
    public string CurrentFormat { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "min_price")]
    public decimal? MinPrice { get; set; }

    [BindProperty(SupportsGet = true, Name = "max_price")]
    public decimal? MaxPrice { get; set; }

    [BindProperty(SupportsGet = true, Name = "useditem")]
    public string? UsedItem { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "genre")]
    public string CurrentGenre { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "label")]
    public string CurrentArtistLabel { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "title")]
    public string CurrentArtistTitle { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "artist")]
    public string CurrentArtist { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "sid")]
    public string CurrentSimilarArtist { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "feaitem")]
    public string FeatureItem { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "year")]
    public string CurrentYear { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "rhythm")]
    public string CurrentRhythm { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true, Name = "desc")]
    public string SearchHeaderDescription { get; set; } = string.Empty;

    public List<PriceFilterItem> PriceFilterList { get; } = new()
    {
        new() { Label = "Under $2", Value = 1, Price = 2m },
        new() { Label = "Under $3", Value = 2, Price = 3m },
        new() { Label = "Under $5", Value = 3, Price = 5m },
        new() { Label = "Under $8", Value = 4, Price = 8m },
        new() { Label = "Under $10", Value = 5, Price = 10m },
        new() { Label = "Under $12", Value = 6, Price = 12m },
        new() { Label = "Under $14", Value = 7, Price = 14m },
        new() { Label = "Under $16", Value = 8, Price = 16m },
        new() { Label = "Under $18", Value = 9, Price = 18m },
        new() { Label = "Under $20", Value = 10, Price = 20m },
        new() { Label = "Under $25", Value = 11, Price = 25m },
        new() { Label = "Under $30", Value = 12, Price = 30m },
        new() { Label = "Over $20", Value = 13, Price = 20m, IsOverPrice = true },
        new() { Label = "Over $50", Value = 14, Price = 50m, IsOverPrice = true },
        new() { Label = "Over $100", Value = 15, Price = 100m, IsOverPrice = true }
    };

    public async Task<IActionResult> OnGetAsync()
    {
        SearchId = HttpContext.Session.GetSearchId();

        // Fallback check if bound property missed mixed-case query string "Rhythm"
        if (string.IsNullOrWhiteSpace(CurrentRhythm) && HttpContext.Request.Query.TryGetValue("Rhythm", out var rhythmQuery))
        {
            CurrentRhythm = rhythmQuery.ToString();
        }

        // 1. ISOLATE SIMILAR ITEMS ROUTE
        if (!string.IsNullOrWhiteSpace(CurrentSimilarArtist) && int.TryParse(CurrentSimilarArtist, out int seedItemId))
        {
            return await HandleSimilarItemsAsync(seedItemId);
        }

        // 2. STANDARD CATALOG ROUTE
        return await HandleStandardShopAsync();
    }

    private async Task<IActionResult> HandleSimilarItemsAsync(int seedItemId)
    {
        var seedItem = await _context.Inventories.FirstOrDefaultAsync(i => i.Id == seedItemId);
        if (seedItem == null)
        {
            return RedirectToPage("/Shop");
        }

        // Set header description for similar items search
        SearchHeaderDescription = "\"Show Similar Items\"";

        // --- STEP A: Validate & Clean Price Dropdown Selection ---
        var allowedUnderPrices = PriceFilterList.Where(f => !f.IsOverPrice).Select(f => f.Price).ToHashSet();
        var allowedOverPrices = PriceFilterList.Where(f => f.IsOverPrice).Select(f => f.Price).ToHashSet();

        if (MinPrice.HasValue && !allowedOverPrices.Contains(MinPrice.Value))
        {
            MinPrice = null;
        }
        if (MaxPrice.HasValue && !allowedUnderPrices.Contains(MaxPrice.Value))
        {
            MaxPrice = null;
        }

        // --- STEP B: Parse Seed Year & Build ±1 Year Tolerance Window ---
        int? parsedYear = null;
        if (int.TryParse(seedItem.YearFrom, out int yFrom) && yFrom > 0)
        {
            parsedYear = yFrom;
        }
        else if (int.TryParse(seedItem.YearTo, out int yTo) && yTo > 0)
        {
            parsedYear = yTo;
        }

        string seedYearFromStr = parsedYear.HasValue ? (parsedYear.Value - 1).ToString() : string.Empty;
        string seedYearToStr = parsedYear.HasValue ? (parsedYear.Value + 1).ToString() : string.Empty;
        bool hasValidYearRange = parsedYear.HasValue;

        // --- STEP C: Fetch Seed Web Artists ---
        var seedArtists = await _context.WebArtists
            .Where(wa => wa.InventoryId == seedItemId && !string.IsNullOrEmpty(wa.Artist))
            .Select(wa => wa.Artist)
            .Distinct()
            .ToListAsync();

        if (!seedArtists.Any())
        {
            seedArtists.Add("zzz11zzzz");
        }

        // --- STEP D: Extract Primary Seed Genre Only ---
        string primaryGenre = !string.IsNullOrWhiteSpace(seedItem.Genre1) ? seedItem.Genre1.Trim() : string.Empty;
        bool hasGenres = !string.IsNullOrEmpty(primaryGenre);

        // --- STEP E: Extract Rhythm Name with Legacy Fallback ---
        string rhythmName = !string.IsNullOrWhiteSpace(seedItem.RhythmName)
            ? seedItem.RhythmName.Trim()
            : "qzqzqzqz";

        // --- STEP F: Build Base Query Pipeline ---
        var query = _context.Inventories.AsQueryable()
            .Where(i => i.Inventory1 > 0
                     && i.Deleted == "n"
                     && i.ShowOnWebsite == "y"
                     && i.StreetDate != null);

        // --- STEP G: Apply Format Filter ---
        if (!string.IsNullOrWhiteSpace(CurrentFormat))
        {
            if (CurrentFormat == AppConstants.ShopFormats.Vinyl)
            {
                query = query.Where(i =>
                    i.Format.StartsWith(AppConstants.ShopFormats.TwelveInch) ||
                    i.Format == AppConstants.ShopFormats.LP ||
                    i.Format.StartsWith(AppConstants.ShopFormats.SevenInch) ||
                    i.Format.StartsWith(AppConstants.ShopFormats.TenInch));
            }
            else if (CurrentFormat == AppConstants.ShopFormats.TwelveAndTenInch)
            {
                query = query.Where(i =>
                    i.Format.StartsWith(AppConstants.ShopFormats.TwelveInch) ||
                    i.Format.StartsWith(AppConstants.ShopFormats.TenInch));
            }
            else
            {
                query = query.Where(i => i.Format == CurrentFormat);
            }
        }

        // --- STEP H: Apply Used/New Condition Filter ---
        if (UsedItem == "y")
        {
            query = query.Where(i => i.UsedItem == "y");
        }
        else if (UsedItem == "n")
        {
            query = query.Where(i => i.UsedItem == null || i.UsedItem == "n");
        }

        // --- STEP I: Apply Price Range Filters ---
        if (MinPrice.HasValue || MaxPrice.HasValue)
        {
            DateTime activeToday = DateTime.Today;

            if (MinPrice.HasValue)
            {
                query = query.Where(i => ((i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= activeToday)
                    ? i.SaleRetailPrice
                    : (decimal?)i.RetailPrice) >= MinPrice.Value);
            }

            if (MaxPrice.HasValue)
            {
                query = query.Where(i => ((i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= activeToday)
                    ? i.SaleRetailPrice
                    : (decimal?)i.RetailPrice) <= MaxPrice.Value);
            }
        }

        // --- STEP J: Apply Similar Items Hierarchy Filter ---
        if (hasGenres)
        {
            query = query.Where(i =>
                (
                    (i.Genre1 == primaryGenre || i.Genre2 == primaryGenre || i.Genre3 == primaryGenre ||
                     i.Genre4 == primaryGenre || i.Genre5 == primaryGenre || i.Genre6 == primaryGenre ||
                     i.Genre7 == primaryGenre || i.Genre8 == primaryGenre || i.Genre9 == primaryGenre)
                    &&
                    (
                        !hasValidYearRange ||
                        (
                            (i.YearFrom != null && string.Compare(i.YearFrom, seedYearFromStr) >= 0 && string.Compare(i.YearFrom, seedYearToStr) <= 0) ||
                            (i.YearTo != null && string.Compare(i.YearTo, seedYearFromStr) >= 0 && string.Compare(i.YearTo, seedYearToStr) <= 0)
                        )
                    )
                )
                || _context.WebArtists.Any(wa => wa.InventoryId == i.Id && seedArtists.Contains(wa.Artist))
                || i.RhythmName == rhythmName
            );
        }
        else
        {
            query = query.Where(i =>
                _context.WebArtists.Any(wa => wa.InventoryId == i.Id && seedArtists.Contains(wa.Artist))
                || i.RhythmName == rhythmName
            );
        }

        // --- STEP K: Calculate Pagination Totals ---
        ViewModel.Pagination.TotalRecords = await query.CountAsync();
        ViewModel.Pagination.CurrentPage = PageNum < 1 ? 1 : PageNum;
        ViewModel.Pagination.TotalPages = (int)Math.Ceiling(ViewModel.Pagination.TotalRecords / (double)PageSize);

        // --- STEP L: Apply Dynamic Sorting ---
        if (string.IsNullOrWhiteSpace(Order) || !int.TryParse(Order, out var orderValue) || orderValue < 1 || orderValue > 6)
        {
            Order = AppConstants.ShopSortOrders.BestSellers;
        }

        IOrderedQueryable<Models.Inventory> sortedQuery;
        DateTime todayMidnight = DateTime.Today;

        switch (Order)
        {
            case AppConstants.ShopSortOrders.NewestArrivals:
                sortedQuery = query
                    .OrderBy(i => i.UsedItem)
                    .ThenByDescending(i => i.InStockDate > i.BackInStockDate ? i.InStockDate : i.BackInStockDate)
                    .ThenByDescending(i => i.Id);
                break;

            case AppConstants.ShopSortOrders.BestSellers:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenByDescending(i => i.SalesLast30Days)
                    .ThenByDescending(i => i.Inventory1)
                    .ThenByDescending(i => i.Id);
                break;

            case AppConstants.ShopSortOrders.Label:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => i.Label)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.PriceHighToLow:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenByDescending(i => (i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= todayMidnight)
                            ? i.SaleRetailPrice
                            : (decimal?)i.RetailPrice)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.PriceLowToHigh:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => (i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= todayMidnight)
                            ? i.SaleRetailPrice
                            : (decimal?)i.RetailPrice)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.Artist:
            default:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => i.ArtistTitle);
                break;
        }

        // --- STEP M: Execute Query with Pagination ---
        ViewModel.Items = await sortedQuery
            .Skip((ViewModel.Pagination.CurrentPage - 1) * PageSize)
            .Take(PageSize)
            .ToListAsync();

        return Page();
    }

    private async Task<IActionResult> HandleStandardShopAsync()
    {
        var allowedUnderPrices = PriceFilterList.Where(f => !f.IsOverPrice).Select(f => f.Price).ToHashSet();
        var allowedOverPrices = PriceFilterList.Where(f => f.IsOverPrice).Select(f => f.Price).ToHashSet();

        if (MinPrice.HasValue && !allowedOverPrices.Contains(MinPrice.Value))
        {
            MinPrice = null;
        }
        if (MaxPrice.HasValue && !allowedUnderPrices.Contains(MaxPrice.Value))
        {
            MaxPrice = null;
        }

        DateTime endOfDay = DateTime.Now.Date.AddDays(1).AddSeconds(-1);
        var query = _context.Inventories.AsQueryable();

        // Filter by Rhythm
        if (!string.IsNullOrWhiteSpace(CurrentRhythm))
        {
            string targetRhythm = CurrentRhythm.Trim();
            query = query.Where(i => i.RhythmName == targetRhythm);

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"Rhythm: {targetRhythm}\"";
            }
        }

        // Filter by Genre
        if (!string.IsNullOrWhiteSpace(CurrentGenre))
        {
            string upperGenre = CurrentGenre.ToUpper().Trim();
            query = query.Where(i => i.Genre1 == upperGenre
                                  || i.Genre2 == upperGenre
                                  || i.Genre3 == upperGenre
                                  || i.Genre4 == upperGenre
                                  || i.Genre5 == upperGenre
                                  || i.Genre6 == upperGenre
                                  || i.Genre7 == upperGenre
                                  || i.Genre8 == upperGenre
                                  || i.Genre9 == upperGenre);

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"{CurrentGenre.Trim()}\"";
            }
        }

        // Filter by Label
        if (!string.IsNullOrWhiteSpace(CurrentArtistLabel))
        {
            string targetArtist = CurrentArtistLabel.Trim();

            query = query.Where(i => i.Label == targetArtist
                                  || i.Label.StartsWith(targetArtist + "/")
                                  || i.Label.Contains("/" + targetArtist + "/")
                                  || i.Label.EndsWith("/" + targetArtist));

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"{targetArtist}\"";
            }
        }

        // Filter by Artist
        if (!string.IsNullOrWhiteSpace(CurrentArtist))
        {
            string targetArtist = CurrentArtist.Trim();
            query = query.Where(i => _context.WebArtists.Any(wa => wa.InventoryId == i.Id && wa.Artist == targetArtist));

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"{targetArtist}\"";
            }
        }

        // Filter by Title
        if (!string.IsNullOrWhiteSpace(CurrentArtistTitle))
        {
            string targetArtistTitle = CurrentArtistTitle.Trim();
            query = query.Where(i => i.ArtistTitle == targetArtistTitle);

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"{targetArtistTitle}\"";
            }
        }

        // Filter by Feature Item ID (feaitem)
        if (!string.IsNullOrWhiteSpace(FeatureItem) && int.TryParse(FeatureItem.Trim(), out int featureId))
        {
            query = query.Where(i => _context.InventoryItemFeatures
                .Any(f => f.ItemId == i.Id && f.InventoryItemFeatureId == featureId));

            var featureIndex = await _context.InventoryItemFeatureIndices
                .AsNoTracking()
                .FirstOrDefaultAsync(f => f.InventoryItemFeatureId == featureId);

            if (featureIndex != null)
            {
                string format = featureIndex.FormatForInternalUse?.Trim() ?? string.Empty;
                string details = featureIndex.ItemFeatureWebProductDetailsPageText?.Trim() ?? string.Empty;

                string fullDesc = $"{format} {details}".Trim();
                if (!string.IsNullOrEmpty(fullDesc))
                {
                    SearchHeaderDescription = $"\"{fullDesc}\"";
                }
            }
        }

        // Filter by Year
        if (!string.IsNullOrWhiteSpace(CurrentYear) && int.TryParse(CurrentYear.Trim(), out int targetYear))
        {
            string yearStr = targetYear.ToString();

            query = query.Where(i =>
                (i.YearFrom != null && i.YearFrom == yearStr) ||
                (i.YearTo != null && i.YearTo == yearStr)
            );

            if (string.IsNullOrEmpty(SearchHeaderDescription))
            {
                SearchHeaderDescription = $"\"Music Recorded In {targetYear}\"";
            }
        }

        // Base criteria bounds
        query = query.Where(i => i.Inventory1 > 0
                              && i.Deleted == "n"
                              && i.ShowOnWebsite == "y"
                              && i.StreetDate <= endOfDay);

        // Format Filter
        if (!string.IsNullOrWhiteSpace(CurrentFormat))
        {
            if (CurrentFormat == AppConstants.ShopFormats.Vinyl)
            {
                query = query.Where(i =>
                    i.Format.StartsWith(AppConstants.ShopFormats.TwelveInch) ||
                    i.Format == AppConstants.ShopFormats.LP ||
                    i.Format.StartsWith(AppConstants.ShopFormats.SevenInch) ||
                    i.Format.StartsWith(AppConstants.ShopFormats.TenInch));
            }
            else if (CurrentFormat == AppConstants.ShopFormats.TwelveAndTenInch)
            {
                query = query.Where(i =>
                    i.Format.StartsWith(AppConstants.ShopFormats.TwelveInch) ||
                    i.Format.StartsWith(AppConstants.ShopFormats.TenInch));
            }
            else
            {
                query = query.Where(i => i.Format == CurrentFormat);
            }
        }

        if (UsedItem == "y")
        {
            query = query.Where(i => i.UsedItem == "y");
        }
        else if (UsedItem == "n")
        {
            query = query.Where(i => i.UsedItem == null || i.UsedItem == "n");
        }

        // Price Range Filters
        if (MinPrice.HasValue || MaxPrice.HasValue)
        {
            DateTime activeToday = DateTime.Today;

            if (MinPrice.HasValue)
            {
                query = query.Where(i => ((i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= activeToday)
                    ? i.SaleRetailPrice
                    : (decimal?)i.RetailPrice) >= MinPrice.Value);
            }

            if (MaxPrice.HasValue)
            {
                query = query.Where(i => ((i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= activeToday)
                    ? i.SaleRetailPrice
                    : (decimal?)i.RetailPrice) <= MaxPrice.Value);
            }
        }

        // Pagination Totals
        ViewModel.Pagination.TotalRecords = await query.CountAsync();
        ViewModel.Pagination.CurrentPage = PageNum < 1 ? 1 : PageNum;
        ViewModel.Pagination.TotalPages = (int)Math.Ceiling(ViewModel.Pagination.TotalRecords / (double)PageSize);

        // Sorting
        if (string.IsNullOrWhiteSpace(Order) || !int.TryParse(Order, out var orderValue) || orderValue < 1 || orderValue > 6)
        {
            Order = AppConstants.ShopSortOrders.BestSellers;
        }

        IOrderedQueryable<Models.Inventory> sortedQuery;
        DateTime todayMidnight = DateTime.Today;

        switch (Order)
        {
            case AppConstants.ShopSortOrders.NewestArrivals:
                sortedQuery = query
                    .OrderBy(i => i.UsedItem)
                    .ThenByDescending(i => i.InStockDate > i.BackInStockDate ? i.InStockDate : i.BackInStockDate)
                    .ThenByDescending(i => i.Id);
                break;

            case AppConstants.ShopSortOrders.BestSellers:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenByDescending(i => i.SalesLast30Days)
                    .ThenByDescending(i => i.Inventory1)
                    .ThenByDescending(i => i.Id);
                break;

            case AppConstants.ShopSortOrders.Label:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => i.Label)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.PriceHighToLow:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenByDescending(i => (i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= todayMidnight)
                            ? i.SaleRetailPrice
                            : (decimal?)i.RetailPrice)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.PriceLowToHigh:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => (i.SaleRetailPrice != null && i.SaleRetailEndDate != null && i.SaleRetailEndDate >= todayMidnight)
                            ? i.SaleRetailPrice
                            : (decimal?)i.RetailPrice)
                    .ThenBy(i => i.ArtistTitle);
                break;

            case AppConstants.ShopSortOrders.Artist:
            default:
                sortedQuery = query
                    .OrderBy(i => i.FormatOrder)
                    .ThenBy(i => i.UsedItem)
                    .ThenBy(i => i.ArtistTitle);
                break;
        }

        // Execute Query
        List<Models.Inventory> inventories = await sortedQuery
            .Skip((ViewModel.Pagination.CurrentPage - 1) * PageSize)
            .Take(PageSize)
            .ToListAsync();

        ViewModel.Items = inventories;

        return Page();
    }
}
public class ShowListViewModel
{
    public List<Inventory> Items { get; set; } = new List<Inventory>();
    public PaginationInfo Pagination { get; set; } = new PaginationInfo();
}

public class ShopViewModel
{
    public int Id { get; set; }
    public string Artist { get; set; } = "";
    public string Title { get; set; } = "";
    public string Format { get; set; } = "";
    public decimal Price { get; set; }
    public int Inventory { get; set; }
    public bool IsUsed { get; set; }
    public string ArtistTitle { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string FrontImg { get; set; } = string.Empty;
    public string Features { get; set; } = string.Empty;
    public string Sid { get; set; } = string.Empty;
}

public class PaginationInfo
{
    public int TotalRecords { get; set; }
    public int CurrentPage { get; set; }
    public int TotalPages { get; set; }
    public bool HasPreviousPage => CurrentPage > 1;
    public bool HasNextPage => CurrentPage < TotalPages;
}