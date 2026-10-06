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

        
        
    }
}