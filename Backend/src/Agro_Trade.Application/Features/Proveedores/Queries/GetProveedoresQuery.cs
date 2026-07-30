using System;
using System.Collections.Generic;
using System.Linq;
using Agro_Trade.Application.Common.Interface;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ProveedoresDtos;
using Agro_Trade.Application.Common.DTOs.ProductosDtos;

namespace Agro_Trade.Application.Features.Proveedores.Queries
{
    public record GetProveedoresQuery : IRequest<Result<List<ProveedorDto>>>;
    public class GetProveedoresQueryHandler : IRequestHandler<GetProveedoresQuery, Result<List<ProveedorDto>>>
    {
        private readonly IUnitofWork _unitOfWork;


        public GetProveedoresQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<ProveedorDto>>> Handle(GetProveedoresQuery request, CancellationToken cancellationToken)
        {
            var proveedores = await _unitOfWork.Proveedores.GetAllAsync(cancellationToken);
            if(proveedores == null || !proveedores.Any())
                return Result<List<ProveedorDto>>.Failure(200, "No se encontraron Proveedores");
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

            return Result<List<ProveedorDto>>.Success(200, data, "Productos Obtenido Correctamente", true);

        }
        
        
    }
}