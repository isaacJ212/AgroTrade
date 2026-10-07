using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.InventarioDtos;
using Agro_Trade.Application.Common.Interface;
using Microsoft.EntityFrameworkCore;

namespace Agro_Trade.Application.Features.Inventarios.Queries
{
    public record GetInventariosQuery(int? UsuarioId = null) : IRequest<Result<List<InventarioDtos>>>;

    public class GetInventariosQueryHandler : IRequestHandler<GetInventariosQuery, Result<List<InventarioDtos>>>
    {
        private readonly IUnitofWork _unitOfWork;

        public GetInventariosQueryHandler(IUnitofWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        public async Task<Result<List<InventarioDtos>>> Handle(GetInventariosQuery request, CancellationToken cancellationToken)
        {
            // Si se proporciona UsuarioId, buscar el proveedor y filtrar por él
            int? idProveedor = null;
            if (request.UsuarioId.HasValue && request.UsuarioId.Value > 0)
            {
                var proveedor = await _unitOfWork.Proveedores.FirstOrDefaultAsync(
                    p => p.IdUsuario == request.UsuarioId.Value, cancellationToken);
                if (proveedor != null)
                {
                    idProveedor = proveedor.IdProveedor;
                }
            }

            var query = _unitOfWork.InventarioProveedor.GetQueryable()
                .Where(i => i.Disponible);

            if (idProveedor.HasValue)
            {
                query = query.Where(i => i.IdProveedor == idProveedor.Value);
            }

            var inventarios = await query.ToListAsync(cancellationToken);

            if (inventarios == null || !inventarios.Any())
                return Result<List<InventarioDtos>>.Success(200, [], "No hay inventarios disponibles en este momento.", true);

            // Cargar productos con su unidad de medida en un solo query
            var productoIds = inventarios.Select(i => i.IdProducto).Distinct().ToList();
            var productos = await _unitOfWork.Productos.GetQueryable()
                .Include(p => p.UnidadDeMedida)
                .Where(p => productoIds.Contains(p.IdProducto))
                .ToDictionaryAsync(p => p.IdProducto, cancellationToken);

            var data = inventarios.Select(i =>
            {
                productos.TryGetValue(i.IdProducto, out var prod);
                return new InventarioDtos
                {
                    IdInventario        = i.IdInventario,
                    IdProveedor         = i.IdProveedor,
                    IdProducto          = i.IdProducto,
                    NombreProducto      = prod?.Nombre ?? "Producto Desconocido",
                    UnidadMedida        = prod?.UnidadDeMedida?.Codigo ?? "und",
                    IdUnidadMedida      = prod?.UnidadDeMedida?.Id ?? 1,
                    FotoUrl             = i.FotoUrl,
                    VideoUrl            = i.VideoUrl,
                    StockActual         = i.StockActual,
                    CostoProduccion     = i.CostoProduccion,
                    PrecioVenta         = i.PrecioVenta,
                    EsOfertaExcedente   = i.EsOfertaExcedente,
                    PorcentajeDescuento = i.PorcentajeDescuento,
                    FechaCosecha        = i.FechaCosecha,
                    Disponible          = i.Disponible
                };
            }).ToList();

            return Result<List<InventarioDtos>>.Success(200, data, "Inventarios obtenidos correctamente.", true);
        }
    }
}