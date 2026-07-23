using MediatR;
using Meseta_Verda.Domain.Common.Purchases;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos.Carritos;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Meseta_Verde.Application.Features.Pedidos.CarritoServices.Queries
{
    public record GetCartQuery(int UserId) : IRequest<Result<CarritoDto>>;
    public class GetCartHandler(ICartRepository cart) : IRequestHandler<GetCartQuery, Result<CarritoDto>>
    {
        public async Task<Result<CarritoDto>> Handle(GetCartQuery request, CancellationToken ct)
        {
            var carrito = await cart.GetCart(request.UserId);
            if (carrito is null || !carrito.Items.Any())
            {
                return Result<CarritoDto>.Success(200, new CarritoDto { UserId = request.UserId, Items = new() }, "Carrito Vacio", true);
            }
            //mapeo, primero traemos los productos y sus propiedades de navegacion cargadas
            var productos = await cart.GetProductsInTheCart(request.UserId);

            var dictMapeo = productos.ToDictionary(p => p.IdProducto);

            var dto = ToDto(request.UserId, carrito, dictMapeo);

            return Result<CarritoDto>.Success(200, dto, "Carrito Obtenido con Exito", true);


            
        }

        public CarritoDto ToDto(int id,Cart carrito, Dictionary<int, Producto> dictMapeo)
        {
            return new CarritoDto
            {
                UserId = id,
                Items = carrito.Items.Select(item =>
                {
                    dictMapeo.TryGetValue(item.ProductId, out var producto);
                    return new ItemCarritoDto
                    {
                        ProductId = item.ProductId,
                        ProductName = producto?.Nombre?? "Producto Desconocido",
                        Quantity = item.Quantity,
                        SupplierName = producto?.Proveedor?.NombreProveedor?? "Proveedor No Encontrado"
                    };
                }).ToList()
            };
        }
    }
}
