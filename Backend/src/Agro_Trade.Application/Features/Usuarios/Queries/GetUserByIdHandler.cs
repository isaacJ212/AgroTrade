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
    public record GetUserByIdQuery(int Id) : IRequest<Result<UserDto>>;
    public class GetUserByIdHandler(IUnitofWork context) : IRequestHandler<GetUserByIdQuery, Result<UserDto>>
    {
        public async Task<Result<UserDto>> Handle(GetUserByIdQuery request, CancellationToken cancellationToken)
        {
            var user = await context.Users.GetByIdAsync(request.Id, cancellationToken);
            if(user is null)
                return Result<UserDto>.Failure(404, "User not found");
            var roles = await context.Users.GetRolesByUserIdAsync(user.IdUsuario, cancellationToken);
            var dto = new UserDto
            {
                Id = user.IdUsuario,
                Name = $"{user.Nombre} {user.PrimerApellido} {user.SegundoApellido}".Trim(),
                Email = user.Email,
                IdentidadVerificada = user.IdentidadVerificada,
                Telefono = user.Telefono,
                DireccionBase = $"{user.Departamento}, {user.Municipio}, {user.DireccionExacta}".Trim(new char[] { ',' , ' ' }),
                FechaRegistro = user.FechaRegistro,
                Departamento = user.Departamento,
                Municipio = user.Municipio,
                EstadoCuenta = user.EstadoCuenta,
                Roles = roles.ToList()
            };
            return Result<UserDto>.Success(200, dto, "User found", true);
        }
    }
}
