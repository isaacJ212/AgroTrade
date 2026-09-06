using System;
using System.Collections.Generic;
using System.Linq;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.InventarioDtos;
using Agro_Trade.Application.Common.Interface;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Inventarios.Commands
{
    public record PatchInventarioCommand(int IdInventario, PatchInventarioDto Dto) : IRequest<Result<bool>>;


    public class PatchInventarioCommandHandler : IRequestHandler<PatchInventarioCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public PatchInventarioCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(PatchInventarioCommand request, CancellationToken cancellationToken)
        {
            // Validaciones básicas
            if (request.IdInventario <= 0)
                return Result<bool>.Failure(400, "El ID del inventario es inválido.");

            if (request.Dto is null)
                return Result<bool>.Failure(400, "No se proporcionaron datos para actualizar.");

            // Buscar el inventario actual
            var inventario = await _unitOfWork.InventarioProveedor.GetByIdAsync(request.IdInventario, cancellationToken);
            
            if (inventario is null)
                return Result<bool>.Failure(404, "No se encontró el inventario.");

            // Validar Llaves Foráneas solo si vienen en el DTO
            if (request.Dto.IdProveedor.HasValue)
            {
                var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.Dto.IdProveedor.Value, cancellationToken);
                if (!proveedorExiste) return Result<bool>.Failure(404, "El proveedor especificado no existe.");
                
                inventario.IdProveedor = request.Dto.IdProveedor.Value;
            }

            if (request.Dto.IdProducto.HasValue)
            {
                var productoExiste = await _unitOfWork.Productos.AnyAsync(p => p.IdProducto == request.Dto.IdProducto.Value, cancellationToken);
                if (!productoExiste) return Result<bool>.Failure(404, "El producto especificado no existe.");
                
                inventario.IdProducto = request.Dto.IdProducto.Value;
            }



            if (request.Dto.StockActual.HasValue) inventario.StockActual = request.Dto.StockActual.Value;
            if (request.Dto.CostoProduccion.HasValue) inventario.CostoProduccion = request.Dto.CostoProduccion.Value;
            if (request.Dto.PrecioVenta.HasValue) inventario.PrecioVenta = request.Dto.PrecioVenta.Value;
            if (request.Dto.EsOfertaExcedente.HasValue) inventario.EsOfertaExcedente = request.Dto.EsOfertaExcedente.Value;
            if (request.Dto.PorcentajeDescuento.HasValue) inventario.PorcentajeDescuento = request.Dto.PorcentajeDescuento.Value;
            // Convertir a UTC para evitar error de PostgreSQL timestamptz
            if (request.Dto.FechaCosecha.HasValue) 
                inventario.FechaCosecha = DateTime.SpecifyKind(request.Dto.FechaCosecha.Value, DateTimeKind.Utc);
            if (request.Dto.Disponible.HasValue) inventario.Disponible = request.Dto.Disponible.Value;

            // Guardar en la base de datos
            await _unitOfWork.InventarioProveedor.UpdateAsync(inventario, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Inventario actualizado parcialmente con éxito.", true);



        }
    }
}