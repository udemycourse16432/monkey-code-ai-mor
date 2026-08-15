using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Extensions;
using MillionsOfRecordsApp.Models.Shared;
using MillionsOfRecordsApp.Services;
using System.ComponentModel.DataAnnotations;
using System.Text.Encodings.Web;

namespace MillionsOfRecordsApp.Pages
{
    public class SignInModel : PageModel
    {
        private readonly CustomerAuthService _authService;
        private readonly CustomerService _customerService;
        private readonly IEmailService _emailService;
        private readonly ILogger<SignInModel> _logger;
        private readonly IWebHostEnvironment _env;
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly IConfiguration _configuration;

        public SignInModel(CustomerAuthService authService, CustomerService customerService, IEmailService emailService, ILogger<SignInModel> logger, IWebHostEnvironment env, IReggaeDbContextProcedures procedures, IConfiguration configuration)
        {
            _authService = authService;
            _customerService = customerService;
            _emailService = emailService;
            _logger = logger;
            _env = env;
            _procedures = procedures;
            _configuration = configuration;
        }
        [BindProperty(SupportsGet = true)]
        public string? ReturnUrl { get; set; }
        [BindProperty]
        public string Email { get; set; } = string.Empty;

        [BindProperty]
        public string Password { get; set; } = string.Empty;

        public string ErrorMessage { get; set; } = string.Empty;

        // Bind model for the Contact Us modal form
        [BindProperty]
        public ContactUsInputModel ContactForm { get; set; } = new();

        public void OnGet()
        {
            // Pull the error from TempData (if it exists) and put it in the Model property
            if (TempData.ContainsKey("ErrorMessage"))
            {
                ErrorMessage = TempData["ErrorMessage"]?.ToString() ?? string.Empty;
            }

            // Optional: If you want to persist the email address so they don't have to re-type it
            if (TempData.ContainsKey("SubmittedEmail"))
            {
                Email = TempData["SubmittedEmail"]?.ToString() ?? string.Empty;
            }
        }

