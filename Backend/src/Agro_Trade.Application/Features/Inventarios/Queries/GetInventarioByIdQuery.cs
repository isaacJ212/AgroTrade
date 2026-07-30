using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.InventarioDtos;
using Agro_Trade.Application.Common.Interface;


namespace Agro_Trade.Application.Features.Inventarios.Queries
{
   
    public record GetInventarioByIdQuery(int IdInventario) : IRequest<Result<InventarioDtos?>>;


    public class GetInventarioByIdQueryHandler : IRequestHandler<GetInventarioByIdQuery, Result<InventarioDtos?>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetInventarioByIdQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<InventarioDtos?>> Handle(GetInventarioByIdQuery request, CancellationToken cancellationToken)
        {
            // Validamos que el ID no sea un número negativo o cero
            if (request.IdInventario <= 0)
            {
                return Result<InventarioDtos?>.Failure(400, "El ID del inventario es inválido.");
            }

            // Usamos FirstOrDefaultAsync para buscar el ID y asegurarnos de que el registro no esté eliminado lógicamente
            var inventario = await _unitOfWork.InventarioProveedor.FirstOrDefaultAsync(
                i => i.IdInventario == request.IdInventario && i.Disponible, 
                cancellationToken);

            // Si es null, significa que no existe o Disponible es false
            if (inventario is null)
            {
                return Result<InventarioDtos?>.Failure(404, "No se encontró el inventario o ya no está disponible.");
            }


            // Mapeamos hacia el DTO
            var data = new InventarioDtos
            {
                IdInventario = inventario.IdInventario,
                IdProveedor = inventario.IdProveedor,
                IdProducto = inventario.IdProducto,
                FotoUrl = inventario.FotoUrl,
                VideoUrl = inventario.VideoUrl,
                StockActual = inventario.StockActual,
                CostoProduccion = inventario.CostoProduccion,
                PrecioVenta = inventario.PrecioVenta,
                EsOfertaExcedente = inventario.EsOfertaExcedente,
                PorcentajeDescuento = inventario.PorcentajeDescuento,
                FechaCosecha = inventario.FechaCosecha,
                Disponible = inventario.Disponible
            };

            return Result<InventarioDtos?>.Success(200, data, "Inventario obtenido correctamente.", true);



        }
    }
}