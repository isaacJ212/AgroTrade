using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.SuscripcionesDtos;
using Meseta_Verde.Application.Features.Suscripciones.Commands;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
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
        
    }
}