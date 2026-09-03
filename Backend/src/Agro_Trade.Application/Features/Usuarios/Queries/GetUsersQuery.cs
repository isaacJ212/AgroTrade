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
    public class GetUsersQuery : IRequest<Result<PagedResponse<UserDto>>>
    {
        public int PageIndex { get; set; } = 1;
        public int PageSize { get; set; } = 50;
    }

    public class GetUsersQueryHandler : IRequestHandler<GetUsersQuery, Result<PagedResponse<UserDto>>>
    {
        private readonly IUnitofWork _context;

        public GetUsersQueryHandler(IUnitofWork context)
        {
            _context = context;
        }

        public async Task<Result<PagedResponse<UserDto>>> Handle(GetUsersQuery request, CancellationToken cancellationToken)
        {
            var query = _context.Usuarios.GetQueryable();
            var totalCount = await query.CountAsync(cancellationToken);
            
            var usuariosEnt = await query
                .Skip((request.PageIndex - 1) * request.PageSize)
                .Take(request.PageSize)
                .ToListAsync(cancellationToken);
                
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
            
            var pagedData = PagedResponse<UserDto>.ToPagedResponse(usuarios, request.PageIndex, request.PageSize, totalCount);
            return Result<PagedResponse<UserDto>>.Success(200, pagedData, "Usuarios obtenidos correctamente", true);
        }
    }
}
