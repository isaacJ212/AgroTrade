using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.InventarioDtos;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Inventarios.Queries
{
    // Jafet: Se añadió el filtro de Estado opcional para manejar el inventario
    public record GetInventariosQuery(string? Estado = null) : IRequest<Result<List<InventarioDtos>>>;

    public class GetInventariosQueryHandler : IRequestHandler<GetInventariosQuery, Result<List<InventarioDtos>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetInventariosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<InventarioDtos>>> Handle(GetInventariosQuery request, CancellationToken cancellationToken)
        {
            // Modificado para poder devolver todo o filtrar por estado simulado
            var inventarios = await _unitOfWork.InventarioProveedor.FindAsync(i => i.Disponible, cancellationToken);
            
            // Si viene filtro de estado (Disponible, Poco inventario, Agotado), aplicamos lógica en memoria
            if (!string.IsNullOrEmpty(request.Estado))
            {
                inventarios = request.Estado.ToLower() switch
                {
                    "disponible" => inventarios.Where(i => i.StockActual > 20).ToList(),
                    "poco inventario" => inventarios.Where(i => i.StockActual > 0 && i.StockActual <= 20).ToList(),
                    "agotado" => inventarios.Where(i => i.StockActual <= 0).ToList(),
                    _ => inventarios
                };
            }
            
            if (inventarios == null || !inventarios.Any())
            {
                return Result<List<InventarioDtos>>.Success(200, new List<InventarioDtos>(), "No hay inventarios disponibles en este momento.", true);
            }

            // Obtener los IDs de productos únicos para hacer lookup
            var productoIds = inventarios.Select(i => i.IdProducto).Distinct().ToList();
            var productos = await _unitOfWork.Productos.FindAsync(p => productoIds.Contains(p.IdProducto), cancellationToken);
            var productosDict = productos?.ToDictionary(p => p.IdProducto) ?? new Dictionary<int, Agro_Trade.Domain.Entities.Producto>();

            var data = inventarios.Select(i => {
                productosDict.TryGetValue(i.IdProducto, out var prod);
                return new InventarioDtos
                {
                    IdInventario = i.IdInventario,
                    IdProveedor = i.IdProveedor,
                    IdProducto = i.IdProducto,
                    NombreProducto = prod?.Nombre ?? "Producto Desconocido",
                    UnidadMedida = prod?.UnidadMedida ?? "kg",
                    FotoUrl = i.FotoUrl,
                    VideoUrl = i.VideoUrl,
                    StockActual = i.StockActual,
                    CostoProduccion = i.CostoProduccion,
                    PrecioVenta = i.PrecioVenta,
                    EsOfertaExcedente = i.EsOfertaExcedente,
                    PorcentajeDescuento = i.PorcentajeDescuento,
                    FechaCosecha = i.FechaCosecha,
                    Disponible = i.Disponible
                };
            }).ToList();

            return Result<List<InventarioDtos>>.Success(200, data, "Inventarios obtenidos correctamente.", true);

        }


        
        
    }
}