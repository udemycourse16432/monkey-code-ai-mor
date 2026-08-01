using MailKit.Net.Smtp;
using MimeKit;
using Microsoft.Extensions.Options;

namespace MillionsOfRecordsApp.Services;

public class EmailService : IEmailService
{
    private readonly EmailSettings _settings;

    public EmailService(IOptions<EmailSettings> settings)
    {
        _settings = settings.Value;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string htmlMessage)
    {
        var email = new MimeMessage();
        email.From.Add(new MailboxAddress(_settings.SenderName, _settings.SenderEmail));
        email.To.Add(MailboxAddress.Parse(toEmail));
        email.Subject = subject;
        email.Body = new TextPart(MimeKit.Text.TextFormat.Html) { Text = htmlMessage };

        /* TODO: Get email settings working
        using var smtp = new SmtpClient();
        await smtp.ConnectAsync(_settings.SmtpServer, _settings.Port, MailKit.Security.SecureSocketOptions.None);
        // await smtp.AuthenticateAsync("user", "pass"); // Uncomment for production
        await smtp.SendAsync(email);
        await smtp.DisconnectAsync(true);
        */
    }
}