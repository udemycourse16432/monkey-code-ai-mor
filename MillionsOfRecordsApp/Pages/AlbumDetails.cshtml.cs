using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.Text;
using System.Text.Encodings.Web;

namespace MillionsOfRecordsApp.Pages;

public class AlbumDetailsModel : MillionsBasePageModel
{
    public AlbumDetailsModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures)
        : base(context, cartService, procedures) { }

    [FromRoute(Name = "id")]
    public int AlbumId { get; set; }
    public AlbumDetailsViewModel AlbumData { get; set; } = null!;
    public List<spInventoryItemFeaturesForProductDetailsPageResult> FeaturesList { get; set; } = new();
    public List<string> GenresList { get; set; } = new();
    public bool IsNotFound { get; set; } = false;
    public bool IsOutOfStock { get; set; } = false;
    public Models.Cart? CartModel { get; set; }
    public string SearchId { get; set; } = string.Empty;
    public string ShopUrl { get; set; } = "~/shop";

    public List<RelatedItemViewModel> CustomerViewedList { get; set; } = new();
    public List<RelatedItemViewModel> MoreByArtistList { get; set; } = new();
    public string ArtistForMoreBy { get; set; } = string.Empty;

    public async Task<IActionResult> OnGetAsync(int id)
    {
        AlbumId = id;
        SearchId = HttpContext.Session.GetSearchId();

        string nameOfCart = HttpContext.Session.GetActiveCartName();

        CartModel = await _context.Carts
            .Where(c => c.CartName == nameOfCart && c.ItemId == id)
            .FirstOrDefaultAsync();

        string referrer = Request.Headers.Referer.ToString();
        if (!string.IsNullOrEmpty(referrer))
        {
            try
            {
                var uri = new Uri(referrer);
                if (uri.AbsolutePath.Equals("/shop", StringComparison.OrdinalIgnoreCase) && !string.IsNullOrEmpty(uri.Query))
                {
                    ShopUrl = $"~/shop{uri.Query}";
                }
            }
            catch (UriFormatException)
            {
                ShopUrl = "~/shop";
            }
        }

        if (AlbumId <= 0)
        {
            IsNotFound = true;
            return Page();
        }

        var item = await _context.Inventories
            .FirstOrDefaultAsync(i => i.Id == AlbumId && i.Deleted == "n" && i.ShowOnWebsite == "y");

        if (item == null)
        {
            IsNotFound = true;
            return Page();
        }

        if (item.Inventory1 <= 0)
        {
            IsOutOfStock = true;
        }

        FeaturesList = await _procedures.spInventoryItemFeaturesForProductDetailsPageAsync(AlbumId);
        var (artist, title) = item.SplitTitle();

        decimal currentPrice = item.GetComputedPrice(HttpContext.Session.GetPriceGroup());

        if (CartModel != null && CartModel.Quantity > 0)
        {
            decimal cartPrice = CartModel.Price;
            DateTime cartDateTime = CartModel.DateTime;

            int daysInCart = (DateTime.Now.Date - cartDateTime.Date).Days;

            if (currentPrice > cartPrice && daysInCart <= 30)
            {
                currentPrice = cartPrice;
            }
        }
        // Clean legacy markers
        var cleanReview = CleanLegacyMarkers(item.WebReviewHtml);
        var cleanMusician = CleanLegacyMarkers(item.MusicianGroup);
        var cleanProduce = CleanLegacyMarkers(item.ProduceGroup);

        // Format for display
        var webReviewHtml = HtmlEncoder.Default.Encode(cleanReview).Replace("\n", "<br />");
        var musicianGroupHtml = FormatGroupToHtmlList(cleanMusician);
        var produceGroupHtml = FormatGroupToHtmlList(cleanProduce);
        AlbumData = new AlbumDetailsViewModel
        {
            Id = item.Id,
            ArtistTitle = item.ArtistTitle ?? "",
            Artist = artist,
            Title = title,
            Format = item.Format ?? "",
            UsedItem = item.UsedItem?.ToUpper() == "Y",
            Price = currentPrice,
            Label = item.Label ?? "",
            Catalog = item.Catalog ?? "",
            YearFrom = item.YearFrom,
            YearTo = item.YearTo,
            UPC = item.Upc ?? "",
            WeightInGrams = item.WeightInGrams,
            FrontImgThumb = item.GetImagePath("1130", "A"),
            BackImgThumb = item.GetImagePath("1130", "B"),

            // --- PORTED CONDITION FIELDS ---
            ConditionVinylOrCD = item.ConditionVinylOrCd ?? "",
            ConditionJacket = item.ConditionJacket ?? "",
            ConditionNotes = item.ConditionNotes ?? "",
            ConditionText = item.ConditionText ?? "",

            WebReviewHtml = webReviewHtml,
            MusicianGroupHtml = musicianGroupHtml,
            ProduceGroupHtml = produceGroupHtml
        };

        ParseGenres(item);
        await LoadRelatedItemsAsync(item, HttpContext.Session.GetPriceGroup());
        return Page();
    }
    private void ParseGenres(Models.Inventory item)
    {
        string[] genres = {
            item.Genre1, item.Genre2, item.Genre3, item.Genre4, item.Genre5,
            item.Genre6, item.Genre7, item.Genre8, item.Genre9
        };

        foreach (var g in genres)
        {
            if (!string.IsNullOrWhiteSpace(g))
            {
                GenresList.Add(g.Trim());
            }
        }
    }
    private static string CleanLegacyMarkers(string? input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return string.Empty;
        }

        return input
            .Replace("yr1.gif", "", StringComparison.OrdinalIgnoreCase)
            .Replace("ym1.gif", "", StringComparison.OrdinalIgnoreCase)
            .Replace("yp1.gif", "", StringComparison.OrdinalIgnoreCase)
            .Trim();
    }

    private static string FormatGroupToHtmlList(string input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return string.Empty;
        }

        // Split by the bullet separator '•' or ' • '
        var items = input.Split(new[] { "•", "\u2022" }, StringSplitOptions.RemoveEmptyEntries);

        var sb = new StringBuilder();
        sb.Append("<ul class=\"list-unstyled mb-0\">");

        foreach (var item in items)
        {
            var trimmed = item.Trim();
            if (string.IsNullOrEmpty(trimmed)) continue;

            // Highlight label before ':' in bold if a key-value pattern exists
            var colonIndex = trimmed.IndexOf(':');
            if (colonIndex > 0)
            {
                var label = HtmlEncoder.Default.Encode(trimmed.Substring(0, colonIndex));
                var value = HtmlEncoder.Default.Encode(trimmed.Substring(colonIndex + 1));
                sb.Append($"<li class=\"mb-1\"><strong>{label}:</strong>{value}</li>");
            }
            else
            {
                sb.Append($"<li class=\"mb-1\">{HtmlEncoder.Default.Encode(trimmed)}</li>");
            }
        }

        sb.Append("</ul>");
        return sb.ToString();
    }
    private async Task LoadRelatedItemsAsync(Inventory item, string priceGroup)
    {
        // --- 1. CUSTOMER VIEWED (SIMILAR ITEMS) ---
        string primaryGenre = item.Genre1 ?? "";
        string rhythmName = item.RhythmName ?? "";

        if (!string.IsNullOrEmpty(primaryGenre) || !string.IsNullOrEmpty(rhythmName))
        {
            int yearFrom = int.TryParse(item.YearFrom, out var yf) ? yf - 1 : 1000;
            int yearTo = int.TryParse(item.YearTo, out var yt) ? yt + 1 : yearFrom + 2;

            var baseQuery = _context.Inventories
                .Where(i => i.Id != item.Id
                         && i.Inventory1 > 0
                         && i.ShowOnWebsite == "y"
                         && i.UsedItem == "n"
                         && i.Deleted == "n");

            // Format matching
            if (item.Format == "7\"")
                baseQuery = baseQuery.Where(i => i.Format != null && i.Format.StartsWith("7"));
            else if (item.Format == "12\"" || item.Format == "10\"")
                baseQuery = baseQuery.Where(i => i.Format != null && (i.Format.StartsWith("12") || i.Format.StartsWith("10")));
            else if (!string.IsNullOrEmpty(item.Format))
                baseQuery = baseQuery.Where(i => i.Format == item.Format);

            // Genre & Rhythm & Year filter
            var similarQuery = baseQuery.Where(i =>
                (
                    (!string.IsNullOrEmpty(primaryGenre) &&
                     (i.Genre1 == primaryGenre || i.Genre2 == primaryGenre || i.Genre3 == primaryGenre ||
                      i.Genre4 == primaryGenre || i.Genre5 == primaryGenre || i.Genre6 == primaryGenre ||
                      i.Genre7 == primaryGenre || i.Genre8 == primaryGenre || i.Genre9 == primaryGenre) &&
                     ((Convert.ToInt32(i.YearFrom) >= yearFrom && Convert.ToInt32(i.YearFrom) <= yearTo) ||
                      (Convert.ToInt32(i.YearTo) >= yearFrom && Convert.ToInt32(i.YearTo) <= yearTo)))
                )
                || (!string.IsNullOrEmpty(rhythmName) && i.RhythmName == rhythmName)
            );

            var rawViewed = await similarQuery
                .OrderByDescending(i => i.SalesLast30Days)
                .ThenByDescending(i => i.Id)
                .Take(60)
                .ToListAsync();

            // Randomize in memory (replicating ORDER BY NEWID())
            CustomerViewedList = rawViewed
                .OrderBy(_ => Guid.NewGuid())
                .Take(50)
                .Select(i => new RelatedItemViewModel
                {
                    Id = i.Id,
                    ArtistTitle = i.ArtistTitle ?? "",
                    Format = i.Format ?? "",
                    Price = i.GetComputedPrice(priceGroup),
                    ImageUrl = i.GetImagePath("320", "A")
                })
                .ToList();
        }

        // --- 2. MORE BY THIS ARTIST ---
        var (artist, _) = item.SplitTitle();
        if (!string.IsNullOrWhiteSpace(artist) && !artist.Equals("Various", StringComparison.OrdinalIgnoreCase))
        {
            ArtistForMoreBy = artist;
            var existingCvIds = CustomerViewedList.Select(c => c.Id).ToHashSet();

            var artistQuery = _context.Inventories
                .Where(i => i.Id != item.Id
                         && !existingCvIds.Contains(i.Id)
                         && i.Inventory1 > 0
                         && i.ShowOnWebsite == "y"
                         && i.UsedItem == "n"
                         && i.Deleted == "n"
                         && (EF.Functions.Like(i.ArtistTitle, $"{artist} - %") ||
                             EF.Functions.Like(i.ArtistTitle, $"{artist}, %") ||
                             EF.Functions.Like(i.ArtistTitle, $"%, {artist} -%") ||
                             EF.Functions.Like(i.ArtistTitle, $"%, {artist},%")));

            var rawMoreBy = await artistQuery
                .OrderByDescending(i => i.SalesLast30Days)
                .ThenByDescending(i => i.Id)
                .Take(60)
                .ToListAsync();

            MoreByArtistList = rawMoreBy
                .OrderBy(_ => Guid.NewGuid())
                .Take(50)
                .Select(i => new RelatedItemViewModel
                {
                    Id = i.Id,
                    ArtistTitle = i.ArtistTitle ?? "",
                    Format = i.Format ?? "",
                    Price = i.GetComputedPrice(priceGroup),
                    ImageUrl = i.GetImagePath("320", "A")
                })
                .ToList();
        }
    }
}

