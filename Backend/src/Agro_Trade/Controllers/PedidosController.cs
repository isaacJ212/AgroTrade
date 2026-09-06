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
            var result = await mediator.Send(new ProcesarCompraDirectaCommand(userId, request.Items, request.MetodoPago));
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

        /// GET /api/Pedidos/proveedor/{idProveedor}
        /// Lista los pedidos que contienen productos del proveedor indicado.
        [HttpGet("proveedor/{idProveedor}")]
        public async Task<IActionResult> GetPorProveedor([FromRoute] int idProveedor, CancellationToken ct)
        {
            if (!TryGetUserId(out var _)) return Unauthorized();
            var result = await mediator.Send(new GetPedidosProveedorQuery(idProveedor), ct);
            return StatusCode(result.StatusCode, result);
        }

        /// PATCH /api/Pedidos/{id}/estado
        /// Cambia el estado de envío del pedido (usado por el Productor).
        [HttpPatch("{id}/estado")]
        public async Task<IActionResult> PatchEstado([FromRoute] int id, [FromBody] PatchEstadoRequest body, CancellationToken ct)
        {
            if (!TryGetUserId(out var _)) return Unauthorized();
            var result = await mediator.Send(new PatchPedidoEstadoCommand(id, body.NuevoEstado), ct);
            return StatusCode(result.StatusCode, result);
        }

        private bool TryGetUserId(out int userId)
        {
            try { return int.TryParse(User.GetUserId(), out userId); }
            catch (InvalidOperationException) { userId = 0; return false; }
        }
    }

    /// Body para PATCH /api/Pedidos/{id}/estado
    public record PatchEstadoRequest(string NuevoEstado);
}
