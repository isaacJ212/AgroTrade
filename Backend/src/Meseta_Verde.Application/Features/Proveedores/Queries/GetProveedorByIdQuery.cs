
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ProveedoresDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Proveedores.Queries
{
    public record GetProveedorByIdQuery(int IdProveedor) : IRequest<Result<ProveedorDto?>>;

    public class GetProveedorByIdQueryHandler : IRequestHandler<GetProveedorByIdQuery, Result<ProveedorDto?>>
    {
        private readonly IUnitOfWork _unitOfWork;

        public GetProveedorByIdQueryHandler(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<ProveedorDto?>> Handle(GetProveedorByIdQuery request, CancellationToken cancellationToken)
        {
            if (request.IdProveedor <= 0)
            {
                return Result<ProveedorDto?>.Failure(400, "El ID del proveedor es inválido.");
            }

            var proveedor = await _unitOfWork.Proveedores.GetByIdAsync(request.IdProveedor, cancellationToken);
            if (proveedor is null)
            {
                return Result<ProveedorDto?>.Failure(404, "No se encontró el proveedor.");
            }

            var data = new ProveedorDto 
            { 
                IdProveedor = proveedor.IdProveedor,
                IdUsuario = proveedor.IdUsuario,
                NombreProveedor = proveedor.NombreProveedor,
                NombreFinca = proveedor.NombreFinca,
                UbicacionGps = proveedor.UbicacionGps,
                Biografia = proveedor.Biografia,
                CalificacionPromedio = proveedor.CalificacionPromedio
            };
            return Result<ProveedorDto?>.Succes(200, data, "Proveedor obtenido correctamente.", true);
        }
    }
}
