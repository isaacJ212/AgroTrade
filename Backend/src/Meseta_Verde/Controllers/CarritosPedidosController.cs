using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos;
using Meseta_Verde.Application.Common.DTOs.ComprasDtos.Carritos;
using Meseta_Verde.Application.Features.Pedidos.CarritoServices.Commands;
using Meseta_Verde.Application.Features.Pedidos.CarritoServices.Queries;
using Meseta_Verde.Application.Features.Pedidos.Commands;
using Meseta_Verde.Application.Features.Pedidos.Queries;
using Meseta_Verde.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api")]
    [Authorize]
    public class CarritosPedidosController(IMediator mediator) : ControllerBase
    {
        [HttpGet("carrito")]
        public async Task<ActionResult<Result<CarritoDto>>> Get(CancellationToken ct)
        {

            if (!TryGetUserId(out var userId)) return Unauthorized(Result.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new GetCartQuery(userId), ct);
            return StatusCode(result.StatusCode, result);
        }
        [HttpPost("carrito/add")]
        public async Task<ActionResult<Result>> Add([FromBody] AddCartItemRequestDto request)
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new AddCartItemCommand(userId, request.ProductId, request.Quantity));
            return StatusCode(result.StatusCode, result);
        }

        [HttpDelete("carrito/clear")]
        public async Task<ActionResult<Result>> Clear()
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new ClearCartCommand(userId));
            return StatusCode(result.StatusCode, result);
        }

        [HttpPost("pedido/checkout")]
        public async Task<ActionResult<Result<CheckoutResponseDto>>> Checkout([FromBody] CheckoutRequestDto request)
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result<CheckoutResponseDto>.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new ProcesarCheckoutCommand(userId, request.MetodoPago));
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("repartidor/entregas/pendientes")]
        public async Task<ActionResult<Result<List<NotificacionEntregaDto>>>> GetNotificacionesEntrega()
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result<List<NotificacionEntregaDto>>.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new GetNotificacionesEntregaPendientesQuery(userId));
            return StatusCode(result.StatusCode, result);
        }

        [HttpPost("pedido/{pedidoId:int}/entrega/aceptar")]
        public async Task<ActionResult<Result>> AceptarEntrega(int pedidoId)
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new AceptarEntregaCommand(pedidoId, userId));
            return StatusCode(result.StatusCode, result);
        }

        private bool TryGetUserId(out int userId)
        {
            try
            {
                return int.TryParse(User.GetUserId(), out userId);
            }
            catch (InvalidOperationException)
            {
                userId = 0;
                return false;
            }
        }
    }
}
