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

        public async Task SendVerificationCodeAsync(string toEmail, string code, string subject, string title, string description, CancellationToken ct = default)
        {
            
            var smtpLogin = _configuration["GmailSmtp:SmtpLogin"];
            var smtpPassword = _configuration["GmailSmtp:SmtpPassword"];
            var emailSender = _configuration["GmailSmtp:EmailSender"];
            var fromName = _configuration["GmailSmtp:FromName"] ?? "AgroTrade";
            var smtpHost = _configuration["GmailSmtp:SmtpHost"] ?? "smtp.gmail.com";
            var smtpPortString = _configuration["GmailSmtp:SmtpPort"] ?? "587";
            
            if (!int.TryParse(smtpPortString, out int smtpPort)) 
            {
                smtpPort = 587;
            }

            var emailContent = $@"
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 12px;'>
                    <h2 style='color: #0f172a; margin-bottom: 8px;'>{WebUtility.HtmlEncode(title)}</h2>
                    <p style='color: #475569; font-size: 16px;'>Hola,</p>
                    <p style='color: #475569; font-size: 16px;'>{WebUtility.HtmlEncode(description)}</p>
                    <div style='background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; text-align: center; margin: 20px 0;'>
                        <strong style='font-size: 28px; letter-spacing: 4px;'>{WebUtility.HtmlEncode(code)}</strong>
                    </div>
                    <p style='color: #475569; font-size: 16px;'>Ingresa este código en el formulario para continuar.</p>
                    <p style='color: #94a3b8; font-size: 14px; margin-top: 24px;'>Este código expira en 10 minutos.</p>
                </div>";

            if (string.IsNullOrWhiteSpace(smtpLogin) || string.IsNullOrWhiteSpace(smtpPassword))
            {
                throw new InvalidOperationException("Las credenciales de Gmail SMTP no están configuradas en appsettings.json");
            }

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(fromName, emailSender));
            message.To.Add(new MailboxAddress("", toEmail));
            message.Subject = subject;
            
            var bodyBuilder = new BodyBuilder { HtmlBody = emailContent };
            message.Body = bodyBuilder.ToMessageBody();

            try
            {
                using var client = new SmtpClient();
                client.ServerCertificateValidationCallback = (s, c, h, e) => true; 
                // Gmail funciona perfectamente con el puerto 587 y StartTls
                await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.StartTls, ct);
                await client.AuthenticateAsync(smtpLogin, smtpPassword, ct);
                await client.SendAsync(message, ct);
                await client.DisconnectAsync(true, ct);

                Console.WriteLine($"\n[GMAIL SUCCESS] ¡Correo 2FA enviado con éxito a {toEmail}!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n[GMAIL CRITICAL] Ocurrió un error al enviar el correo: {ex.Message}");
                throw;
            }
        }

        public async Task SendVerificationResultAsync(string toEmail, string nombre, bool aprobado, string comentarioModerador, CancellationToken ct = default)
        {
            var smtpLogin = _configuration["GmailSmtp:SmtpLogin"];
            var smtpPassword = _configuration["GmailSmtp:SmtpPassword"];
            var emailSender = _configuration["GmailSmtp:EmailSender"];
            var fromName = _configuration["GmailSmtp:FromName"] ?? "AgroTrade";
            var smtpHost = _configuration["GmailSmtp:SmtpHost"] ?? "smtp.gmail.com";
            var smtpPortString = _configuration["GmailSmtp:SmtpPort"] ?? "587";
            
            if (!int.TryParse(smtpPortString, out int smtpPort)) 
            {
                smtpPort = 587;
            }

            string subject, title, messageBody;
            string color = aprobado ? "#22c55e" : "#ef4444";
            string statusText = aprobado ? "APROBADA" : "RECHAZADA";
            string bgColor = aprobado ? "#f0fdf4" : "#fef2f2";
            string borderColor = aprobado ? "#bbf7d0" : "#fecaca";

            if (aprobado)
            {
                subject = "✅ Tu solicitud de repartidor ha sido APROBADA - AgroTrade";
                title = "¡Felicidades! Tu solicitud fue aprobada";
                messageBody = $@"
                    <p style='color: #475569; font-size: 16px;'>Hola <strong>{WebUtility.HtmlEncode(nombre)}</strong>,</p>
                    <p style='color: #475569; font-size: 16px;'>Nos complace informarte que tu solicitud para unirte al equipo de repartidores de <strong>AgroTrade</strong> ha sido <strong style='color: {color};'>{statusText}</strong>.</p>
                    <p style='color: #475569; font-size: 16px;'>A partir de ahora tienes acceso completo a la plataforma para recibir y gestionar entregas.</p>";
            }
            else
            {
                subject = "❌ Tu solicitud de repartidor ha sido RECHAZADA - AgroTrade";
                title = "Tu solicitud fue rechazada";
                messageBody = $@"
                    <p style='color: #475569; font-size: 16px;'>Hola <strong>{WebUtility.HtmlEncode(nombre)}</strong>,</p>
                    <p style='color: #475569; font-size: 16px;'>Lamentamos informarte que tu solicitud para unirte al equipo de repartidores de <strong>AgroTrade</strong> ha sido <strong style='color: {color};'>{statusText}</strong>.</p>
                    <p style='color: #475569; font-size: 16px;'>Puedes corregir la información y volver a enviar tu solicitud cuando lo desees.</p>";
            }

            if (!string.IsNullOrWhiteSpace(comentarioModerador))
            {
                messageBody += $@"
                    <div style='background: {bgColor}; border: 1px solid {borderColor}; border-radius: 8px; padding: 16px; margin: 20px 0;'>
                        <p style='color: #374151; margin: 0 0 8px 0;'><strong>Comentario del moderador:</strong></p>
                        <p style='color: #475569; font-size: 15px; margin: 0;'>{WebUtility.HtmlEncode(comentarioModerador)}</p>
                    </div>";
            }

            messageBody += $@"
                    <p style='color: #475569; font-size: 16px; margin-top: 24px;'>Si tienes dudas, contáctanos respondiendo a este correo.</p>
                    <hr style='border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;'>
                    <p style='color: #94a3b8; font-size: 13px;'>Equipo AgroTrade — Cultivando Conexiones</p>";

            var emailContent = $@"
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 12px;'>
                    <h2 style='color: {color}; margin-bottom: 8px;'>{WebUtility.HtmlEncode(title)}</h2>
                    {messageBody}
                </div>";

            if (string.IsNullOrWhiteSpace(smtpLogin) || string.IsNullOrWhiteSpace(smtpPassword))
            {
                throw new InvalidOperationException("Las credenciales de Gmail SMTP no están configuradas en appsettings.json");
            }

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(fromName, emailSender));
            message.To.Add(new MailboxAddress("", toEmail));
            message.Subject = subject;
            
            var bodyBuilder = new BodyBuilder { HtmlBody = emailContent };
            message.Body = bodyBuilder.ToMessageBody();

            try
            {
                using var client = new SmtpClient();
                client.ServerCertificateValidationCallback = (s, c, h, e) => true; 
                await client.ConnectAsync(smtpHost, smtpPort, SecureSocketOptions.StartTls, ct);
                await client.AuthenticateAsync(smtpLogin, smtpPassword, ct);
                await client.SendAsync(message, ct);
                await client.DisconnectAsync(true, ct);

                Console.WriteLine($"\n[GMAIL SUCCESS] ¡Correo de verificación repartidor ({statusText}) enviado a {toEmail}!");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n[GMAIL CRITICAL] Error al enviar correo de verificación repartidor: {ex.Message}");
                throw;
            }
        }
    }
}
