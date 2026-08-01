using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models.DTOs;
using MillionsOfRecordsApp.Models.Shared;

namespace MillionsOfRecordsApp.Controllers;

[Route("api")]
[ApiController]
public class ProxyController : ControllerBase
{
    private readonly ReggaeDbContext _dbContext;
    private readonly string _imgBase;

    public ProxyController(ReggaeDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _imgBase = configuration["Appsettings:ImagesPath"] ?? throw new ApplicationException("Configuration \"Appsettings:ImagesPath\" is required");
        if (!_imgBase.EndsWith("/")) _imgBase += "/";
    }
    [HttpGet("suggestions/albums")]
    public async Task<IActionResult> GetAlbums(string search, int page = 1, int limit = 10, int? order = null, string? alpha = "", string? genre = "")
    {
        //return await ProxyGet(ApiEndpoints.AlbumSuggestions, search, page, limit, order, alpha, genre);
        var response = await GetWebSearchSuggestionAsync(AppConstants.WebSearchSuggestionsSearchTypes.Album, search ?? "", page, limit);
        return Ok(response);
    }
    [HttpGet("suggestions/artists")]
    public async Task<IActionResult> GetArtists(string? search = "", int page = 1, int limit = 20, int? order = null, string? alpha = "", string? genre = "")
    {
        if (!string.IsNullOrEmpty(genre))
        {
            var result = await GetArtistsByGenreAsync(genre, page, limit, order, alpha);
            return Ok(result);
        }
        if (!string.IsNullOrEmpty(genre))
        {
            int offset = (page - 1) * limit;
            int fetch = limit;
            string sortBy = order == 2 ? "P" : "A";
            string text = genre;

            // exec GenreArtists @Text=N'Reggae',@SortBy=N'P',@Offset=0,@Fetch=105
            // This is a direct SQL query to get artists by genre with sorting and pagination
            // Following is the result of the above query for Genre = "Reggae" and SortBy = "P" (Popular):
            /*
             GenreArtist	Total
            Dennis Brown	107
            Gregory Isaacs	100
            ... 105 rows total
             */
            // convert this to WebSearchSuggestionDto list and return as ApiResponse
            // also we need to get the total count for pagination, which can be done with a separate query or by using COUNT(*) OVER() in the same query

            // Following is the stored procedure call to get artists by genre with sorting and pagination
            /*
             ALTER PROCEDURE [dbo].[GenreArtists]
             @Text nvarchar(255)
            ,@Offset int
            ,@Fetch int
            ,@SortBy nvarchar(20)

            AS
            if @SortBy='P'
             begin
              select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total
              from Inventory
              left join WebArtists on Inventory.ID=WebArtists.InventoryID
              where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
              and WebArtists.Artist is not null
              and inventory>0
              group by WebArtists.Artist
              order by count(WebArtists.Artist) desc
              offset @Offset rows
              Fetch Next @Fetch Rows only
             end
            else
             begin
              select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total
              from Inventory
              left join WebArtists on Inventory.ID=WebArtists.InventoryID
              where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
              and WebArtists.Artist is not null
              and inventory>0
              group by WebArtists.Artist
              order by WebArtists.Artist
              offset @Offset rows
              Fetch Next @Fetch Rows only
             end
             */

            // Following is the stored procedure call by letter to get artists by genre with sorting and pagination
            /*
             ALTER PROCEDURE [dbo].[GenreArtistsLetter]
             @Text nvarchar(255)
            ,@Fetch int
            ,@Letter nvarchar(1)

            as
            if @Letter='A'
             set @Letter='-'

            declare @StartRecord int

            set @StartRecord=(
            select top 1 count(*) over () as StartRecord
              from Inventory
              left join WebArtists on Inventory.ID=WebArtists.InventoryID
              where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
              and WebArtists.Artist is not null
              and inventory>0
              and WebArtists.Artist<@Letter
              group by WebArtists.Artist
              order by WebArtists.Artist)

              set @StartRecord=ISNULL(@StartRecord,0)+1
              if @Letter='A' or @Letter='-'
               begin
               set  @StartRecord=1
               end

              select WebArtists.Artist as GenreArtist,count(WebArtists.Artist) as Total,@StartRecord as StartRecord
              from Inventory
              left join WebArtists on Inventory.ID=WebArtists.InventoryID
              where (Genre1=@Text or Genre2=@Text or Genre3=@Text or Genre4=@Text or Genre5=@Text or Genre6=@Text or Genre7=@Text or Genre8=@Text or Genre9=@Text)
              and WebArtists.Artist is not null
              and inventory>0
              and Artist>=@Letter
              group by WebArtists.Artist
              order by WebArtists.Artist
              offset 0 rows
              Fetch Next @Fetch Rows only
             */
        }
        //return await ProxyGet(ApiEndpoints.ArtistSuggestions, search, page, limit, order, alpha, genre);
        var response = await GetWebSearchSuggestionAsync(AppConstants.WebSearchSuggestionsSearchTypes.Artist, search ?? "", page, limit);
        return Ok(response);
    }
    private async Task<ApiResponse<WebSearchSuggestionDto>> GetArtistsByGenreAsync(string genre, int page, int limit, int? order, string alpha)
    {
        // 1. Base Query: Join Inventory and WebArtists
        var query = _dbContext.Inventories
            .Where(i => i.Inventory1 > 0)
            // Filter by any of the 9 genre columns
            .Where(i => i.Genre1 == genre || i.Genre2 == genre || i.Genre3 == genre ||
                        i.Genre4 == genre || i.Genre5 == genre || i.Genre6 == genre ||
                        i.Genre7 == genre || i.Genre8 == genre || i.Genre9 == genre)
            .Join(_dbContext.WebArtists, inv => inv.Id, art => art.InventoryId, (inv, art) => art)
            .Where(art => art.Artist != null);

        // 2. Alpha Filtering (If provided, maps to GenreArtistsLetter logic)
        if (!string.IsNullOrEmpty(alpha) && alpha != "0")
        {
            string searchLetter = (alpha == "A") ? "-" : alpha;
            query = query.Where(a => a.Artist.CompareTo(searchLetter) >= 0);
        }

        // 3. Grouping
        var groupedQuery = query.GroupBy(a => a.Artist)
                                .Select(g => new { Artist = g.Key, Total = g.Count() });

        // 4. Ordering
        groupedQuery = (order == 2)
            ? groupedQuery.OrderByDescending(g => g.Total)
            : groupedQuery.OrderBy(g => g.Artist);

        // 5. Pagination & Projection
        int totalItems = await groupedQuery.CountAsync();
        var results = await groupedQuery
            .Skip((page - 1) * limit)
            .Take(limit)
            .Select(g => new WebSearchSuggestionDto { ArtistTitle = g.Artist, Count = g.Total })
            .ToListAsync();

        return new ApiResponse<WebSearchSuggestionDto>
        {
            Data = results,
            Pagination = CalculatePagination(this.HttpContext, totalItems, page, limit, alpha)
        };
    }
    [HttpGet("suggestions/allartists")]
    public async Task<IActionResult> GetAllArtists(int page = 1, int limit = 140, int? order = null, string alpha = "0")
    {
        //return await ProxyGet(ApiEndpoints.LabelSuggestions, search, page, limit, order, alpha, genre);
        var response = await GetAllArtistsAsync(page, limit, order, alpha);
        return Ok(response);
    }
    [HttpGet("suggestions/alllabels")]
    public async Task<IActionResult> GetAllLabels(int page = 1, int limit = 140, int? order = null, string alpha = "0")
    {
        //return await ProxyGet(ApiEndpoints.LabelSuggestions, search, page, limit, order, alpha, genre);
        var response = await GetAllWebSearchSuggestionAsync("Label", page, limit, order, alpha);
        return Ok(response);
    }
    [HttpGet("suggestions/allgenres")]
    public async Task<IActionResult> GetAllGenres(int page = 1, int limit = 140, int? order = null, string alpha = "0")
    {
        var response = await GetAllWebSearchSuggestionAsync("Genre", page, limit, order, alpha);
        return Ok(response);
    }
    public async Task<ApiResponse<WebSearchSuggestionDto>> GetAllArtistsAsync(int page = 1, int limit = 140, int? order = null, string alpha = "0")
    {
        // 1. Base Query: Join Inventory and WebArtists
        var artistQuery = _dbContext.Inventories
            .Where(i => i.Inventory1 > 0)
            .Join(_dbContext.WebArtists,
                  inv => inv.Id,
                  art => art.InventoryId,
                  (inv, art) => art)
            .Where(art => art.Artist != null);

        // 2. Alpha Filtering (Port of AllArtistsLetter logic)
        if (alpha != "0")
        {
            // Special case for 'A' as per stored procedure
            string searchLetter = (alpha == "A") ? "-" : alpha;
            artistQuery = artistQuery.Where(a => a.Artist.CompareTo(searchLetter) >= 0);
        }

        // 3. Perform Grouping
        // We group early to get unique Artists and their counts
        var groupedQuery = artistQuery
            .GroupBy(a => a.Artist)
            .Select(g => new { Artist = g.Key, Total = g.Count() });

        // 4. Apply Ordering
        // Order 2 = Popular ('P'), otherwise Alpha ('A')
        groupedQuery = (order == 2)
            ? groupedQuery.OrderByDescending(g => g.Total)
            : groupedQuery.OrderBy(g => g.Artist);

        // 5. Pagination & Final Execution
        int totalItems = await groupedQuery.CountAsync();

        var results = await groupedQuery
            .Skip((page - 1) * limit)
            .Take(limit)
            .Select(g => new WebSearchSuggestionDto
            {
                ArtistTitle = g.Artist,
                Count = g.Total,
            })
            .ToListAsync();

        return new ApiResponse<WebSearchSuggestionDto>
        {
            Data = results,
            Pagination = CalculatePagination(this.HttpContext, totalItems, page, limit, alpha)
        };
    }
    public async Task<ApiResponse<WebSearchSuggestionDto>> GetAllWebSearchSuggestionAsync(string searchType, int page = 1, int limit = 140, int? order = null, string alpha = "0")
    {
        const int order_popular = 2;
        order ??= order_popular;
        int offset = (page - 1) * limit;

        // Base query for all label types
        var query = _dbContext.WebSearchSuggestions
            .Where(w => w.SearchType == searchType)
            .AsNoTracking();

        if (alpha == "0")
        {

            // 2. Get Total Count for Pagination
            int totalItems = await query.CountAsync();

            // Logic for AllLabels (Popular vs Alphabetical)
            if (order == 2) // order_popular
            {
                query = query.OrderByDescending(w => w.Total).ThenByDescending(w => w.Counter);
            }
            else // order_alpha (1)
            {
                query = query.OrderBy(w => w.Hint);
            }
            var results = await query
                .Skip(offset)
                .Take(limit)
                .Select(w => new WebSearchSuggestionDto { ArtistTitle = w.Hint, Count = w.Total, Counter = w.Counter })
                .ToListAsync();

            return new ApiResponse<WebSearchSuggestionDto> { Data = results, Pagination = CalculatePagination(this.HttpContext, totalItems, page, limit, "") };
        }
        else
        {
            // 1. Setup the filter criteria
            string searchLetter = (alpha == "A") ? "-" : alpha;
            // 2. Get the specific subset of labels that start with or follow this letter
            var letterQuery = query.Where(w => w.Hint.CompareTo(searchLetter) >= 0);
            // 3. Get the TOTAL count for this specific letter range for pagination
            int totalItemsForLetter = await letterQuery.CountAsync();
            // 4. Fetch the results (using the same limit/offset logic as your '0' block)
            var results = await letterQuery
                .OrderBy(w => w.Hint)
                .Skip((page - 1) * limit) // Assuming you want pagination within the letter
                .Take(limit)
                .Select(w => new WebSearchSuggestionDto
                {
                    ArtistTitle = w.Hint,
                    Count = w.Total,
                    Counter = w.Counter,
                })
                .ToListAsync();
            // 5. Call CalculatePagination with the letter-specific total
            return new ApiResponse<WebSearchSuggestionDto>
            {
                Data = results,
                Pagination = CalculatePagination(this.HttpContext, totalItemsForLetter, page, limit, alpha)
            };
        }
    }

