namespace Agro_Trade.Application.Common.Interface
{
    public interface IEmailService
    {
        Task SendVerificationCodeAsync(string toEmail, string code, CancellationToken ct = default);
    }
}
