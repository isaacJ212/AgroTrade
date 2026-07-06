using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.UsersDtos;
using Meseta_Verde.Application.Interfaces;
using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Usuarios.Commands
{
    public record UpdateUserCommand(int id, UpdateUserDto dto) : IRequest<Result<Unit>>;
    public class UpdateUserHandler(IUnitofWork context) : IRequestHandler<UpdateUserCommand, Result<Unit>>
    {
        public async Task<Result<Unit>> Handle(UpdateUserCommand request, CancellationToken ct)
        {
            var dto = request.dto;
            if (request.id <= 0)
                return Result<Unit>.Failure(400, "Id Invalido");
            // traemos el usuario
            var user = await context.Users.GetToUpdateAsync(request.id, ct);
            if (user is null)
                return Result<Unit>.Failure(404, "Usuario No Existe");

            if (!string.IsNullOrEmpty(dto.Email) && dto.Email != user.Email)
            {
                // Verificamos si existe OTRA persona con ese email
                bool emailOcupado = await context.Users.AnyAsync(u => u.Email == dto.Email && u.IdUsuario != user.IdUsuario, ct);

                if (emailOcupado)
                {
                    return Result<Unit>.Failure(409, "Email ya está en uso");
                }

                user.Email = dto.Email;
            }
            if (!string.IsNullOrEmpty(dto.NombreCompleto)) user.NombreCompleto = dto.NombreCompleto;
            if (!string.IsNullOrEmpty(dto.DireccionBase)) user.DireccionBase = dto.DireccionBase;
            if (!string.IsNullOrEmpty(dto.Telefono)) user.Telefono = dto.Telefono;

            await context.SaveChangesAsync(ct);

            return Result<Unit>.Succes(204, Unit.Value, "Exito", true);
        }
    }
}
