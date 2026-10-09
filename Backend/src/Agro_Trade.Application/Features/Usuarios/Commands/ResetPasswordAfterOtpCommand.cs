using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Application.Features.Usuarios.Commands;

public sealed record ResetPasswordAfterOtpCommand(int UserId, string NewPassword) : IRequest<Unit>;

public sealed class ResetPasswordAfterOtpHandler(
    IMemoryCache cache,
    IUnitofWork unitOfWork) : IRequestHandler<ResetPasswordAfterOtpCommand, Unit>
{
    public async Task<Unit> Handle(ResetPasswordAfterOtpCommand request, CancellationToken cancellationToken)
    {
        var allowedKey = $"PWD_ALLOWED_{request.UserId}";
        if (!cache.TryGetValue(allowedKey, out bool isAllowed) || !isAllowed)
            throw new ApiExceptions(403, "Debes verificar el código antes de cambiar la contraseña.");

        if (string.IsNullOrWhiteSpace(request.NewPassword) || request.NewPassword.Length < 8)
            throw new ApiExceptions(400, "La contraseña debe tener al menos 8 caracteres.");

        var user = await unitOfWork.Users.GetToUpdateAsync(request.UserId, cancellationToken);
        if (user is null)
            throw new ApiExceptions(404, "No se encontró el usuario.");

        user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.NewPassword);
        await unitOfWork.SaveChangesAsync(cancellationToken);
        cache.Remove(allowedKey);

        return Unit.Value;
    }
}
