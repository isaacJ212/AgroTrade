using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.InventarioDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Inventarios.Commands
{
    public record UpdateInventarioCommand(int IdInventario, UpdateInventarioDto Dto) : IRequest<Result<bool>>;

    public class UpdateInventarioCommandHandler : IRequestHandler<UpdateInventarioCommand, Result<bool>>
    {
        private readonly IUnitofWork _unitOfWork;

        public UpdateInventarioCommandHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<bool>> Handle(UpdateInventarioCommand request, CancellationToken cancellationToken)
        {
            // validar que el id seo correcto y buscar el registro
            if (request.IdInventario <= 0)
                return Result<bool>.Failure(400, "El ID del inventario es inválido.");

            var inventario = await _unitOfWork.InventarioProveedor.GetByIdAsync(request.IdInventario, cancellationToken);
            if (inventario is null)
                return Result<bool>.Failure(404, "No se encontró el registro de inventario.");

            //validar que las llaves foráneas existan en la BD
            if (!await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.Dto.IdProveedor, cancellationToken))
                return Result<bool>.Failure(404, "El proveedor especificado no existe.");

            if (!await _unitOfWork.Productos.AnyAsync(p => p.IdProducto == request.Dto.IdProducto, cancellationToken))
                return Result<bool>.Failure(404, "El producto especificado no existe.");

            // sobrescribir todos los datos

            inventario.IdProveedor = request.Dto.IdProveedor;
            inventario.IdProducto = request.Dto.IdProducto;
            inventario.StockActual = request.Dto.StockActual;
            inventario.CostoProduccion = request.Dto.CostoProduccion;
            inventario.PrecioVenta = request.Dto.PrecioVenta;
            inventario.EsOfertaExcedente = request.Dto.EsOfertaExcedente;
            inventario.PorcentajeDescuento = request.Dto.PorcentajeDescuento;
            inventario.FechaCosecha = request.Dto.FechaCosecha;
            inventario.Disponible = request.Dto.Disponible;

           
            await _unitOfWork.InventarioProveedor.UpdateAsync(inventario, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<bool>.Success(200, true, "Inventario actualizado de forma completa exitosamente.", true);
            
        }
        
    }
}