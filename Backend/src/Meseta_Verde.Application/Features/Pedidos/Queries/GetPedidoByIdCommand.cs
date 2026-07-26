using Google.Apis.Util;
using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Pedidos.Queries
{
    public sealed record GetPedidoByIdCommand(int IdPedido) : IRequest<Result<PedidoClienteDto>>;
    public class GetPedidoByIdHandler(IRepository<Pedido> pedidosRepository) : IRequestHandler<GetPedidoByIdCommand, Result<PedidoClienteDto>>
    {
        public async Task<Result<PedidoClienteDto>> Handle(GetPedidoByIdCommand request, CancellationToken ct)
        {
            if (request.IdPedido <= 0) return Result<PedidoClienteDto>.Failure(400, "Id Invalido");

            var pedido = await pedidosRepository.FirstOrDefaultAsync(p => p.IdPedido == request.IdPedido, ct, "Detalles.Inventario.Producto");

            var dto = new PedidoClienteDto
            {
                IdPedido = pedido.IdPedido,
                EstadoEnvio = pedido.EstadoEnvio,
                MetodoPago = pedido.MetodoPago,
                EstadoPago = pedido.EstadoPago,
                FechaPedido = pedido.FechaPedido,
                Total = pedido.Total,
                Detalles = pedido.Detalles.Select(p => new DetallePedidoDto
                {
                    Id = p.IdDetallePedido,
                    PedidoId = p.IdPedido,
                    Cantidad = p.Cantidad,
                    Producto = p.Inventario.Producto.Nombre,
                    TotalLinea = p.Subtotal

                }).ToList()
            };
            return Result<PedidoClienteDto>.Success(200, dto, "Pedido Obtenido con exito", true);
        }
    }
    
    
}
