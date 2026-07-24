using Meseta_Verde.Application.Common.Interface;
using Microsoft.Extensions.Configuration;
using System.Net;
using System.Net.Mail;

namespace Meseta_Verde.Infrastructure.Services
{
    public class SmtpEmailService : IEmailService
    {
        private readonly IConfiguration _configuration;

        public SmtpEmailService(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public async Task SendVerificationCodeAsync(string toEmail, string code, CancellationToken ct = default)
        {
            var host = _configuration["Smtp:Host"];
            var portValue = _configuration["Smtp:Port"];
            var username = _configuration["Smtp:Username"];
            var password = _configuration["Smtp:Password"];
            var fromEmail = _configuration["Smtp:FromEmail"];
            var fromName = _configuration["Smtp:FromName"] ?? "Meseta Verde";

            if (string.IsNullOrWhiteSpace(host) || string.IsNullOrWhiteSpace(portValue) || string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(fromEmail))
            {
                throw new InvalidOperationException("La configuración SMTP no está completa. Define Smtp:Host, Smtp:Port, Smtp:Username, Smtp:Password y Smtp:FromEmail.");
            }

            if (!int.TryParse(portValue, out var port))
            {
                throw new InvalidOperationException("El puerto SMTP debe ser numérico.");
            }

            var message = new MailMessage
            {
                From = new MailAddress(fromEmail, fromName),
                Subject = "Código de verificación Meseta Verde",
                Body = $"Tu código de verificación es: {code}\n\nIngresa este código para continuar con tu registro.",
                IsBodyHtml = false
            };

            message.To.Add(toEmail);

            using var client = new SmtpClient(host, port)
            {
                Credentials = new NetworkCredential(username, password),
                EnableSsl = true
            };

            await client.SendMailAsync(message, ct);
        }
    }
}
