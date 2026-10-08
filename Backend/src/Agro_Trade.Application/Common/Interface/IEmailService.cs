namespace Agro_Trade.Application.Common.Interface
{
    public interface IEmailService
    {
        Task SendVerificationCodeAsync(string toEmail, string code, string subject, string title, string description, CancellationToken ct = default);
        
        /// <summary>
        /// Envía email de resultado de verificación de repartidor (aprobado/rechazado)
        /// </summary>
        Task SendVerificationResultAsync(string toEmail, string nombre, bool aprobado, string comentarioModerador, CancellationToken ct = default);
    }
}
