using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ComprasDtos;
using Agro_Trade.Application.Features.Pedidos.Commands;
using Agro_Trade.Application.Features.Pedidos.Queries;
using Agro_Trade.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class PedidosController(IMediator mediator) : ControllerBase
    {
        [HttpPost("checkout-directo")]
        public async Task<ActionResult<Result<CheckoutResponseDto>>> CheckoutDirecto([FromBody] CompraDirectaRequestDto request)
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result<CheckoutResponseDto>.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new ProcesarCompraDirectaCommand(userId, request.ProductId, request.Quantity, request.MetodoPago));
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("historial")]
        public async Task<ActionResult<Result<List<PedidoClienteDto>>>> Historial()
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result<List<PedidoClienteDto>>.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new GetHistorialComprasClienteQuery(userId));
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id, CancellationToken cancellationToken)
        {
            if (!TryGetUserId(out var userId)) return Unauthorized(Result<List<PedidoClienteDto>>.Failure(401, "JWT invalido."));
            var result = await mediator.Send(new GetPedidoByIdCommand(id));
            return StatusCode(result.StatusCode, result);

        }

        private bool TryGetUserId(out int userId)
        {
            try { return int.TryParse(User.GetUserId(), out userId); }
            catch (InvalidOperationException) { userId = 0; return false; }
        }
    }
}
