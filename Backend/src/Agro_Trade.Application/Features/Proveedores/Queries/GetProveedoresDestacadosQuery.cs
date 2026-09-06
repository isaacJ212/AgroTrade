using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProveedoresDtos;
using Agro_Trade.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Proveedores.Queries
{
    public record GetProveedoresDestacadosQuery(int Limit = 5) : IRequest<Result<List<ProveedorDto>>>;

    public class GetProveedoresDestacadosQueryHandler : IRequestHandler<GetProveedoresDestacadosQuery, Result<List<ProveedorDto>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetProveedoresDestacadosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ProveedorDto>>> Handle(GetProveedoresDestacadosQuery request, CancellationToken cancellationToken)
        {
            var proveedores = await _unitOfWork.Proveedores.GetQueryable()
                .OrderByDescending(p => p.CalificacionPromedio)
                .Take(request.Limit)
                .ToListAsync(cancellationToken);

            var data = proveedores.Select(p => new ProveedorDto
            {
                IdProveedor = p.IdProveedor,
                IdUsuario = p.IdUsuario,
                NombreProveedor = p.NombreProveedor,
                NombreFinca = p.NombreFinca,
                UbicacionGps = p.UbicacionGps,
                Biografia = p.Biografia,
                CalificacionPromedio = p.CalificacionPromedio
            }).ToList();

            return Result<List<ProveedorDto>>.Success(200, data, "Proveedores destacados obtenidos correctamente.", true);
        }
    }
}
