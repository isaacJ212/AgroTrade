using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.SuscripcionesDtos;
using Agro_Trade.Application.Features.Suscripciones.Commands;
using Agro_Trade.Application.Features.Suscripciones.Queries;
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

        // Jafet: Se añadieron los Endpoints para el panel de administración web
        [HttpGet("all")]
        public async Task<IActionResult> GetAll([FromQuery] int? roleId = null, CancellationToken ct = default)
        {
            // Note: Updated GetAllSuscripcionesQuery might not take roleId anymore depending on the implementation
            var result = await _mediator.Send(new GetAllSuscripcionesQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("transacciones")]
        public async Task<IActionResult> GetTransacciones(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetTransaccionesSuscripcionQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("planes")]
        public async Task<IActionResult> GetPlanes(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new Agro_Trade.Application.Features.TipoPlanes.Queries.GetTipoPlanesQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

        [HttpPost("planes")]
        public async Task<IActionResult> CreatePlan([FromBody] Agro_Trade.Application.Features.TipoPlanes.Commands.CreateTipoPlanDto dto, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new Agro_Trade.Application.Features.TipoPlanes.Commands.CreateTipoPlanCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }

        [HttpPut("planes")]
        public async Task<IActionResult> UpdatePlan([FromBody] Agro_Trade.Application.Features.TipoPlanes.Commands.UpdateTipoPlanDto dto, CancellationToken ct = default)
        {
            var result = await _mediator.Send(new Agro_Trade.Application.Features.TipoPlanes.Commands.UpdateTipoPlanCommand(dto), ct);
            return StatusCode(result.StatusCode, result);
        }

        [HttpGet("metrics")]
        public async Task<IActionResult> GetMetrics(CancellationToken ct = default)
        {
            var result = await _mediator.Send(new GetSuscripcionesMetricsQuery(), ct);
            return StatusCode(result.StatusCode, result);
        }

    }
}