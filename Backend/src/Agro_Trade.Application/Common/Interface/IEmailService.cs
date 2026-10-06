namespace Agro_Trade.Application.Common.Interface
{
    public interface IEmailService
    {
        Task SendVerificationCodeAsync(string toEmail, string code, string subject, string title, string description, CancellationToken ct = default);
    }
}
