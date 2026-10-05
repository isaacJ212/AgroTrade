using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.UsersDtos;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Usuarios.Queries
{
    public record GetUserByEmailQuery(string email) : IRequest<Result<UserDto>>;
    public class GetUserByEmailHandler(IUnitofWork context) : IRequestHandler<GetUserByEmailQuery, Result<UserDto>>
    {
        public async Task<Result<UserDto>> Handle(GetUserByEmailQuery request, CancellationToken ct)
        {
            var user = await context.Users.GetByEmailAsync(request.email, ct);
            if (user is null)
                return Result<UserDto>.Failure(404, "Usuario No Encontrado");

            var dto = new UserDto
            {
                Id = user.IdUsuario,
                Name = user.NombreCompleto,
                Email = user.Email,
                IdentidadVerificada = user.IdentidadVerificada,
                Telefono = user.Telefono,
                DireccionBase = user.DireccionBase,
                FechaRegistro = user.FechaRegistro,
                Departamento = user.Departamento
            };

            return Result<UserDto>.Success(200, dto, "Exit", true);

        }
    }
}