public class AlbumDetailsViewModel
{
    public int Id { get; set; }
    public bool UsedItem { get; set; } = false;
    public string ArtistTitle { get; set; } = string.Empty;
    public string Artist { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Format { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public string Label { get; set; } = string.Empty;
    public string Catalog { get; set; } = string.Empty;
    public string YearFrom { get; set; } = string.Empty;
    public string YearTo { get; set; } = string.Empty;
    public string UPC { get; set; } = string.Empty;
    public decimal WeightInGrams { get; set; }
    public string FrontImgThumb { get; set; } = string.Empty;
    public string BackImgThumb { get; set; } = string.Empty;
    public string FrontImgMedium { get; set; } = string.Empty;
    public string BackImgMedium { get; set; } = string.Empty;
    public string FrontImgFull { get; set; } = string.Empty;
    public string BackImgFull { get; set; } = string.Empty;

    // --- PORTED CONDITION FIELDS ---
    public string ConditionVinylOrCD { get; set; } = string.Empty;
    public string ConditionJacket { get; set; } = string.Empty;
    public string ConditionNotes { get; set; } = string.Empty;
    public string ConditionText { get; set; } = string.Empty;

    public string WebReviewHtml { get; set; } = string.Empty;
    public string MusicianGroupHtml { get; set; } = string.Empty;
    public string ProduceGroupHtml { get; set; } = string.Empty;
}
public class RelatedItemViewModel
{
    public int Id { get; set; }
    public string ArtistTitle { get; set; } = string.Empty;
    public string Format { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public string ImageUrl { get; set; } = string.Empty;
    public string DisplayText { get; set; } = string.Empty;
}