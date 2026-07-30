using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.UsersDtos;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Usuarios.Commands
{
    public record UpdatePasswordCommand(int id, UpdatePasswordDto dto): IRequest<Result<Unit>>;
    public class UpdatePasswordHandler(IUnitofWork context) : IRequestHandler<UpdatePasswordCommand, Result<Unit>>
    {
        public async Task<Result<Unit>>Handle(UpdatePasswordCommand request, CancellationToken ct)
        {
            var dto = request.dto;
            var userToUpdate = await context.Users.GetToUpdateAsync(request.id, ct);
            if (userToUpdate is null)
                return Result<Unit>.Failure(404, "Usuario No Encontrado");

            var isValidPassword = BCrypt.Net.BCrypt.Verify(dto.CurrentPassword, userToUpdate.PasswordHash);
            if (!isValidPassword)
                return Result<Unit>.Failure(400, "Contraseña Incorrecta");

            userToUpdate.PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.NewPassword);

            return Result<Unit>.Success(204, Unit.Value, "Exito", true);
        }
    }
}
