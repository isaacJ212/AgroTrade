using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;
using Agro_Trade.Application.Features.Suscripciones.Commands;
using Agro_Trade.Application.Features.Suscripciones.Queries;
using Agro_Trade.Application.Features.TipoPlanes.Commands;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    //[Authorize] esta es para solo usuarios autenticados accedan
    public class SuscripcionesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public SuscripcionesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        /// <summary>
        /// Activa una nueva suscripción para un usuario (falla si ya tiene una activa).
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateSuscripcionDto dto, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new CreateSuscripcionCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }


        /// <summary>
        /// Cancela una suscripción activa (desactiva la renovación automática).
        /// </summary>
        [HttpPut("{idSuscripcion}/cancelar")]
        public async Task<IActionResult> Cancel([FromRoute] int idSuscripcion, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new CancelSuscripcionCommand(idSuscripcion), ct);
            return StatusCode(result.StatusCode, result);
        }


         /// <summary>
        /// Obtiene todo el historial de suscripciones de un usuario específico.
        /// </summary>
        [HttpGet("usuario/{idUsuario}")]
        public async Task<IActionResult> GetByUsuario([FromRoute] int idUsuario, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetSuscripcionesByUsuarioQuery(idUsuario), ct);
            return StatusCode(result.StatusCode, result);
        }

        /// <summary>
        /// Obtiene todas las suscripciones (Admin). Puede filtrar por rol.
        /// </summary>
        [HttpGet("all")]
        public async Task<IActionResult> GetAll([FromQuery] int? roleId, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetAllSuscripcionesQuery(roleId), ct);
            return StatusCode(result.StatusCode, result);
        }

        /// <summary>
        /// Obtiene métricas generales de las suscripciones (Admin).
        /// </summary>
        [HttpGet("metrics")]
        public async Task<IActionResult> GetMetrics(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetSuscripcionesMetricsQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

        /// <summary>
        /// Obtiene el historial de transacciones de suscripciones (Admin).
        /// </summary>
        [HttpGet("transacciones")]
        public async Task<IActionResult> GetTransacciones(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetTransaccionesSuscripcionQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

        /// <summary>
        /// Obtiene los tipos de planes de suscripción activos.
        /// </summary>
        [HttpGet("planes")]
        public async Task<IActionResult> GetPlanes(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetTiposPlanesQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }
        /// <summary>
        /// Actualiza un plan de suscripción (Admin).
        /// </summary>
        [HttpPut("planes/{idPlan}")]
        public async Task<IActionResult> UpdatePlan([FromRoute] int idPlan, [FromBody] UpdateTipoPlanDto dto, CancellationToken ct = default)
        {
            dto.IdPlan = idPlan;
            var result = await _mediator.Send(new UpdateTipoPlanCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }
        /// <summary>
        /// Crea un nuevo plan de suscripción (Admin).
        /// </summary>
        [HttpPost("planes")]
        public async Task<IActionResult> CreatePlan([FromBody] CreateTipoPlanDto dto, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new CreateTipoPlanCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }
    }
}