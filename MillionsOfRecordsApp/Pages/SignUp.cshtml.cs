using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Models;
using MillionsOfRecordsApp.Pages.Base;
using MillionsOfRecordsApp.Services;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Text;
using System.Text.RegularExpressions;

namespace MillionsOfRecordsApp.Pages
{
    public class SignUpModel : MillionsBasePageModel
    {
        private readonly IEmailService _emailService;
        private readonly ICustomerValidationService _validationService;
        private readonly CustomerAuthService _authService;
        public SignUpModel(
            ICustomerValidationService validationService,
            CustomerAuthService authService,
            ReggaeDbContext context,
            CartService cartService,
            IReggaeDbContextProcedures procedures,
            IEmailService emailService)
            : base(context, cartService, procedures)
        {
            _validationService = validationService;
            _authService = authService;
            _emailService = emailService;
        }

        [BindProperty(SupportsGet = true)]
        public string? Country { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? WholesaleOrRetailTxt { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? CountryListCode { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? ContinueToPurchasePage { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? CountryChangedTxt { get; set; }

        [BindProperty(SupportsGet = true)]
        public string? BillingCountryChangedTxt { get; set; }

        [BindProperty]
        public SignupInputModel Input { get; set; } = new();

        public List<SelectListItem> CountryOptions { get; set; } = new();
        public List<SelectListItem> StateOptions { get; set; } = new();
        public List<SelectListItem> BillingStateOptions { get; set; } = new();

        public string ErrorMessage { get; set; } = string.Empty;
        public bool ShowPostalCodeWarning { get; set; }

        public spGetWebCountryShippingZonesTRowResult? CountryShippingZone { get; set; }
        public spGetWebCountryShippingZonesTRowResult? CountryBillingZone { get; set; }
        public async Task<IActionResult> OnGetAsync()
        {
            // Guard clause: redirect if no country context is provided
            bool hasNumericCountryCode = int.TryParse(CountryListCode, out int countryListCodeCounter);
            bool countryChanged = string.Equals(CountryChangedTxt, "yes", StringComparison.OrdinalIgnoreCase);
            bool billingCountryChanged = string.Equals(BillingCountryChangedTxt, "yes", StringComparison.OrdinalIgnoreCase);
            bool hasCountry = !string.IsNullOrWhiteSpace(Input.Country);

            if (!hasNumericCountryCode && !countryChanged && !billingCountryChanged && !hasCountry)
            {
                return RedirectToPage("/SignIn");
            }

            // Fix: Pre-populate Input.Country from CountryListCode on initial GET
            if (hasNumericCountryCode)
            {
                if (string.IsNullOrEmpty(Input.Country))
                {
                    Input.Country = countryListCodeCounter.ToString();
                }

                // Optionally set billing country if not already set
                if (string.IsNullOrEmpty(Input.BillingCountry))
                {
                    Input.BillingCountry = countryListCodeCounter.ToString();
                }
            }

            await LoadLookupsAsync();
            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            // 1. If "Same as Shipping" is checked, sync values AND clear static DataAnnotation errors for Billing
            if (Input.SameAsShipping)
            {
                Input.BillingFullName = Input.FullName;
                Input.BillingStreetAddress1 = Input.StreetAddress1;
                Input.BillingStreetAddress2 = Input.StreetAddress2;
                Input.BillingCity = Input.City;
                Input.BillingStateOrProvince = Input.StateOrProvince;
                Input.BillingPostalCode = Input.PostalCode;
                Input.BillingIsland = Input.Island;
                Input.BillingCountry = Input.Country;

                // Clear pre-existing DataAnnotation validation errors on Billing fields
                foreach (var key in ModelState.Keys.Where(k => k.StartsWith("Input.Billing")).ToList())
                {
                    ModelState.Remove(key);
                }
            }

            // 2. Run your custom business & dynamic country zone validation
            var validationResult = await _validationService.ValidateCustomerSignupAsync(Input);

            if (!validationResult.IsValid)
            {
                foreach (var error in validationResult.Errors)
                {
                    ModelState.AddModelError($"Input.{error.Key}", error.Value);
                }
            }

            // 3. Now check overall ModelState validity
            if (!ModelState.IsValid)
            {
                await LoadLookupsAsync();
                return Page();
            }

            await InsertCustomerAsync();

            // 4. Authenticate & Migrate Guest Cart
            bool loginSuccess = await _authService.ProcessLoginAndMigrateAsync(HttpContext, Input.EmailAddress, Input.Password);

            if (!loginSuccess)
            {
                // Fallback safety in case spGetCustomerDetails fails immediately after insertion
                TempData["ErrorMessage"] = "Account created, but automatic sign-in failed. Please sign in manually.";
                return RedirectToPage("/SignIn");
            }

            return RedirectToPage("/WholesaleAccepted");
        }

        private async Task InsertCustomerAsync()
        {
            string varWholesaleOrRetail = string.Equals(WholesaleOrRetailTxt, "wholesale", StringComparison.OrdinalIgnoreCase)
                ? "wholesale"
                : "retail";

            string varPriceGroup = varWholesaleOrRetail == "wholesale" ? "StorePrice" : "RetailPrice";
            int varNewCustomerCounter = 0;
            string varNewCustomerID = "NEW-CUST0";
            string ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "";

            string defaultFullName = CapFirstLetter(SanitizeNameAndAddress(Input.FullName));
            string defaultStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Input.StreetAddress1));
            string defaultStreetAddress2 = SanitizeNameAndAddress(Input.StreetAddress2 ?? string.Empty);
            string defaultCity = CapFirstLetter(SanitizeNameAndAddress(Input.City));
            string defaultStateProvince = CapFirstLetter(SanitizeNameAndAddress(Input.StateOrProvince));
            string defaultPostalCode = Input.PostalCode.Trim();
            string defaultIsland = CapFirstLetter(SanitizeNameAndAddress(Input.Island ?? string.Empty));
            string defaultCountry = Input.Country;

            string defaultBillingFullName = CapFirstLetter(SanitizeNameAndAddress(Input.BillingFullName));
            string defaultBillingStreetAddress1 = CapFirstLetter(SanitizeNameAndAddress(Input.BillingStreetAddress1));
            string defaultBillingStreetAddress2 = SanitizeNameAndAddress(Input.BillingStreetAddress2 ?? string.Empty);
            string defaultBillingCity = CapFirstLetter(SanitizeNameAndAddress(Input.BillingCity));
            string defaultBillingStateProvince = CapFirstLetter(SanitizeNameAndAddress(Input.BillingStateOrProvince));
            string? defaultBillingPostalCode = Input.BillingPostalCode?.Trim();
            string defaultBillingIsland = CapFirstLetter(SanitizeNameAndAddress(Input.BillingIsland ?? string.Empty));
            string? defaultBillingCountry = Input.BillingCountry;

            string defaultPhone = SanitizeNameAndAddress(Input.TelephoneNumber);
            string? defaultPhone2 = null;
            string? defaultPhone3 = null;
            string defaultEmail = SanitizeNameAndAddress(Input.EmailAddress);
            string? defaultEmail2 = null;
            string? defaultEmail3 = null;

            if (defaultEmail.Length > 4 && defaultEmail.Substring(0, 4).Equals("WWW.", StringComparison.OrdinalIgnoreCase))
            {
                defaultEmail = defaultEmail.Substring(4);
            }

            string defaultLogInEmail = defaultEmail;

            string defaultPassword = Input.Password;
            string defaultResidentialDelivery = varWholesaleOrRetail == "wholesale" ? "n" : "y";

            string? defaultChargeSalesTax = null;
            string? defaultHowFoundUs = null;
            string defaultIPAddress = ipAddress;

            // Resolve numeric Counters back to Country Codes/Names for Database storage
            List<CountryList> countries = await _context.CountryLists.ToListAsync();

            int.TryParse(Input.Country, out int shippingCountryId);
            defaultCountry = countries.FirstOrDefault(c => c.Counter == shippingCountryId)?.Country ?? string.Empty;

            int.TryParse(Input.BillingCountry, out int billingCountryId);
            defaultBillingCountry = countries.FirstOrDefault(c => c.Counter == billingCountryId)?.Country ?? string.Empty;


            var idOutput = new OutputParameter<int?>();

            var resultList = await _procedures.spInsertCustomerAsync(
                varPriceGroup,
                varNewCustomerID,
                defaultFullName,
                defaultStreetAddress1,
                defaultStreetAddress2,
                defaultCity,
                defaultStateProvince,
                defaultPostalCode,
                defaultIsland,
                defaultCountry,
                defaultBillingFullName,
                defaultBillingStreetAddress1,
                defaultBillingStreetAddress2,
                defaultBillingCity,
                defaultBillingStateProvince,
                defaultBillingPostalCode,
                defaultBillingIsland,
                defaultBillingCountry,
                defaultPhone,
                defaultPhone2,
                defaultPhone3,
                defaultEmail,
                defaultEmail2,
                defaultEmail3,
                defaultLogInEmail,
                defaultPassword,
                defaultHowFoundUs,
                defaultIPAddress,
                defaultResidentialDelivery,
                defaultChargeSalesTax,
                idOutput
                );

            varNewCustomerCounter = idOutput.Value ?? 0;

            await _procedures.spInsertNewReleaseEmailOptInOrOutAsync(defaultPassword, defaultEmail, defaultFullName);


            // Send Email 'Email Ernie
            var sb = new StringBuilder();

            sb.AppendLine(defaultPhone);
            sb.AppendLine();
            sb.AppendLine("BILL TO ADDRESS:");
            sb.AppendLine();
            sb.AppendLine(defaultBillingFullName);
            sb.AppendLine(defaultBillingStreetAddress1);

            if (!string.IsNullOrWhiteSpace(defaultBillingStreetAddress2)) sb.AppendLine(defaultBillingStreetAddress2);
            if (!string.IsNullOrWhiteSpace(defaultBillingCity)) sb.AppendLine(defaultBillingCity);
            if (!string.IsNullOrWhiteSpace(defaultBillingStateProvince)) sb.AppendLine(defaultBillingStateProvince);
            if (!string.IsNullOrWhiteSpace(defaultBillingPostalCode)) sb.AppendLine(defaultBillingPostalCode);
            if (!string.IsNullOrWhiteSpace(defaultBillingIsland)) sb.AppendLine(defaultBillingIsland);
            if (!string.IsNullOrWhiteSpace(defaultBillingCountry)) sb.AppendLine(defaultBillingCountry);

            sb.AppendLine();
            sb.AppendLine();
            sb.AppendLine("SHIP TO ADDRESS:");
            sb.AppendLine();
            sb.AppendLine(defaultFullName);
            sb.AppendLine(defaultStreetAddress1);

            if (!string.IsNullOrWhiteSpace(defaultStreetAddress2)) sb.AppendLine(defaultStreetAddress2);
            if (!string.IsNullOrWhiteSpace(defaultCity)) sb.AppendLine(defaultCity);
            if (!string.IsNullOrWhiteSpace(defaultStateProvince)) sb.AppendLine(defaultStateProvince);
            if (!string.IsNullOrWhiteSpace(defaultPostalCode)) sb.AppendLine(defaultPostalCode);
            if (!string.IsNullOrWhiteSpace(defaultIsland)) sb.AppendLine(defaultIsland);
            if (!string.IsNullOrWhiteSpace(defaultCountry)) sb.AppendLine(defaultCountry);

            sb.AppendLine();
            sb.AppendLine(defaultEmail);

            string varEmailBody = sb.ToString();
            await _emailService.SendEmailAsync(
                toEmail:"ernieb12345@gmail.com", 
                subject: $"NWEB {defaultFullName} - {defaultCountry}",
                htmlMessage: varEmailBody);
        }
        private string CapFirstLetter(string? input)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            input = input.Trim();
            return char.ToUpper(input[0]) + (input.Length > 1 ? input.Substring(1) : "");
        }

        private string SanitizeNameAndAddress(string? input)
        {
            if (string.IsNullOrWhiteSpace(input)) return string.Empty;
            return input.Trim();
        }
        #region Change Handlers
        public async Task<IActionResult> OnPostSameAsShippingChangedAsync()
        {
            ModelState.Clear();

            if (Input.SameAsShipping)
            {
                // Force Billing Country to match Shipping Country
                Input.BillingCountry = Input.Country;
                Input.BillingFullName = Input.FullName;
                Input.BillingStreetAddress1 = Input.StreetAddress1;
                Input.BillingStreetAddress2 = Input.StreetAddress2;
                Input.BillingCity = Input.City;
                Input.BillingStateOrProvince = Input.StateOrProvince;
                Input.BillingPostalCode = Input.PostalCode;
                Input.BillingIsland = Input.Island;
            }

            await LoadLookupsAsync();
            return Page();
        }
        public async Task<IActionResult> OnPostShippingCountryChangedAsync()
        {
            // Clear validation errors since the form is incomplete during country selection
            ModelState.Clear();

            // Reset shipping state selection if country changes
            Input.StateOrProvince = string.Empty;

            // Reload lookups to fetch updated states/zones for the selected shipping country
            await LoadLookupsAsync();

            return Page();
        }

        public async Task<IActionResult> OnPostBillingCountryChangedAsync()
        {
            // Clear validation errors
            ModelState.Clear();

            // Reset billing state selection if billing country changes
            Input.BillingStateOrProvince = string.Empty;

            // Reload lookups to fetch updated states/zones for the selected billing country
            await LoadLookupsAsync();

            return Page();
        }

        #endregion
        #region Helper & Validation Methods

        private async Task LoadLookupsAsync()
        {
            var countries = await _procedures.spGetCountryListAsync();

            // Populate dropdown options
            CountryOptions = countries.Select(c => new SelectListItem
            {
                Value = c.counter.ToString(),
                Text = c.CountryText
            }).ToList();

            int.TryParse(Input.Country ?? CountryListCode ?? "0", out int shippingCountryId);
            string shippingCountryName = countries.FirstOrDefault(x => x.counter == shippingCountryId)?.Country ?? string.Empty;

            if (!string.IsNullOrEmpty(shippingCountryName))
            {
                var states = await _procedures.spGetWebCountryStateProvincesListAsync(shippingCountryName);
                StateOptions = states.Select(s => new SelectListItem { Value = s.StateProvince, Text = s.StateProvince }).ToList();

                var zones = await _procedures.spGetWebCountryShippingZonesTRowAsync(shippingCountryName);
                CountryShippingZone = zones.FirstOrDefault();
            }

            string billingCountryCode = Input.SameAsShipping ? Input.Country : (Input.BillingCountry ?? Input.Country ?? CountryListCode);
            int.TryParse(billingCountryCode ?? "0", out int billingCountryId);
            string billingCountryName = countries.FirstOrDefault(x => x.counter == billingCountryId)?.Country ?? string.Empty;

            if (!string.IsNullOrEmpty(billingCountryName))
            {
                var billingStates = await _procedures.spGetWebCountryStateProvincesListAsync(billingCountryName);
                BillingStateOptions = billingStates.Select(s => new SelectListItem { Value = s.StateProvince, Text = s.StateProvince }).ToList();

                var billingZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(billingCountryName);
                CountryBillingZone = billingZones.FirstOrDefault();
            }

        }

        #endregion
    }

