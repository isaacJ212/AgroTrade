using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.UsersDtos;
using Agro_Trade.Domain.Entities;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Usuarios.Queries
{
    public class GetUsersQuery : IRequest<Result<List<UserDto>>>
    {
    }

    public class GetUsersQueryHandler : IRequestHandler<GetUsersQuery, Result<List<UserDto>>>
    {
        private readonly IUnitofWork _context;

        public GetUsersQueryHandler(IUnitofWork context)
        {
            _context = context;
        }

        public async Task<Result<List<UserDto>>> Handle(GetUsersQuery request, CancellationToken cancellationToken)
        {
            var usuariosEnt = await _context.Usuarios.GetAllAsync(cancellationToken);
            var usuarios = usuariosEnt.Select(u => new UserDto
                {
                    Id = u.IdUsuario,
                    Name = u.NombreCompleto,
                    Email = u.Email,
                    IdentidadVerificada = u.IdentidadVerificada,
                    Telefono = u.Telefono,
                    DireccionBase = u.DireccionBase,
                    Departamento = u.Departamento,
                    EstadoCuenta = u.EstadoCuenta,
                    FechaRegistro = u.FechaRegistro
                })
                .ToList();

            return Result<List<UserDto>>.Success(200, usuarios, "Usuarios obtenidos correctamente", true);
        }
    }
}
