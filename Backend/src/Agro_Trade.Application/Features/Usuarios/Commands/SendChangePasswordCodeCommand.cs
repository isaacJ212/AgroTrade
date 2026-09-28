using System.Security.Cryptography;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Exceptions;
using MediatR;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Application.Features.Usuarios.Commands;

public sealed record SendChangePasswordCodeCommand(int UserId) : IRequest<Unit>;

public sealed class SendChangePasswordCodeHandler(
    IMemoryCache cache,
    IUnitofWork unitOfWork,
    IEmailService emailService) : IRequestHandler<SendChangePasswordCodeCommand, Unit>
{
    public async Task<Unit> Handle(SendChangePasswordCodeCommand request, CancellationToken cancellationToken)
    {
        var user = await unitOfWork.Users.GetByIdAsync(request.UserId, cancellationToken);
        if (user is null || string.IsNullOrWhiteSpace(user.Email))
            throw new ApiExceptions(404, "No se encontró un correo asociado a esta cuenta.");

        var code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        cache.Set($"PWD_CODE_{request.UserId}", code, TimeSpan.FromMinutes(10));

        await emailService.SendVerificationCodeAsync(
            user.Email,
            code,
            "Seguridad AgroTrade: Código de Validación",
            "Confirmación de Identidad",
            "Has solicitado cambiar tu contraseña desde tu perfil. Tu código de seguridad es:",
            cancellationToken);

        return Unit.Value;
    }
}
