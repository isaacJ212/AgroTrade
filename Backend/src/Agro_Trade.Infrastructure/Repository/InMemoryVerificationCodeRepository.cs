using Agro_Trade.Application.Common.Interface;
using System.Security.Cryptography;
using System.Text;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Infrastructure.Repository
{
    public class InMemoryVerificationCodeRepository : IVerificationCodeRepository
    {
        private const int MaxAttempts = 5;
        private static readonly object CacheLock = new();
        private readonly IMemoryCache _cache;

        public InMemoryVerificationCodeRepository(IMemoryCache cache)
        {
            _cache = cache;
        }

        public Task SaveCodeAsync(int userId, string code, TimeSpan validity, CancellationToken ct = default)
        {
            var expiresAt = DateTimeOffset.UtcNow.Add(validity);
            var entry = new VerificationCodeEntry(code, 0, expiresAt);
            lock (CacheLock)
            {
                _cache.Set(GetCacheKey(userId), entry, new MemoryCacheEntryOptions
                {
                    AbsoluteExpiration = expiresAt
                });
            }

            return Task.CompletedTask;
        }

        public Task<bool> ValidateAndRemoveAsync(int userId, string code, CancellationToken ct = default)
        {
            lock (CacheLock)
            {
                var cacheKey = GetCacheKey(userId);
                if (!_cache.TryGetValue(cacheKey, out VerificationCodeEntry? stored) || stored is null)
                    return Task.FromResult(false);

                if (IsValidCodeFormat(code) && FixedTimeEquals(stored.Code, code))
                {
                    _cache.Remove(cacheKey);
                    return Task.FromResult(true);
                }

                var attempts = stored.Attempts + 1;
                if (attempts >= MaxAttempts)
                    _cache.Remove(cacheKey);
                else
                    _cache.Set(cacheKey, stored with { Attempts = attempts }, new MemoryCacheEntryOptions
                    {
                        AbsoluteExpiration = stored.ExpiresAt
                    });
            }

            return Task.FromResult(false);
        }

        private static string GetCacheKey(int userId) => $"VERIFY_CODE_{userId}";

        private static bool IsValidCodeFormat(string? code) =>
            code is { Length: 6 } && code.All(char.IsAsciiDigit);

        private static bool FixedTimeEquals(string expected, string supplied)
        {
            return CryptographicOperations.FixedTimeEquals(
                Encoding.UTF8.GetBytes(expected),
                Encoding.UTF8.GetBytes(supplied));
        }

        private sealed record VerificationCodeEntry(string Code, int Attempts, DateTimeOffset ExpiresAt);
    }
}