    [HttpGet("suggestions/labels")]
    public async Task<IActionResult> GetLabels(string? search = "", int page = 1, int limit = 20, int? order = null, string? alpha = "", string? genre = "")
    {
        //return await ProxyGet(ApiEndpoints.LabelSuggestions, search, page, limit, order, alpha, genre);
        var response = await GetWebSearchSuggestionAsync(AppConstants.WebSearchSuggestionsSearchTypes.Label, search ?? "", page, limit);
        return Ok(response);
    }
    [HttpGet("suggestions/genres")]
    public async Task<IActionResult> GetGenres(string? search = "", int page = 1, int limit = 20, int? order = null, string? alpha = "0")
    {
        //return await ProxyGet(ApiEndpoints.GenreSuggestions, search, page, limit, order, alpha);
        var response = await GetWebSearchSuggestionAsync(AppConstants.WebSearchSuggestionsSearchTypes.Genre, search ?? "", page, limit);
        return Ok(response);
    }
    private string SanitizeSearchTerm(string term)
    {
        if (string.IsNullOrWhiteSpace(term)) return string.Empty;

        // 1. Strip leading "THE "
        if (term.Length > 4 && term.StartsWith("THE ", StringComparison.OrdinalIgnoreCase))
        {
            term = term.Substring(4).Trim();
        }

        // 2. Character filtering (matching legacy ASCII filters)
        var cleanChars = term.Where(c =>
            c == 32 || c == 38 || c == 39 ||
            (c >= 47 && c <= 57) ||
            (c >= 65 && c <= 90) ||
            (c >= 97 && c <= 122)
        ).ToArray();

        return new string(cleanChars);
    }
    public async Task<ApiResponse<WebSearchSuggestionDto>> GetWebSearchSuggestionAsync(string searchType, string searchTerm, int page = 1, int pageSize = 10)
    {
        searchTerm = SanitizeSearchTerm(searchTerm);

        // Split into individual words, mimicking legacy behavior
        var words = searchTerm.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                              .Select(w => $"{w}%")
                              .Take(10) // Legacy maxes out at 10 words
                              .ToList();
        if (!words.Any())
        {
            return new ApiResponse<WebSearchSuggestionDto>
            {
                Data = new List<WebSearchSuggestionDto>(),
                Pagination = CalculatePagination(this.HttpContext, 0, page, pageSize, searchTerm)
            };
        }
        var query = _dbContext.WebSearchSuggestions.AsNoTracking()
            .Where(s => s.SearchType == searchType);

        foreach (var word in words)
        {
            var currentWord = word; // Avoid modified closure issues
            query = query.Where(s =>
                EF.Functions.Like(s.Word1, currentWord) ||
                EF.Functions.Like(s.Word2, currentWord) ||
                EF.Functions.Like(s.Word3, currentWord) ||
                EF.Functions.Like(s.Word4, currentWord) ||
                EF.Functions.Like(s.Word5, currentWord) ||
                EF.Functions.Like(s.Word6, currentWord) ||
                EF.Functions.Like(s.Word7, currentWord) ||
                EF.Functions.Like(s.Word8, currentWord) ||
                EF.Functions.Like(s.Word9, currentWord) ||
                EF.Functions.Like(s.Word10, currentWord) ||
                EF.Functions.Like(s.Word11, currentWord) ||
                EF.Functions.Like(s.Word12, currentWord) ||
                EF.Functions.Like(s.Word13, currentWord) ||
                EF.Functions.Like(s.Word14, currentWord) ||
                EF.Functions.Like(s.Word15, currentWord) ||
                EF.Functions.Like(s.Word16, currentWord) ||
                EF.Functions.Like(s.Word17, currentWord) ||
                EF.Functions.Like(s.Word18, currentWord) ||
                EF.Functions.Like(s.Word19, currentWord) ||
                EF.Functions.Like(s.Word20, currentWord)
            );
        }
        int totalItems = await query.CountAsync();

        // 1. Fetch raw fields from the DB first
        var dbResults = await query
        .OrderBy(s => s.SortOrder)
        .ThenByDescending(s => s.Total)
        .ThenByDescending(s => s.SalesLast30Days)
        .ThenBy(s => s.Hint)
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .Select(s => new { s.Hint, s.Total, s.Counter, s.ScanPath }) // In-Memory projection block
        .ToListAsync();

        // 2. Perform safe C# string manipulation during DTO mapping
        var results = dbResults.Select(s =>
        {
            // Default assignment matching raw database column values
            string finalArtistTitle = s.Hint;

            // Apply legacy "Elvis Presley" conditional business rule adjustments
            int intDash = string.IsNullOrEmpty(s.Hint) ? -1 : s.Hint.IndexOf(" - ", StringComparison.Ordinal);

            if (intDash > 0 && string.Equals(searchType, AppConstants.WebSearchSuggestionsSearchTypes.Album, StringComparison.OrdinalIgnoreCase))
            {
                string strArtist = s.Hint.Substring(0, intDash).Trim();

                // Check if the artist block contains a comma (e.g., "Presley, Elvis")
                if (strArtist.Contains(','))
                {
                    // Verify if the parsed sequence matches the user's sanitized query intent
                    if (strArtist.Contains(searchTerm, StringComparison.OrdinalIgnoreCase))
                    {
                        string strTitle = s.Hint.Substring(intDash + 3).Trim(); // Extract everything right of " - "

                        // Call your newly ported method
                        string[] parsedArtists = FigureArtistsFromArtistTitle($"{strArtist} - Title");

                        // Loop through the fixed array payload up to index position 6 (matching legacy behavior)
                        for (int nA = 0; nA < 6; nA++)
                        {
                            if (parsedArtists[nA] == "---") break;

                            if (parsedArtists[nA].Contains(searchTerm, StringComparison.OrdinalIgnoreCase))
                            {
                                // Swap targeted string elements to switch priority order
                                string strArtistToSwitch = parsedArtists[0];
                                parsedArtists[0] = parsedArtists[nA];
                                parsedArtists[nA] = strArtistToSwitch;
                                break;
                            }
                        }

                        // Reconstruct the new rearranged artist string layout
                        string strNewArtist = "";
                        for (int nA = 0; nA < 3; nA++)
                        {
                            if (parsedArtists[nA] != "---")
                            {
                                strNewArtist += $" {parsedArtists[nA]},";
                            }
                        }

                        if (!string.IsNullOrEmpty(strNewArtist))
                        {
                            // Clean up trailing comma suffix and append track details back to title string
                            finalArtistTitle = $"{strNewArtist.Trim().TrimEnd(',')} - {strTitle}";
                        }
                    }
                }
            }

            return new WebSearchSuggestionDto
            {
                ArtistTitle = finalArtistTitle, // Emits transformed or original text output
                Count = s.Total,
                Counter = s.Counter,
                FrontImg = !string.IsNullOrEmpty(s.ScanPath)
                       ? $"{_imgBase}{s.ScanPath.Replace("Scans/", "", StringComparison.OrdinalIgnoreCase).Replace("-s.jpg", "-54.jpg", StringComparison.OrdinalIgnoreCase)}"
                       : ""
            };
        }).ToList();

        // 4. Wrap in your Response class
        return new ApiResponse<WebSearchSuggestionDto>
        {
            Data = results,
            Pagination = CalculatePagination(this.HttpContext, totalItems, page, pageSize, searchTerm)
        };
    }
    private PaginationMetadata CalculatePagination(HttpContext context, int total, int page, int limit, string search)
    {
        var lastPage = (int)Math.Ceiling((double)total / limit);

        // Dynamically get the current URL (e.g., https://your-new-dotnet-site.com/api/inventory_suggestions)
        var baseUrl = $"{context.Request.Scheme}://{context.Request.Host}{context.Request.Path}";

        return new PaginationMetadata
        {
            current_page = page,
            last_page = lastPage,
            per_page = limit,
            total = total,
            from = (page - 1) * limit + 1,
            to = Math.Min(page * limit, total),
            next_page_url = page < lastPage ? $"{baseUrl}?limit={limit}&search={search}&page={page + 1}" : null,
            prev_page_url = page > 1 ? $"{baseUrl}?limit={limit}&search={search}&page={page - 1}" : null,
            first_page_url = $"{baseUrl}?limit={limit}&search={search}&page=1",
            last_page_url = $"{baseUrl}?limit={limit}&search={search}&page={lastPage}"
        };
    }
    public static string[] FigureArtistsFromArtistTitle(string varArtistTitle)
    {
        // Initialize the fixed-size array filled with the legacy fallback flag "---"
        string[] artists = Enumerable.Repeat("---", 15).ToArray();

        if (string.IsNullOrWhiteSpace(varArtistTitle))
            return artists;

        List<string> varTrack = new List<string>();
        varArtistTitle = varArtistTitle.Trim();

        // 1. Figure Tracks (Split by Vinyl Side A / Side B)
        int varSlash = varArtistTitle.IndexOf('/');
        if (varSlash == -1 || varSlash == varArtistTitle.Length - 1)
        {
            varTrack.Add(varArtistTitle);
        }
        else
        {
            // Parse Side A
            string varSideA = varArtistTitle.Substring(0, varSlash).Trim();
            varTrack.AddRange(SplitSideBySemicolon(varSideA));

            // Parse Side B
            string varSideB = varArtistTitle.Substring(varSlash + 1).Trim();
            varTrack.AddRange(SplitSideBySemicolon(varSideB));
        }

        // Pad or truncate to match legacy collection capacity constraints (max 6 tracks)
        varTrack = varTrack.Take(6).ToList();

        // 2. Take Out Bogus Text
        string[] cleanTracks = new string[6];
        for (int i = 0; i < varTrack.Count; i++)
        {
            string track = varTrack[i];
            if (!string.IsNullOrEmpty(track))
            {
                if (track.Length > 6)
                {
                    // Notice the precise casing match to preserve legacy data string equality transformations
                    track = track.Replace("(USED ITEM)", "")
                                 .Replace("(ORIGINAL PRESS)", "")
                                 .Replace("(COLORED VINYL)", "")
                                 .Replace("(PICTURE SLEEVE)", "")
                                 .Replace("(REISSUE)", "")
                                 .Replace("USED ITEM:", "")
                                 .Replace("(", "")
                                 .Replace(")", "");
                }
                cleanTracks[i] = track.Trim();
            }
        }

        // 3. Figure Artists
        int x = 0; // Target index tracker for the results array
        HashSet<string> seenArtists = new HashSet<string>(StringComparer.Ordinal); // Mimics legacy tracking filters

        foreach (var track in cleanTracks)
        {
            if (string.IsNullOrEmpty(track)) break;

            int dashIndex = track.IndexOf(" - ", StringComparison.Ordinal);
            if (dashIndex > 0)
            {
                string varArtistString = track.Substring(0, dashIndex).Trim();

                // Replicating the legacy extraction loop via sequential comma tokenization
                string[] commaTokens = varArtistString.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                foreach (var rawToken in commaTokens)
                {
                    string token = rawToken.Trim();
                    if (string.IsNullOrEmpty(token)) continue;

                    // Process the current item extracted from the list
                    ProcessAndAddArtist(token, seenArtists, artists, ref x);
                }
            }
        }

        return artists;
    }

