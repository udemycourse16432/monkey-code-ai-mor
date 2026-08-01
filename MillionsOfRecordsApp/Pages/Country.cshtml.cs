using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.Data;

namespace MillionsOfRecordsApp.Pages
{
    public class CountryModel : MillionsBasePageModel
    {
        public CountryModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures)
            : base(context, cartService, procedures) { }

        // Query parameters / hidden state passed into the page
        [BindProperty(SupportsGet = true)]
        public string WholesaleOrRetailTxt { get; set; } = "retail";

        [BindProperty(SupportsGet = true)]
        public string ContinueToPurchasePage { get; set; } = "no";

        // View model list for countries
        public List<CountryItem> CountryList { get; set; } = new();

        public int DefaultCountryCounter { get; set; } = 2991; // Default to United States (Counter = 2991)

        public async Task<IActionResult> OnGetAsync(string? wr, string? continueToPurchasePage)
        {
            // Parity with Legacy: Handle "wr" query string override
            if (string.Equals(wr, "r", StringComparison.OrdinalIgnoreCase))
            {
                WholesaleOrRetailTxt = "retail";
            }
            else if (string.Equals(wr, "w", StringComparison.OrdinalIgnoreCase))
            {
                WholesaleOrRetailTxt = "wholesale";
            }

            // Parity with Legacy: Handle "ContinueToPurchasePage" query string flag
            if (string.Equals(continueToPurchasePage, "y", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(ContinueToPurchasePage, "y", StringComparison.OrdinalIgnoreCase))
            {
                ContinueToPurchasePage = "y";
            }
            else
            {
                ContinueToPurchasePage = "no";
            }

            // Execute spGetCountryList via DbContext
            CountryList = await FetchCountryListAsync();

            return Page();
        }

        private async Task<List<CountryItem>> FetchCountryListAsync()
        {
            var results = new List<CountryItem>();

            var countries = await _procedures.spGetCountryListAsync();
            foreach (var country in countries)
            {
                results.Add(new CountryItem
                {
                    Counter = country.counter,
                    CountryText = country.CountryText
                });
            }

            return results;
        }
    }

    public class CountryItem
    {
        public int Counter { get; set; }
        public string CountryText { get; set; } = string.Empty;
    }
}