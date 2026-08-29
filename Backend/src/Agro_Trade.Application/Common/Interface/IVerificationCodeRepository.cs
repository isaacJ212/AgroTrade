namespace Agro_Trade.Application.Common.Interface
{
    public interface IVerificationCodeRepository
    {
        Task SaveCodeAsync(int userId, string code, TimeSpan validity, CancellationToken ct = default);
        Task<bool> ValidateAndRemoveAsync(int userId, string code, CancellationToken ct = default);
    }
}
