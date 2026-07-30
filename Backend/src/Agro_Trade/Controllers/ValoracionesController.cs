using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.ValoracionesDtos;
using Agro_Trade.Application.Features.Valoraciones.Commands;
using Agro_Trade.Application.Features.Valoraciones.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ValoracionesController : ControllerBase
    {
        private readonly IMediator _mediator;

        public ValoracionesController(IMediator mediator)
        {
            _mediator = mediator;
        }

        // GET: api/Valoraciones/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Result<ValoracionDto>>> GetById(int id)
        {
            var result = await _mediator.Send(new GetValoracionByIdQuery(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        // GET: api/Valoraciones/proveedor/{idProveedor}
        [HttpGet("proveedor/{idProveedor}")]
        public async Task<ActionResult<Result<List<ValoracionDto>>>> GetByProveedor(int idProveedor)
        {
            var result = await _mediator.Send(new GetValoracionesByProveedorQuery(idProveedor));
            return Ok(result);
        }

        // GET: api/Valoraciones/cliente/{idCliente}
        [HttpGet("cliente/{idCliente}")]
        public async Task<ActionResult<Result<List<ValoracionDto>>>> GetByCliente(int idCliente)
        {
            var result = await _mediator.Send(new GetValoracionesByClienteQuery(idCliente));
            return Ok(result);
        }

        // POST: api/Valoraciones
        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateValoracionDto dto, [FromQuery] int idUsuarioCliente)
        {
            var command = new CreateValoracionCommand(
                dto.IdPedido,
                dto.IdProveedor,
                dto.TipoValoracion,
                dto.Puntuacion,
                dto.Comentario,
                idUsuarioCliente
            );

            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }

        // PUT: api/Valoraciones/{id}
        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update(int id, [FromBody] UpdateValoracionDto dto, [FromQuery] int idUsuarioCliente)
        {
            var command = new UpdateValoracionCommand(
                id,
                dto.Puntuacion,
                dto.Comentario,
                idUsuarioCliente
            );

            var result = await _mediator.Send(command);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        // DELETE: api/Valoraciones/{id}
        [HttpDelete("{id}")]
        public async Task<ActionResult<Result<bool>>> Delete(int id, [FromQuery] int idUsuarioCliente)
        {
            var result = await _mediator.Send(new DeleteValoracionCommand(id, idUsuarioCliente));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }
    }
}
