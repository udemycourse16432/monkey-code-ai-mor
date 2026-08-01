using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.ComponentModel.DataAnnotations;

namespace MillionsOfRecordsApp.Pages
{
    public class MyAccountModel : MillionsBasePageModel
    {
        public MyAccountModel(ReggaeDbContext context, CartService cartService, IReggaeDbContextProcedures procedures)
            : base(context, cartService, procedures)
        {
        }

        [BindProperty]
        public CustomerAccountViewModel AccountInfo { get; set; } = new CustomerAccountViewModel();

        public List<SelectListItem> CountryOptions { get; set; } = new();
        public List<SelectListItem> StateOptions { get; set; } = new();
        public List<SelectListItem> BillingStateOptions { get; set; } = new();

        public spGetWebCountryShippingZonesTRowResult? CountryShippingZone { get; set; }
        public spGetWebCountryShippingZonesTRowResult? CountryBillingZone { get; set; }

        public string ErrorMessage { get; set; } = string.Empty;
        public string SuccessMessage { get; set; } = string.Empty;

        public async Task<IActionResult> OnGetAsync()
        {
            int serverCounter = GetCustomerServerCounter();
            if (serverCounter <= 0)
            {
                return RedirectToPage("/Options");
            }

            await LoadCustomerDetailsAsync(serverCounter);
            await LoadLookupsAsync();

            return Page();
        }

        public async Task<IActionResult> OnPostSaveAccountInfoAsync()
        {
            int serverCounter = HttpContext.Session.GetCustomerServerCounter();
            if (serverCounter <= 0)
            {
                return RedirectToPage("/Options");
            }

            // 1. Sync SameAsShipping before checking model state
            if (AccountInfo.SameAsShipping)
            {
                AccountInfo.BillingFullName = AccountInfo.FullName;
                AccountInfo.BillingStreetAddress1 = AccountInfo.StreetAddress1;
                AccountInfo.BillingStreetAddress2 = AccountInfo.StreetAddress2;
                AccountInfo.BillingCity = AccountInfo.City;
                AccountInfo.BillingStateProvince = AccountInfo.StateProvince;
                AccountInfo.BillingPostalCode = AccountInfo.PostalCode;
                AccountInfo.BillingCountryCounter = AccountInfo.CountryCounter;

                foreach (var key in ModelState.Keys.Where(k => k.StartsWith("AccountInfo.Billing")).ToList())
                {
                    ModelState.Remove(key);
                }
            }

            // 2. Validate Country Dynamic Shipping/Billing Zones
            await ValidateCountryZonesAsync();

            // 3. Check overall ModelState validity
            if (!ModelState.IsValid)
            {
                ErrorMessage = "Please correct the errors in the form.";
                await LoadLookupsAsync();
                return Page();
            }

            try
            {
                // Check if LogInEmail is taken by another account
                var spCheckIfLogInEmailExistsResults = await _procedures.spCheckIfLogInEmailExistsAsync(AccountInfo.SignInEmail!, serverCounter);
                if (spCheckIfLogInEmailExistsResults.Any())
                {
                    ModelState.AddModelError("AccountInfo.SignInEmail", "This Sign-In Email already exists for another customer. Please enter a different Sign-In Email.");
                    ErrorMessage = "Please correct the errors in the form.";
                    await LoadLookupsAsync();
                    return Page();
                }

                // Resolve numeric Counters back to Country Codes/Names for Database storage
                List<CountryList> countries = await _context.CountryLists.ToListAsync();

                int.TryParse(AccountInfo.CountryCounter, out int shippingCountryId);
                AccountInfo.Country = countries.FirstOrDefault(c => c.Counter == shippingCountryId)?.Country ?? string.Empty;

                int.TryParse(AccountInfo.BillingCountryCounter, out int billingCountryId);
                AccountInfo.BillingCountry = countries.FirstOrDefault(c => c.Counter == billingCountryId)?.Country ?? string.Empty;

                // Perform Customer Update using resolved string Country codes
                await _procedures.spUpdateCustomersAsync(
                    email: AccountInfo.Email,
                    phone: AccountInfo.Phone,
                    residentialDelivery: "N",
                    blockedFromCheckout: "N",
                    chargeSalesTax: null,
                    priceGroup: "StorePrice",
                    fullName: AccountInfo.FullName,
                    streetAddress1: AccountInfo.StreetAddress1,
                    streetAddress2: AccountInfo.StreetAddress2,
                    city: AccountInfo.City,
                    stateProvince: AccountInfo.StateProvince,
                    postalCode: AccountInfo.PostalCode,
                    island: null,
                    country: AccountInfo.Country,
                    billingFullName: AccountInfo.BillingFullName,
                    billingStreetAddress1: AccountInfo.BillingStreetAddress1,
                    billingStreetAddress2: AccountInfo.BillingStreetAddress2,
                    billingCity: AccountInfo.BillingCity,
                    billingStateProvince: AccountInfo.BillingStateProvince,
                    billingPostalCode: AccountInfo.BillingPostalCode,
                    billingIsland: null,
                    billingCountry: AccountInfo.BillingCountry,
                    logInEmail: AccountInfo.SignInEmail,
                    password: AccountInfo.Password,
                    counter: serverCounter
                );

                // Update session state with string country codes
                HttpContext.Session.SetCountry(AccountInfo.Country);
                HttpContext.Session.SetPostalCode(AccountInfo.PostalCode);
                HttpContext.Session.SetBillingCountry(AccountInfo.BillingCountry);
                HttpContext.Session.SetBillingPostalCode(AccountInfo.BillingPostalCode);

                SuccessMessage = "Account information updated successfully.";
            }
            catch (Exception ex)
            {
                ErrorMessage = "An error occurred while saving account information: " + ex.Message;
            }

            await LoadLookupsAsync();
            return Page();
        }

