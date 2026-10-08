using MediatR;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries;
using Agro_Trade.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class RepartidorController : ControllerBase
    {
        private readonly IMediator _mediator;

        public RepartidorController(IMediator mediator)
        {
            _mediator = mediator;
        }

        /// <summary>
        /// Obtiene el estado de verificación del repartidor para el usuario autenticado
        /// </summary>
        /// <returns>Estado: tieneRepartidor, solicitudEstado, comentarioModerador</returns>
        [HttpGet("verificacion")]
        public async Task<IActionResult> GetVerificacion(CancellationToken ct)
        {
            var userIdString = User.GetUserId();
            if (!int.TryParse(userIdString, out var userId))
            {
                return Unauthorized("No se pudo identificar al usuario");
            }

            var result = await _mediator.Send(new GetRepartidorEstadoQuery(userId), ct);
            return StatusCode(result.StatusCode, result);
        }
    }
}