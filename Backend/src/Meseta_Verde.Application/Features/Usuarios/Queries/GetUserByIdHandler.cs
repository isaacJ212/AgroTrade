using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.UsersDtos;
using Meseta_Verde.Application.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Usuarios.Queries
{
    public record GetUserByIdQuery(int Id) : IRequest<Result<UserDto>>;
    public class GetUserByIdHandler(IUnitofWork context) : IRequestHandler<GetUserByIdQuery, Result<UserDto>>
    {
        public async Task<Result<UserDto>> Handle(GetUserByIdQuery request, CancellationToken cancellationToken)
        {
            var user = await context.Users.GetByIdAsync(request.Id, cancellationToken);
            if(user is null)
                return Result<UserDto>.Failure(404, "User not found");
            var dto = new UserDto
            {
                Id = user.IdUsuario,
                Name = user.NombreCompleto,
                Email = user.Email,
                IdentidadVerificada = user.IdentidadVerificada,
                Telefono = user.Telefono,
                DireccionBase = user.DireccionBase,
                FechaRegistro = user.FechaRegistro
            };
            return Result<UserDto>.Succes(200, dto, "User found", true);
        }
    }
}