        private async Task ValidateCountryZonesAsync()
        {
            List<CountryList> countries = await _context.CountryLists.ToListAsync();

            // Validate Shipping Country Rules
            if (int.TryParse(AccountInfo.CountryCounter, out int shippingCountryId))
            {
                string selectedShippingCountry = countries.FirstOrDefault(x => x.Counter == shippingCountryId)?.Country ?? string.Empty;
                if (!string.IsNullOrEmpty(selectedShippingCountry))
                {
                    var countryZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(selectedShippingCountry);
                    var zone = countryZones?.FirstOrDefault();

                    if (zone != null)
                    {
                        if (zone.CityRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.City))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.CityWord) ? "City" : zone.CityWord;
                            ModelState.AddModelError("AccountInfo.City", $"{word} is required.");
                        }
                        if (zone.StateProvinceRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.StateProvince))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.StateProvinceWord) ? "State/Province" : zone.StateProvinceWord;
                            ModelState.AddModelError("AccountInfo.StateProvince", $"{word} is required.");
                        }
                        if (zone.PostalCodeRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.PostalCode))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.PostalCodeWord) ? "Postal Code" : zone.PostalCodeWord;
                            ModelState.AddModelError("AccountInfo.PostalCode", $"{word} is required.");
                        }
                    }
                }
            }

            // Validate Billing Country Rules
            if (!AccountInfo.SameAsShipping && int.TryParse(AccountInfo.BillingCountryCounter, out int billingCountryId))
            {
                string selectedBillingCountry = countries.FirstOrDefault(x => x.Counter == billingCountryId)?.Country ?? string.Empty;
                if (!string.IsNullOrEmpty(selectedBillingCountry))
                {
                    var billingZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(selectedBillingCountry);
                    var zone = billingZones?.FirstOrDefault();

                    if (zone != null)
                    {
                        if (zone.CityRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.BillingCity))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.CityWord) ? "City" : zone.CityWord;
                            ModelState.AddModelError("AccountInfo.BillingCity", $"Billing {word} is required.");
                        }
                        if (zone.StateProvinceRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.BillingStateProvince))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.StateProvinceWord) ? "State/Province" : zone.StateProvinceWord;
                            ModelState.AddModelError("AccountInfo.BillingStateProvince", $"Billing {word} is required.");
                        }
                        if (zone.PostalCodeRequired != "n" && string.IsNullOrWhiteSpace(AccountInfo.BillingPostalCode))
                        {
                            string word = string.IsNullOrWhiteSpace(zone.PostalCodeWord) ? "Postal Code" : zone.PostalCodeWord;
                            ModelState.AddModelError("AccountInfo.BillingPostalCode", $"Billing {word} is required.");
                        }
                    }
                }
            }
        }
        #region Change Handlers

        public async Task<IActionResult> OnPostSameAsShippingChangedAsync()
        {
            ModelState.Clear();

            if (AccountInfo.SameAsShipping)
            {
                AccountInfo.BillingCountryCounter = AccountInfo.CountryCounter;
                AccountInfo.BillingFullName = AccountInfo.FullName;
                AccountInfo.BillingStreetAddress1 = AccountInfo.StreetAddress1;
                AccountInfo.BillingStreetAddress2 = AccountInfo.StreetAddress2;
                AccountInfo.BillingCity = AccountInfo.City;
                AccountInfo.BillingStateProvince = AccountInfo.StateProvince;
                AccountInfo.BillingPostalCode = AccountInfo.PostalCode;
            }

            await LoadLookupsAsync();
            return Page();
        }

        public async Task<IActionResult> OnPostShippingCountryChangedAsync()
        {
            ModelState.Clear();
            AccountInfo.StateProvince = string.Empty;
            await LoadLookupsAsync();
            return Page();
        }

        public async Task<IActionResult> OnPostBillingCountryChangedAsync()
        {
            ModelState.Clear();
            AccountInfo.BillingStateProvince = string.Empty;
            await LoadLookupsAsync();
            return Page();
        }

        #endregion

        #region Helpers

        private async Task LoadCustomerDetailsAsync(int serverCounter)
        {
            var spGetCustomerDetailsByServerCounterResults =
                await _procedures.spGetCustomerDetailsByServerCounterAsync(serverCounter);

            if (spGetCustomerDetailsByServerCounterResults.Any())
            {
                var customer = spGetCustomerDetailsByServerCounterResults.First();
                AccountInfo = new CustomerAccountViewModel
                {
                    SignInEmail = customer.LogInEmail,
                    Password = customer.Password,
                    Email = customer.Email,
                    Phone = customer.Phone,
                    FullName = customer.FullName,
                    StreetAddress1 = customer.StreetAddress1,
                    StreetAddress2 = customer.StreetAddress2,
                    City = customer.City,
                    StateProvince = customer.StateProvince,
                    PostalCode = customer.PostalCode,
                    Country = customer.Country,
                    BillingFullName = customer.BillingFullName,
                    BillingStreetAddress1 = customer.BillingStreetAddress1,
                    BillingStreetAddress2 = customer.BillingStreetAddress2,
                    BillingCity = customer.BillingCity,
                    BillingStateProvince = customer.BillingStateProvince,
                    BillingPostalCode = customer.BillingPostalCode,
                    BillingCountry = customer.BillingCountry
                };
            }
        }

        private async Task LoadLookupsAsync()
        {
            List<CountryList> countries = await _context.CountryLists.OrderBy(x => x.SortOrderText).ToListAsync();

            CountryOptions = countries.Select(c => new SelectListItem
            {
                Value = c.Counter.ToString(),
                Text = c.CountryText
            }).ToList();

            // Match Shipping Country to lookup records
            CountryList? shippingCountryRecord = countries.FirstOrDefault(x =>
                (x.Country == AccountInfo.Country && x.StateProvince == AccountInfo.StateProvince && x.City == AccountInfo.City) ||
                (x.Country == AccountInfo.Country && x.StateProvince == AccountInfo.StateProvince && string.IsNullOrEmpty(x.City)) ||
                (x.Country == AccountInfo.Country && string.IsNullOrEmpty(x.StateProvince) && string.IsNullOrEmpty(x.City)));

            if (shippingCountryRecord != null && string.IsNullOrEmpty(AccountInfo.CountryCounter))
            {
                AccountInfo.CountryCounter = shippingCountryRecord.Counter.ToString();
            }

            int.TryParse(AccountInfo.CountryCounter, out int shippingCountryId);
            string shippingCountryName = countries.FirstOrDefault(x => x.Counter == shippingCountryId)?.Country ?? AccountInfo.Country ?? string.Empty;

            if (!string.IsNullOrEmpty(shippingCountryName))
            {
                var states = await _procedures.spGetWebCountryStateProvincesListAsync(shippingCountryName);
                StateOptions = states.Select(s => new SelectListItem { Value = s.StateProvince, Text = s.StateProvince }).ToList();

                var zones = await _procedures.spGetWebCountryShippingZonesTRowAsync(shippingCountryName);
                CountryShippingZone = zones.FirstOrDefault();
            }

            // Match Billing Country to lookup records
            string billingCountryCode = (AccountInfo.SameAsShipping
                ? AccountInfo.Country
                : (AccountInfo.BillingCountry ?? AccountInfo.Country)) ?? string.Empty;

            string billingStateProvince = (AccountInfo.SameAsShipping
                ? AccountInfo.StateProvince
                : (AccountInfo.BillingStateProvince ?? AccountInfo.StateProvince)) ?? string.Empty;

            string billingCity = (AccountInfo.SameAsShipping
                ? AccountInfo.City
                : (AccountInfo.BillingCity ?? AccountInfo.City)) ?? string.Empty;

            CountryList? billingCountryRecord = countries.FirstOrDefault(x =>
                (x.Country == billingCountryCode && x.StateProvince == billingStateProvince && x.City == billingCity) ||
                (x.Country == billingCountryCode && x.StateProvince == billingStateProvince && string.IsNullOrEmpty(x.City)) ||
                (x.Country == billingCountryCode && string.IsNullOrEmpty(x.StateProvince) && string.IsNullOrEmpty(x.City)));

            if (billingCountryRecord != null && string.IsNullOrEmpty(AccountInfo.BillingCountryCounter))
            {
                AccountInfo.BillingCountryCounter = billingCountryRecord.Counter.ToString();
            }

            string billingCountryCounterVal = (AccountInfo.SameAsShipping
                ? AccountInfo.CountryCounter
                : (AccountInfo.BillingCountryCounter ?? AccountInfo.CountryCounter)) ?? string.Empty;

            int.TryParse(billingCountryCounterVal, out int billingCountryId);
            string billingCountryName = countries.FirstOrDefault(x => x.Counter == billingCountryId)?.Country ?? billingCountryCode ?? string.Empty;

            if (!string.IsNullOrEmpty(billingCountryName))
            {
                var billingStates = await _procedures.spGetWebCountryStateProvincesListAsync(billingCountryName);
                BillingStateOptions = billingStates.Select(s => new SelectListItem { Value = s.StateProvince, Text = s.StateProvince }).ToList();

                var billingZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(billingCountryName);
                CountryBillingZone = billingZones.FirstOrDefault();
            }
        }

        private int GetCustomerServerCounter()
        {
            return HttpContext.Session.GetCustomerServerCounter();
        }

        #endregion
    }

    #region View Models

    public class CustomerAccountViewModel
    {
        [Required(ErrorMessage = "Sign-In Email is required.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        public string? SignInEmail { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters.")]
        public string? Password { get; set; }

        [Required(ErrorMessage = "Email address is required.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        public string? Email { get; set; }

        [Required(ErrorMessage = "Telephone Number is required.")]
        public string? Phone { get; set; }

        [Required(ErrorMessage = "Full Name is required.")]
        [StringLength(100, ErrorMessage = "Full Name cannot exceed 100 characters.")]
        public string? FullName { get; set; }

        [Required(ErrorMessage = "Street Address is required.")]
        public string? StreetAddress1 { get; set; }

        public string? StreetAddress2 { get; set; }
        public string? City { get; set; }
        public string? StateProvince { get; set; }
        public string? PostalCode { get; set; }

        [Required(ErrorMessage = "Country is required.")]
        public string? CountryCounter { get; set; }
        public string? Country { get; set; }

        public bool SameAsShipping { get; set; } = false;

        // Billing Fields
        [Required(ErrorMessage = "Billing Full Name is required.")]
        [StringLength(100, ErrorMessage = "Billing Full Name cannot exceed 100 characters.")]
        public string? BillingFullName { get; set; }

        [Required(ErrorMessage = "Billing Street Address is required.")]
        public string? BillingStreetAddress1 { get; set; }

        public string? BillingStreetAddress2 { get; set; }
        public string? BillingCity { get; set; }
        public string? BillingStateProvince { get; set; }
        public string? BillingPostalCode { get; set; }

        [Required(ErrorMessage = "Billing Country is required.")]
        public string? BillingCountryCounter { get; set; }
        public string? BillingCountry { get; set; }
    }

    #endregion
}