    private static List<string> SplitSideBySemicolon(string sideText)
    {
        var tracks = new List<string>();
        int semi1 = sideText.IndexOf(';');

        if (semi1 == -1 || semi1 == sideText.Length - 1)
        {
            tracks.Add(sideText);
        }
        else
        {
            tracks.Add(sideText.Substring(0, semi1).Trim());
            int semi2 = sideText.IndexOf(';', semi1 + 1);

            if (semi2 == -1 || semi2 == sideText.Length - 1)
            {
                tracks.Add(sideText.Substring(semi1 + 1).Trim());
            }
            else
            {
                tracks.Add(sideText.Substring(semi1 + 1, semi2 - semi1 - 1).Trim());
                tracks.Add(sideText.Substring(semi2 + 1).Trim());
            }
        }
        return tracks;
    }

    private static void ProcessAndAddArtist(string artistName, HashSet<string> seenArtists, string[] artists, ref int index)
    {
        if (index >= 15) return;

        // Evaluate basic criteria filters matching the custom IF conditions in the VB code
        if (!string.IsNullOrEmpty(artistName) &&
            artistName != "The" &&
            artistName != "Etc." &&
            artistName != "Etc" &&
            !seenArtists.Contains(artistName))
        {
            artists[index] = artistName;
            seenArtists.Add(artistName);
            index++;

            // Inner conditional check: Expand evaluation logic if an ampersand operator is found
            int ampIndex = artistName.IndexOf('&');
            if (ampIndex > 0)
            {
                string artist1 = artistName.Substring(0, ampIndex).Trim();
                if (index < 15 && !string.IsNullOrEmpty(artist1) && artist1 != "The" && artist1 != "Etc." && artist1 != "Etc" && !seenArtists.Contains(artist1))
                {
                    artists[index] = artist1;
                    seenArtists.Add(artist1);
                    index++;
                }

                string artist2 = artistName.Substring(ampIndex + 1).Trim();
                if (index < 15 && !string.IsNullOrEmpty(artist2) && artist2 != "The" && artist2 != "Etc." && artist2 != "Etc" && !seenArtists.Contains(artist2))
                {
                    artists[index] = artist2;
                    seenArtists.Add(artist2);
                    index++;
                }
            }
        }
    }
}


public static class ApiEndpoints
{
    private const string BaseUrl = "https://mor.api.newstagingwebsite.com/api/";

    /// <summary>API endpoint for fetching the inventory list of albums with pagination and filters</summary>
    public const string InventoryList = BaseUrl + "inventory_list";

    /// <summary>API endpoint for fetching detailed information about a specific album by ID</summary>
    public const string AlbumDetails = BaseUrl + "album_details/";

    /// <summary>API endpoint for autocomplete suggestions based on artist search query</summary>
    public const string ArtistSuggestions = BaseUrl + "artist_suggestions?search=";

    /// <summary>API endpoint for autocomplete suggestions based on genre search query</summary>
    public const string GenreSuggestions = BaseUrl + "genre_suggestions?search=";

    /// <summary>API endpoint for autocomplete suggestions based on label search query</summary>
    public const string LabelSuggestions = BaseUrl + "label_suggestions?search=";

    /// <summary>API endpoint for autocomplete suggestions based on album/inventory search query</summary>
    public const string AlbumSuggestions = BaseUrl + "inventory_suggestions?search=";

    /// <summary>API endpoint for fetching the complete list of available filters (genres, artists, labels, etc.)</summary>
    public const string FiltersList = BaseUrl + "filters_list";
}
