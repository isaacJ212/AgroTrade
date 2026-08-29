using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Infrastructure.Repository
{
    public class InMemoryVerificationCodeRepository : IVerificationCodeRepository
    {
        private static readonly object _lock = new();
        private static readonly Dictionary<int, (string Code, DateTime ExpiresAt)> _codes = new();

        public Task SaveCodeAsync(int userId, string code, TimeSpan validity, CancellationToken ct = default)
        {
            lock (_lock)
            {
                _codes[userId] = (code, DateTime.UtcNow.Add(validity));
            }

            return Task.CompletedTask;
        }

        public Task<bool> ValidateAndRemoveAsync(int userId, string code, CancellationToken ct = default)
        {
            lock (_lock)
            {
                if (_codes.TryGetValue(userId, out var stored))
                {
                    if (DateTime.UtcNow <= stored.ExpiresAt && string.Equals(stored.Code, code, StringComparison.Ordinal))
                    {
                        _codes.Remove(userId);
                        return Task.FromResult(true);
                    }

                    _codes.Remove(userId);
                }
            }

            return Task.FromResult(false);
        }
    }
}
