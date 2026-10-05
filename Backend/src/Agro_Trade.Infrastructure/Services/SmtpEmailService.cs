using MailKit.Net.Smtp;
using MailKit.Security;
using Agro_Trade.Infrastructure.DependencyInjection;
using Microsoft.Extensions.Configuration;
using MimeKit;
using Agro_Trade.Application.Common.Interface;
using System.Net;

namespace Agro_Trade.Infrastructure.Services
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
            var smtpLogin = _configuration["Brevo:SmtpLogin"];
            var smtpPassword = _configuration["Brevo:SmtpPassword"];
            var emailSender = _configuration["Brevo:EmailSender"];
            var fromName = _configuration["Brevo:FromName"] ?? "AgroTrade";
            var smtpHost = _configuration["Brevo:SmtpHost"] ?? "smtp-relay.brevo.com";
            var smtpPortString = _configuration["Brevo:SmtpPort"] ?? "587";
            
            if (!int.TryParse(smtpPortString, out int smtpPort)) 
            {
                smtpPort = 587;
            }

            var emailContent = $@"
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 12px;'>
                    <h2 style='color: #0f172a; margin-bottom: 8px;'>Código de verificación</h2>
                    <p style='color: #475569; font-size: 16px;'>Hola,</p>
                    <p style='color: #475569; font-size: 16px;'>Tu código de verificación para Agro Trade es:</p>
                    <div style='background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; text-align: center; margin: 20px 0;'>
                        <strong style='font-size: 28px; letter-spacing: 4px;'>{code}</strong>
                    </div>
                    <p style='color: #475569; font-size: 16px;'>Ingresa este código para completar tu registro.</p>
                    <p style='color: #94a3b8; font-size: 14px; margin-top: 24px;'>Este código expira en 10 minutos.</p>
                </div>";

            if (string.IsNullOrWhiteSpace(smtpLogin) || string.IsNullOrWhiteSpace(smtpPassword))
            {
                throw new InvalidOperationException("Las credenciales de Brevo no están configuradas en appsettings.json");
            }

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(fromName, emailSender));
            message.To.Add(new MailboxAddress("", toEmail));
            message.Subject = "Código de Verificación 2FA - AgroTrade";
            
            var bodyBuilder = new BodyBuilder { HtmlBody = emailContent };
            message.Body = bodyBuilder.ToMessageBody();

            try
            {
                using var client = new SmtpClient();
                await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.StartTls, ct);
                await client.AuthenticateAsync(smtpLogin, smtpPassword, ct);
                await client.SendAsync(message, ct);
                await client.DisconnectAsync(true, ct);

                Console.WriteLine($"\n[BREVO SUCCESS] ¡Correo 2FA enviado con éxito a {toEmail}!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n[BREVO CRITICAL] Ocurrió un error al enviar el correo: {ex.Message}");
                throw;
            }
        }
    }
}