    public class SignupInputModel
    {
        [Required(ErrorMessage = "Full Name is required.")]
        [StringLength(100, ErrorMessage = "Full Name cannot exceed 100 characters.")]
        public string FullName { get; set; } = string.Empty;

        public string? StoreName { get; set; }

        [Required(ErrorMessage = "Street Address is required.")]
        public string StreetAddress1 { get; set; } = string.Empty;

        public string? StreetAddress2 { get; set; }

        public string City { get; set; } = string.Empty;

        public string StateOrProvince { get; set; } = string.Empty;

        public string PostalCode { get; set; } = string.Empty;

        public string? Island { get; set; }

        [Required(ErrorMessage = "Country is required.")]
        public string Country { get; set; } = string.Empty;

        [Required(ErrorMessage = "Telephone Number is required.")]
        public string TelephoneNumber { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email address is required.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        public string EmailAddress { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password is required.")]
        [MinLength(6, ErrorMessage = "Password must be at least 6 characters.")]
        public string Password { get; set; } = string.Empty;

        public bool SameAsShipping { get; set; } = false;

        // Billing Fields
        [Required(ErrorMessage = "Billing Full Name is required.")]
        [StringLength(100, ErrorMessage = "Billing Full Name cannot exceed 100 characters.")]
        public string? BillingFullName { get; set; }

        [Required(ErrorMessage = "Billing Street Address is required.")]
        public string? BillingStreetAddress1 { get; set; }
        public string? BillingStreetAddress2 { get; set; }
        public string? BillingCity { get; set; }
        public string? BillingStateOrProvince { get; set; }
        public string? BillingPostalCode { get; set; }
        public string? BillingIsland { get; set; }
        [Required(ErrorMessage = "Billing Country is required.")]
        public string? BillingCountry { get; set; }

        public bool NewReleaseOptIn { get; set; }
        public bool CheckedPostalCodeOverride { get; set; }
    }

    public interface ICustomerValidationService
    {
        Task<CustomerValidationResult> ValidateCustomerSignupAsync(SignupInputModel input);
    }

    public class CustomerValidationResult
    {
        public bool IsValid => !Errors.Any();
        public Dictionary<string, string> Errors { get; } = new();
        public bool IsPostalCodeWarning { get; set; }
    }

    public class CustomerValidationService : ICustomerValidationService
    {
        private readonly CustomerService _customerService;
        private readonly IReggaeDbContextProcedures _procedures;

        public CustomerValidationService(CustomerService customerService, IReggaeDbContextProcedures procedures)
        {
            _customerService = customerService;
            _procedures = procedures;
        }

        public async Task<CustomerValidationResult> ValidateCustomerSignupAsync(SignupInputModel input)
        {
            var result = new CustomerValidationResult();

            // 1. Email check
            bool emailExists = await _customerService.CheckLogInEmailExists(input.EmailAddress);
            if (emailExists)
            {
                result.Errors.Add(nameof(input.EmailAddress), "This email address is already registered.");
            }

            // 2. Phone check
            if (IsBadPhone(input.TelephoneNumber))
            {
                result.Errors.Add(nameof(input.TelephoneNumber), "Please enter a valid telephone number with standard digits.");
            }

            var countries = await _procedures.spGetCountryListAsync();

            // 3. Shipping Country Zone Validation
            if (int.TryParse(input.Country, out int shippingCountryId))
            {
                string selectedShippingCountry = countries.FirstOrDefault(x => x.counter == shippingCountryId)?.Country ?? string.Empty;

                if (!string.IsNullOrEmpty(selectedShippingCountry))
                {
                    var countryZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(selectedShippingCountry);
                    var shippingZone = countryZones?.FirstOrDefault();

                    if (shippingZone != null)
                    {
                        if (shippingZone.CityRequired != "n" && string.IsNullOrWhiteSpace(input.City))
                        {
                            string word = string.IsNullOrWhiteSpace(shippingZone.CityWord) ? "City" : shippingZone.CityWord;
                            result.Errors.Add(nameof(input.City), $"{word} is required.");
                        }

                        if (shippingZone.StateProvinceRequired != "n" && string.IsNullOrWhiteSpace(input.StateOrProvince))
                        {
                            string word = string.IsNullOrWhiteSpace(shippingZone.StateProvinceWord) ? "State/Province" : shippingZone.StateProvinceWord;
                            result.Errors.Add(nameof(input.StateOrProvince), $"{word} is required.");
                        }

                        if (shippingZone.PostalCodeRequired != "n" && string.IsNullOrWhiteSpace(input.PostalCode))
                        {
                            string word = string.IsNullOrWhiteSpace(shippingZone.PostalCodeWord) ? "Postal Code" : shippingZone.PostalCodeWord;
                            result.Errors.Add(nameof(input.PostalCode), $"{word} is required.");
                        }

                        if (shippingZone.IslandRequired != "n" && string.IsNullOrWhiteSpace(input.Island))
                        {
                            string word = string.IsNullOrWhiteSpace(shippingZone.IslandWord) ? "Island" : shippingZone.IslandWord;
                            result.Errors.Add(nameof(input.Island), $"{word} is required.");
                        }

                        if (!input.CheckedPostalCodeOverride && shippingZone.PostalCodeRequired != "n" && !string.IsNullOrEmpty(shippingZone.PostalCodeFormat))
                        {
                            if (!IsValidPostalPattern(input.PostalCode ?? "", shippingZone.PostalCodeFormat))
                            {
                                result.IsPostalCodeWarning = true;
                                result.Errors.Add(nameof(input.PostalCode), $"Postal code format does not match expected layout ({shippingZone.PostalCodeFormat}). Submit again to bypass.");
                            }
                        }
                    }
                }
            }

            // 4. Billing Country Zone Validation
            if (!input.SameAsShipping)
            {
                if (int.TryParse(input.BillingCountry, out int billingCountryId))
                {
                    string selectedBillingCountry = countries.FirstOrDefault(x => x.counter == billingCountryId)?.Country ?? string.Empty;

                    if (!string.IsNullOrEmpty(selectedBillingCountry))
                    {
                        var billingZones = await _procedures.spGetWebCountryShippingZonesTRowAsync(selectedBillingCountry);
                        var billingZone = billingZones?.FirstOrDefault();

                        if (billingZone != null)
                        {
                            if (billingZone.CityRequired != "n" && string.IsNullOrWhiteSpace(input.BillingCity))
                            {
                                string word = string.IsNullOrWhiteSpace(billingZone.CityWord) ? "City" : billingZone.CityWord;
                                result.Errors.Add(nameof(input.BillingCity), $"Billing {word} is required.");
                            }

                            if (billingZone.StateProvinceRequired != "n" && string.IsNullOrWhiteSpace(input.BillingStateOrProvince))
                            {
                                string word = string.IsNullOrWhiteSpace(billingZone.StateProvinceWord) ? "State/Province" : billingZone.StateProvinceWord;
                                result.Errors.Add(nameof(input.BillingStateOrProvince), $"Billing {word} is required.");
                            }

                            if (billingZone.PostalCodeRequired != "n" && string.IsNullOrWhiteSpace(input.BillingPostalCode))
                            {
                                string word = string.IsNullOrWhiteSpace(billingZone.PostalCodeWord) ? "Postal Code" : billingZone.PostalCodeWord;
                                result.Errors.Add(nameof(input.BillingPostalCode), $"Billing {word} is required.");
                            }

                            if (billingZone.IslandRequired != "n" && string.IsNullOrWhiteSpace(input.BillingIsland))
                            {
                                string word = string.IsNullOrWhiteSpace(billingZone.IslandWord) ? "Island" : billingZone.IslandWord;
                                result.Errors.Add(nameof(input.BillingIsland), $"Billing {word} is required.");
                            }

                            if (!input.CheckedPostalCodeOverride && billingZone.PostalCodeRequired != "n" && !string.IsNullOrEmpty(billingZone.PostalCodeFormat))
                            {
                                if (!IsValidPostalPattern(input.BillingPostalCode ?? "", billingZone.PostalCodeFormat))
                                {
                                    result.IsPostalCodeWarning = true;
                                    result.Errors.Add(nameof(input.BillingPostalCode), $"Billing postal code format does not match expected layout ({billingZone.PostalCodeFormat}). Submit again to bypass.");
                                }
                            }
                        }
                    }
                }
            }

            return result;
        }

        private static bool IsBadPhone(string phone)
        {
            if (string.IsNullOrWhiteSpace(phone)) return true;
            if (Regex.IsMatch(phone, @"^(.)\1+$")) return true; // Repeated chars e.g. "1111111"
            var digitsOnly = Regex.Replace(phone, @"\D", "");
            return digitsOnly.Length < 7 || digitsOnly.Length > 15;
        }

        private static bool IsValidPostalPattern(string postalCode, string rawFormatPattern)
        {
            // 1. If format pattern is missing/null or postal code is empty, consider valid
            if (string.IsNullOrWhiteSpace(rawFormatPattern) || string.IsNullOrWhiteSpace(postalCode))
                return true;

            // 2. Trim whitespace from inputs for cleaner comparison
            string cleanInput = postalCode.Trim();
            string cleanPattern = rawFormatPattern.Trim();

            // 3. Strip leading indicator flags ('O' for Optional, 'R' for Required) if present
            if (cleanPattern.StartsWith("O", StringComparison.OrdinalIgnoreCase) ||
                cleanPattern.StartsWith("R", StringComparison.OrdinalIgnoreCase))
            {
                cleanPattern = cleanPattern.Substring(1);
            }

            // 4. Handle space-optional flexibility (e.g. "LnL nLn" vs "LnLnLn")
            // If format contains spaces but input doesn't (or vice versa), compare without spaces
            if (cleanPattern.Contains(' ') && !cleanInput.Contains(' '))
            {
                cleanPattern = cleanPattern.Replace(" ", "");
            }
            else if (!cleanPattern.Contains(' ') && cleanInput.Contains(' '))
            {
                cleanInput = cleanInput.Replace(" ", "");
            }

            // 5. Length check after stripping flags and space normalizing
            if (cleanInput.Length != cleanPattern.Length)
                return false;

            // 6. Character mask comparison
            for (int i = 0; i < cleanPattern.Length; i++)
            {
                char mask = cleanPattern[i];
                char inputChar = cleanInput[i];

                switch (mask)
                {
                    case 'n': // Digit required
                        if (!char.IsDigit(inputChar)) return false;
                        break;

                    case 'L': // Letter required
                        if (!char.IsLetter(inputChar)) return false;
                        break;

                    case '-': // Dash exact match
                    case ' ': // Space exact match
                        if (inputChar != mask) return false;
                        break;

                    default:
                        // Fallback for literal characters in format
                        if (char.ToUpperInvariant(inputChar) != char.ToUpperInvariant(mask))
                            return false;
                        break;
                }
            }

            return true;
        }
    }
}

