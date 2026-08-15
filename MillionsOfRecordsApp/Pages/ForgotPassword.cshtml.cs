using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MillionsOfRecordsApp.Data;
using MillionsOfRecordsApp.Services;
using System.ComponentModel.DataAnnotations;

namespace MillionsOfRecordsApp.Pages
{
    public class ForgotPasswordModel : PageModel
    {
        private readonly IReggaeDbContextProcedures _procedures;
        private readonly IEmailService _emailService;
        private readonly IConfiguration _configuration;
        private readonly ILogger<ForgotPasswordModel> _logger;

        public ForgotPasswordModel(
            IReggaeDbContextProcedures procedures,
            IEmailService emailService,
            IConfiguration configuration,
            ILogger<ForgotPasswordModel> logger)
        {
            _procedures = procedures;
            _emailService = emailService;
            _configuration = configuration;
            _logger = logger;
        }

        [BindProperty]
        [Required(ErrorMessage = "Please enter your email address.")]
        [EmailAddress(ErrorMessage = "Please enter a valid email address.")]
        public string Email { get; set; } = string.Empty;

        [BindProperty(SupportsGet = true)]
        public int? CSC { get; set; }

        public bool IsSent { get; set; } = false;
        public bool AccountNotFound { get; set; } = false;
        public string ErrorMessage { get; set; } = string.Empty;

        public async Task<IActionResult> OnGetAsync()
        {
            // Restore state from TempData following a POST redirect (PRG Pattern)
            if (TempData.TryGetValue("IsSent", out var isSent) && isSent is bool sentVal)
            {
                IsSent = sentVal;
            }

            if (TempData.TryGetValue("AccountNotFound", out var accountNotFound) && accountNotFound is bool notFoundVal)
            {
                AccountNotFound = notFoundVal;
            }

            if (TempData.TryGetValue("SubmittedEmail", out var submittedEmail))
            {
                Email = submittedEmail?.ToString() ?? string.Empty;
            }

            if (TempData.TryGetValue("ErrorMessage", out var errorMessage))
            {
                ErrorMessage = errorMessage?.ToString() ?? string.Empty;
            }

            // Support direct legacy links passing Customer Server Counter (?CSC=123)
            if (CSC.HasValue && CSC.Value > 0 && !IsSent && !AccountNotFound)
            {
                await ProcessForgotPasswordAsync(logInEmail: null, serverCounter: CSC.Value);
            }

            return Page();
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            await ProcessForgotPasswordAsync(logInEmail: Email.Trim(), serverCounter: null);

            // Store state in TempData and redirect (GET) to prevent form resubmission on page refresh
            TempData["IsSent"] = IsSent;
            TempData["AccountNotFound"] = AccountNotFound;
            TempData["SubmittedEmail"] = Email;
            TempData["ErrorMessage"] = ErrorMessage;

            return RedirectToPage();
        }

        private async Task ProcessForgotPasswordAsync(string? logInEmail, int? serverCounter)
        {
            try
            {
                string customerFullName = string.Empty;
                string customerEmail = string.Empty;
                string customerLogInEmail = string.Empty;
                string customerPassword = string.Empty;
                bool recordFound = false;

                if (serverCounter.HasValue && serverCounter.Value > 0)
                {
                    var results = await _procedures.spGetCustomerDetailsByServerCounterAsync(counter: serverCounter.Value);
                    var customer = results?.FirstOrDefault();
                    if (customer != null)
                    {
                        recordFound = true;
                        customerFullName = customer.FullName ?? string.Empty;
                        customerEmail = customer.Email ?? string.Empty;
                        customerLogInEmail = customer.LogInEmail ?? string.Empty;
                        customerPassword = customer.Password ?? string.Empty;
                    }
                }
                else if (!string.IsNullOrWhiteSpace(logInEmail))
                {
                    var results = await _procedures.spForgotPasswordAsync(logInEmail: logInEmail);
                    var customer = results?.FirstOrDefault();
                    if (customer != null)
                    {
                        recordFound = true;
                        customerFullName = customer.Fullname ?? string.Empty;
                        customerEmail = customer.Email ?? string.Empty;
                        customerLogInEmail = customer.LogInEmail ?? string.Empty;
                        customerPassword = customer.Password ?? string.Empty;
                    }
                }

                if (!recordFound)
                {
                    AccountNotFound = true;
                    return;
                }

                string recipientEmail = !string.IsNullOrWhiteSpace(customerEmail) ? customerEmail : customerLogInEmail;
                if (string.IsNullOrWhiteSpace(recipientEmail))
                {
                    recipientEmail = logInEmail ?? string.Empty;
                }

                Email = recipientEmail;

                // Dynamically resolve base URL from Appsettings
                string baseUrl = (_configuration["Appsettings:AppUrl"] ?? "https://millionsofrecords.com").TrimEnd('/');
                string signInUrl = $"{baseUrl}/sign-in";

                // Construct email body using dynamic settings
                string emailBody = $@"
                    <p>Dear {customerFullName},</p>
                    <p>Here are the sign-in credentials for your account:</p>
                    <p>
                        <strong>EMAIL:</strong> {customerLogInEmail}<br/>
                        <strong>PASSWORD:</strong> {customerPassword}
                    </p>
                    <p><em>Note: After you sign in, if you would like to change your email and/or your password then please go to the My Account page.</em></p>
                    <p>Sign in at <a href=""{signInUrl}"">{signInUrl}</a></p>
                    <p>If you don't wish to click the link above, then simply browse to the home page <a href=""{baseUrl}"">{baseUrl}</a> and click the SIGN IN tab.</p>
                    <p>We look forward to serving you.</p>
                    <p>Sincerely,<br/>
                    <strong>Millions of Records</strong><br/>
                    Customer Service</p>";

                await _emailService.SendEmailAsync(
                    toEmail: recipientEmail,
                    subject: "MillionsOfRecords Password",
                    htmlMessage: emailBody
                );

                IsSent = true;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error processing forgot password request for Email: {Email}, CSC: {CSC}", logInEmail, serverCounter);
                ErrorMessage = "An unexpected error occurred while processing your request. Please try again or contact customer support.";
            }
        }
    }
}