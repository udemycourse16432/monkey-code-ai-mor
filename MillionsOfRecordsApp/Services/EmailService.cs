using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.Extensions.Options;
using MimeKit;

namespace MillionsOfRecordsApp.Services;

public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;
    private readonly ILogger<EmailService> _logger;

    public EmailService(IOptions<EmailSettings> settings, ILogger<EmailService> logger)
    {
        _settings = settings.Value;
        _logger = logger;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string htmlMessage)
    {
        var email = new MimeMessage();
        email.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
        email.To.Add(MailboxAddress.Parse(toEmail));
        email.Subject = subject;
        email.Body = new TextPart(MimeKit.Text.TextFormat.Html) { Text = htmlMessage };

        using var smtp = new SmtpClient();
        try
        {
            await smtp.ConnectAsync(_settings.SmtpServer, _settings.Port, SecureSocketOptions.StartTlsWhenAvailable);

            //if (!string.IsNullOrEmpty(_settings.Username))
            //{
            //    await smtp.AuthenticateAsync(_settings.Username, _settings.Password);
            //}

            // SendAsync returns the SMTP server's acknowledgement string
            string smtpResponse = await smtp.SendAsync(email);
            _logger.LogInformation("SMTP Response for {ToEmail}: {Response}", toEmail, smtpResponse);

            await smtp.DisconnectAsync(true);
        }
        catch (SmtpCommandException ex)
        {
            // Catches SMTP protocol errors (e.g., 550 Invalid recipient, 554 Transaction failed)
            _logger.LogError(ex, "SMTP Command Error [{StatusCode}] while sending email to {ToEmail}", ex.StatusCode, toEmail);
            throw;
        }
        catch (SmtpProtocolException ex)
        {
            // Catches protocol sync/connection failures
            _logger.LogError(ex, "SMTP Protocol Exception while sending email to {ToEmail}", toEmail);
            throw;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "General failure sending email to {ToEmail}", toEmail);
            throw;
        }
    }
}