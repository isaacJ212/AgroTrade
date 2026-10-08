using System.Security.Cryptography;
using System.Text;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Caching.Memory;
using Org.BouncyCastle.Crypto.Generators;

namespace Agro_Trade.Application.Features.Usuarios.Commands;

public sealed record SendPasswordRecoveryCodeCommand(string Email) : IRequest<Unit>;

public sealed class SendPasswordRecoveryCodeHandler(
    IMemoryCache cache,
    IUnitofWork unitOfWork,
    IEmailService emailService) : IRequestHandler<SendPasswordRecoveryCodeCommand, Unit>
{
    public async Task<Unit> Handle(SendPasswordRecoveryCodeCommand request, CancellationToken cancellationToken)
    {
        var email = request.Email.Trim();
        var user = await unitOfWork.Users.GetByEmailAsync(email, cancellationToken);

        // Respuesta indistinguible para correos inexistentes; evita enumerar cuentas.
        if (user is null || string.IsNullOrWhiteSpace(user.Email))
            return Unit.Value;

        var code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        var expiresAt = DateTimeOffset.UtcNow.AddMinutes(10);
        cache.Set(
            $"PWD_RECOVERY_CODE_{user.IdUsuario}",
            new PasswordRecoveryCode(code, 0, expiresAt),
            new MemoryCacheEntryOptions { AbsoluteExpiration = expiresAt });
        cache.Remove($"PWD_RECOVERY_ALLOWED_{user.IdUsuario}");

        await emailService.SendVerificationCodeAsync(
            user.Email,
            code,
            "Seguridad AgroTrade: Código de Validación",
            "Confirmación de Identidad",
            "Has solicitado restablecer tu contraseña. Tu código de seguridad es:",
            cancellationToken);

        return Unit.Value;
    }
}

public sealed record VerifyPasswordRecoveryCodeCommand(string Email, string Code) : IRequest<Unit>;

public sealed class VerifyPasswordRecoveryCodeHandler(
    IMemoryCache cache,
    IUnitofWork unitOfWork) : IRequestHandler<VerifyPasswordRecoveryCodeCommand, Unit>
{
    private const int MaxAttempts = 5;
    private static readonly object CacheLock = new();

    public async Task<Unit> Handle(VerifyPasswordRecoveryCodeCommand request, CancellationToken cancellationToken)
    {
        var user = await unitOfWork.Users.GetByEmailAsync(request.Email.Trim(), cancellationToken);
        var codeKey = user is null ? null : $"PWD_RECOVERY_CODE_{user.IdUsuario}";

        lock (CacheLock)
        {
            if (codeKey is null
                || !cache.TryGetValue(codeKey, out PasswordRecoveryCode? stored)
                || stored is null
                || !IsValidCode(request.Code)
                || !FixedTimeEquals(stored.Code, request.Code))
            {
                if (codeKey is not null && cache.TryGetValue(codeKey, out PasswordRecoveryCode? attemptState)
                    && attemptState is not null)
                {
                    var attempts = attemptState.Attempts + 1;
                    if (attempts >= MaxAttempts)
                        cache.Remove(codeKey);
                    else
                        cache.Set(codeKey, attemptState with { Attempts = attempts }, new MemoryCacheEntryOptions
                        {
                            AbsoluteExpiration = attemptState.ExpiresAt
                        });
                }

                throw new ApiExceptions(400, "El código de verificación no es válido o expiró.");
            }

            cache.Remove(codeKey);
            cache.Set($"PWD_RECOVERY_ALLOWED_{user!.IdUsuario}", true, TimeSpan.FromMinutes(5));
        }

        return Unit.Value;
    }

    private static bool IsValidCode(string? code) =>
        code is { Length: 6 } && code.All(char.IsAsciiDigit);

    private static bool FixedTimeEquals(string expected, string supplied) =>
        CryptographicOperations.FixedTimeEquals(
            Encoding.UTF8.GetBytes(expected),
            Encoding.UTF8.GetBytes(supplied));
}

public sealed record ResetPasswordByRecoveryCodeCommand(string Email, string NewPassword) : IRequest<Unit>;

public sealed class ResetPasswordByRecoveryCodeHandler(
    IMemoryCache cache,
    IUnitofWork unitOfWork) : IRequestHandler<ResetPasswordByRecoveryCodeCommand, Unit>
{
    private static readonly object CacheLock = new();

    public async Task<Unit> Handle(ResetPasswordByRecoveryCodeCommand request, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Length < 8)
            throw new ApiExceptions(400, "La contraseña debe tener al menos 8 caracteres.");

        var userLookup = await unitOfWork.Users.GetByEmailAsync(request.Email.Trim(), cancellationToken);
        if (userLookup is null)
            throw new ApiExceptions(403, "No se pudo autorizar el restablecimiento de contraseña.");

        // GetByEmailAsync is no-tracking; reload the account as a tracked entity before updating it.
        var user = await unitOfWork.Users.GetToUpdateAsync(userLookup.IdUsuario, cancellationToken);
        if (user is null)
            throw new ApiExceptions(403, "No se pudo autorizar el restablecimiento de contraseña.");

        var witnessKey = $"PWD_RECOVERY_ALLOWED_{user.IdUsuario}";
        lock (CacheLock)
        {
            if (!cache.TryGetValue(witnessKey, out bool isAllowed) || !isAllowed)
                throw new ApiExceptions(403, "Debes verificar el código antes de restablecer la contraseña.");

            // Se consume antes de modificar datos para que dos peticiones concurrentes no reutilicen el testigo.
            cache.Remove(witnessKey);
        }

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
        await unitOfWork.SaveChangesAsync(cancellationToken);
        return Unit.Value;
    }
}

internal sealed record PasswordRecoveryCode(string Code, int Attempts, DateTimeOffset ExpiresAt);