        public async Task<IActionResult> OnPostAsync()
        {
            // Clear validation state for contact form modal fields so they don't block login
            foreach (var key in ModelState.Keys.Where(k => k != nameof(Email) && k != nameof(Password)).ToList())
            {
                ModelState.Remove(key);
            }

            if (!ModelState.IsValid) return Page();

            var cleanEmail = Email.Trim();
            var cleanPassword = Password.Trim();

            string userIp = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";

            // Special Legacy Admin Logins
            if (cleanEmail == "@." && cleanPassword.Equals("AMESSAGE3921", StringComparison.OrdinalIgnoreCase))
            {
                HttpContext.Session.SetString("EditAMessageFromErnieOK", "yes");
                return RedirectToPage("/AMessageFromErnie");
            }

            // Execute auth workflow via the shared service
            bool loginSuccessful = await _authService.ProcessLoginAndMigrateAsync(HttpContext, cleanEmail, cleanPassword);
            if (loginSuccessful)
            {
                if (!string.IsNullOrEmpty(ReturnUrl) && Url.IsLocalUrl(ReturnUrl))
                {
                    return Redirect(ReturnUrl);
                }

                string powerUser = HttpContext.Session.GetPowerUserName();
                if (!string.IsNullOrEmpty(powerUser))
                {
                    return RedirectToPage("/CustomerInfo");
                }

                var emailUpper = cleanEmail.ToUpper();
                if (emailUpper == "POTATOKID2004@GMAIL.COM" ||
                    emailUpper == "KDOGROSS06@GMAIL.COM" ||
                    emailUpper == "HECHARLOTTE31@GMAIL.COM")
                {
                    return RedirectToPage("/EnterStock");
                }

                return RedirectToPage("/WholesaleAccepted");
            }

            var customer = await _customerService.GetCustomerByEmailAsync(cleanEmail);

            TempData["ErrorMessage"] = customer != null
                ? "Invalid password. Your password has been emailed to you."
                : "Email address not found.";

            if (customer != null)
            {
                string baseUrl = (_configuration["Appsettings:AppUrl"] ?? "https://millionsofrecords.com").TrimEnd('/');
                string signInUrl = $"{baseUrl}/sign-in";

                var subject = "Millions Of Records Sign-In Password";

                string emailBody = $@"
                    <p>Dear {customer.FullName},</p>
                    <p>Here are the sign-in credentials for your account:</p>
                    <p>
                        <strong>EMAIL:</strong> {customer.LogInEmail}<br/>
                        <strong>PASSWORD:</strong> {customer.Password}
                    </p>
                    <p><em>Note: After you sign in, if you would like to change your email and/or your password then please go to the My Account page.</em></p>
                    <p>Sign in at <a href=""{signInUrl}"">{signInUrl}</a></p>
                    <p>If you don't wish to click the link above, then simply go to <a href=""{baseUrl}"">{baseUrl}</a> and sign in with your password above.</p>
                    <p>Sincerely,<br/>
                    Customer Service</p>";

                var emailFooterResults = await _procedures.spGetEmailFooterAsync();
                if (emailFooterResults.Any())
                {
                    emailBody += emailFooterResults.First().Footer;
                }

                await _emailService.SendEmailAsync(customer.LogInEmail, subject, emailBody);
            }
            return RedirectToPage();
        }
        // AJAX Handler for Contact Us form submission
        public async Task<IActionResult> OnPostContactUsAsync()
        {
            // Honeypot Anti-Spam Check
            if (!string.IsNullOrEmpty(ContactForm.Website))
            {
                return new JsonResult(new { success = true, message = "Thank you. An email has been sent to our customer service department and you will be hearing back from us soon." });
            }

            ModelState.Clear();

            if (!TryValidateModel(ContactForm, nameof(ContactForm)))
            {
                var errors = new List<string>();

                if (ModelState.TryGetValue($"{nameof(ContactForm)}.{nameof(ContactForm.YourName)}", out var nameState) && nameState.Errors.Any())
                {
                    errors.AddRange(nameState.Errors.Select(e => e.ErrorMessage));
                }

                if (ModelState.TryGetValue($"{nameof(ContactForm)}.{nameof(ContactForm.YourEmail)}", out var emailState) && emailState.Errors.Any())
                {
                    errors.AddRange(emailState.Errors.Select(e => e.ErrorMessage));
                }

                if (ModelState.TryGetValue($"{nameof(ContactForm)}.{nameof(ContactForm.YourPhone)}", out var phoneState) && phoneState.Errors.Any())
                {
                    errors.AddRange(phoneState.Errors.Select(e => e.ErrorMessage));
                }

                if (ModelState.TryGetValue($"{nameof(ContactForm)}.{nameof(ContactForm.Message)}", out var msgState) && msgState.Errors.Any())
                {
                    errors.AddRange(msgState.Errors.Select(e => e.ErrorMessage));
                }

                return new JsonResult(new { success = false, errors });
            }

            try
            {
                string userIp = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
                string subject = "CONTACT US FORM - Can Not Sign In At Millions Of Records";

                string cleanName = HtmlEncoder.Default.Encode(ContactForm.YourName.Trim());
                string cleanEmail = HtmlEncoder.Default.Encode(ContactForm.YourEmail.Trim());
                string cleanPhone = string.IsNullOrWhiteSpace(ContactForm.YourPhone) ? "N/A" : HtmlEncoder.Default.Encode(ContactForm.YourPhone.Trim());
                string cleanMessage = HtmlEncoder.Default.Encode(ContactForm.Message.Trim()).Replace("\n", "<br/>");

                string body = $"IP ADDRESS:   {userIp}<br/>" +
                              $"CUSTOMER NAME:   {cleanName}<br/>" +
                              $"CUSTOMER EMAIL:   {cleanEmail}<br/>" +
                              $"CUSTOMER PHONE:   {cleanPhone}<br/><br/>" +
                              $"---MESSAGE---<br/>" +
                              $"{cleanMessage}";

                await _emailService.SendEmailAsync("ernieb12345@gmail.com", subject, body);

                return new JsonResult(new { success = true, message = "Thank you. An email has been sent to our customer service department and you will be hearing back from us soon." });
            }
            catch (Exception ex)
            {
                // 1. Log full exception details to backend console / log files
                _logger.LogError(ex, "Failed to send Contact Us email for {Email}", ContactForm.YourEmail);

                // 2. In Development, expose the actual exception message for immediate debugging
                if (_env.IsDevelopment())
                {
                    return new JsonResult(new { success = false, errors = new[] { $"[DEV ERROR] {ex.Message}" } });
                }

                // 3. In Production, present a clear and actionable message with alternative contact options
                return new JsonResult(new
                {
                    success = false,
                    errors = new[] { "We were unable to send your message right now due to a temporary mail service issue. Please try emailing us directly at ernieb12345@gmail.com or try again later." }
                });
            }
        }
    }
    public class ContactUsInputModel
    {
        [Required(ErrorMessage = "Please enter \"Your Name\" before submitting.")]
            [StringLength(100, MinimumLength = 2, ErrorMessage = "Your Name must be at least 2 characters.")]
        [RegularExpression(@"^[^\r\n]+$", ErrorMessage = "Your Name cannot contain line breaks.")]
        public string YourName { get; set; } = string.Empty;

        [Required(ErrorMessage = "Please enter \"Your Email Address\" before submitting.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        [RegularExpression(@"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", ErrorMessage = "Please enter a valid email address format.")]
        [StringLength(100, ErrorMessage = "Your Email cannot exceed 100 characters.")]
        public string YourEmail { get; set; } = string.Empty;

        [StringLength(30, ErrorMessage = "Your Phone number cannot exceed 30 characters.")]
        [RegularExpression(@"^[0-9\-\+\(\)\s\.]*$", ErrorMessage = "Please enter a valid phone number format.")]
        public string? YourPhone { get; set; }

        [Required(ErrorMessage = "Please enter your \"Message\" before submitting.")]
        [StringLength(1000, MinimumLength = 10, ErrorMessage = "Your Message must be at least 10 characters long.")]
        public string Message { get; set; } = string.Empty;

        // Honeypot Field (Hidden in UI via CSS). Spam bots will fill this in.
        public string? Website { get; set; }
    }
}