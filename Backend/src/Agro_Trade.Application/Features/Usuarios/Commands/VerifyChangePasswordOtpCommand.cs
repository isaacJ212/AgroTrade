using System.Security.Cryptography;
using System.Text;
using Agro_Trade.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Application.Features.Usuarios.Commands;

public sealed record VerifyChangePasswordOtpCommand(int UserId, string Code) : IRequest<Unit>;

public sealed class VerifyChangePasswordOtpHandler(IMemoryCache cache)
    : IRequestHandler<VerifyChangePasswordOtpCommand, Unit>
{
    public Task<Unit> Handle(VerifyChangePasswordOtpCommand request, CancellationToken cancellationToken)
    {
        var codeKey = $"PWD_CODE_{request.UserId}";
        if (!cache.TryGetValue(codeKey, out string? expectedCode)
            || string.IsNullOrWhiteSpace(request.Code)
            || request.Code.Length != 6
            || !CryptographicOperations.FixedTimeEquals(
                Encoding.UTF8.GetBytes(expectedCode!),
                Encoding.UTF8.GetBytes(request.Code)))
        {
            throw new ApiExceptions(400, "El código de verificación no es válido o expiró.");
        }

        cache.Remove(codeKey);
        cache.Set($"PWD_ALLOWED_{request.UserId}", true, TimeSpan.FromMinutes(5));
        return Task.FromResult(Unit.Value);
    }
}
