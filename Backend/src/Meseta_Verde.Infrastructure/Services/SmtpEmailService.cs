using Mailjet.Client;
using Mailjet.Client.TransactionalEmails;
using MailKit;
using MailKit.Net.Smtp;
using MailKit.Security;
using MailKit.Security;
using Meseta_Verde.Infrastructure.DependencyInjection;
using Microsoft.Extensions.Configuration;
using MimeKit;
using Meseta_Verde.Application.Common.Interface;
using System.Net;

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

            var apiKey = _configuration["Mailjet:ApiKey"];
            var secretKey = _configuration["Mailjet:SecretKey"];
            var emailSender = _configuration["Mailjet:EmailSender"];
            var fromName = _configuration["Mailjet:FromName"] ?? "AgroTrade";


            var emailContent = $@"
                <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px; border: 1px solid #e5e7eb; border-radius: 12px;'>
                    <h2 style='color: #0f172a; margin-bottom: 8px;'>Código de verificación</h2>
                    <p style='color: #475569; font-size: 16px;'>Hola,</p>
                    <p style='color: #475569; font-size: 16px;'>Tu código de verificación para Meseta Verde es:</p>
                    <div style='background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 16px; text-align: center; margin: 20px 0;'>
                        <strong style='font-size: 28px; letter-spacing: 4px;'>{code}</strong>
                    </div>
                    <p style='color: #475569; font-size: 16px;'>Ingresa este código para completar tu registro.</p>
                    <p style='color: #94a3b8; font-size: 14px; margin-top: 24px;'>Este código expira en 10 minutos.</p>
                </div>";


            if (string.IsNullOrWhiteSpace(apiKey) || string.IsNullOrWhiteSpace(secretKey))
            {
                throw new InvalidOperationException("Las credenciales de Mailjet no están configuradas en appsettings.json");
            }

            // 2. Inicialización del cliente HTTP de Mailjet
            var client = new MailjetClient(apiKey, secretKey);

            var email = new TransactionalEmailBuilder()
                .WithFrom(new SendContact(emailSender, fromName))
                .WithSubject("Código de Verificación 2FA - AgroTrade")
                .WithHtmlPart(emailContent)
                .WithTo(new SendContact(toEmail))
                .Build();

            try
            {
                // 3. Envío directo usando la API asíncrona dedicada de transacciones
                var response = await client.SendTransactionalEmailAsync(email);

                // Mailjet devuelve un arreglo con el estado de cada correo enviado
                if (response.Messages != null && response.Messages.Length > 0 && response.Messages[0].Status == "success")
                {
                    Console.WriteLine($"\n[MAILJET SUCCESS] ¡Correo 2FA enviado con éxito a {toEmail}!");
                }
                else
                {
                    Console.WriteLine($"\n[MAILJET ERROR] El correo no se pudo procesar correctamente.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"\n[MAILJET CRITICAL] Ocurrió un error en el cliente: {ex.Message}");
                throw;
            }



        }
    }
}
