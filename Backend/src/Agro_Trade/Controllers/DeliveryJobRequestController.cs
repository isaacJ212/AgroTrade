using MediatR;
using Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Commands;
using Agro_Trade.Application.Features.ColasRoles.Repartidores.Queries;
using Agro_Trade.Application.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class DeliveryJobRequestController : ControllerBase
    {
        private readonly IMediator _mediator;
        public DeliveryJobRequestController(IMediator mediatr)
        {
            _mediator = mediatr;
        }

        [HttpGet]
        [Authorize(Roles = "Administrador")]
        public async Task<IActionResult> GetUnseenRequest(CancellationToken ct, [FromQuery] int pageIndex = 1, [FromQuery] int pageSize = 8)
        {
            var request = await _mediator.Send(new GetUnSeenRequestQuery(pageIndex, pageSize), ct);
            return StatusCode(request.StatusCode, request);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById([FromRoute] int id, CancellationToken ct)
        {
            if(id <=0)
            {
                return BadRequest("Id Invalido");
            }
            var request = await _mediator.Send(new GetByIdQuery(id), ct);
            return StatusCode(request.StatusCode, request);
        }

        [HttpPost]
        public async Task<IActionResult> CreateJobRequest([FromBody]CreateSolicitudRepartidorDto dto, CancellationToken ct) {
            var id = User.GetUserId();
            int.TryParse(id, out int valId );
            var request = await _mediator.Send(new CreateDeliveryReqCommand(valId, dto.DatosRepartidor),ct);

            if (!request.IsSuccess)
            {
                return StatusCode(request.StatusCode, request);
            }

            return CreatedAtAction(nameof(GetById), new { id = request.Data.IdSolicitud }, request);

        }

        [HttpPatch("review")]
        [Authorize(Roles = "Administrador")] 
        public async Task<IActionResult> ReviewDeliveryRequest([FromBody] ReviewRequestDto dto, CancellationToken ct)
        {
           
            var result = await _mediator.Send(new ReviewRequestCommand(dto), ct);

          
            return StatusCode(result.StatusCode, result);
        }

        [HttpPatch("review/{id}")]
        [Authorize(Roles = "Administrador")]
        public async Task<IActionResult> ReviewDeliveryRequestById([FromRoute] int id, [FromBody] ReviewRequestDto dto, CancellationToken ct)
        {
            if (id <= 0)
            {
                return BadRequest("Id Invalido");
            }
            var result = await _mediator.Send(new ReviewRequestByIdCommand(id, dto), ct);
            return StatusCode(result.StatusCode, result);
        }

    }
}
