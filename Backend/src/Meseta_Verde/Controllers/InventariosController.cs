using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.InventarioDtos;
using MediatR;
using Meseta_Verde.Application.Features.Inventarios;
using Microsoft.AspNetCore.Components.Forms;
using Meseta_Verde.Application.Features.Inventarios.Queries;
using Meseta_Verde.Application.Features.Inventarios.Commands;



namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InventariosController : ControllerBase
    {
        private readonly IMediator _mediator;

        public InventariosController(IMediator mediator)
        {
            _mediator = mediator;
        }
        

        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromForm] CreateInventarioDto dto, IFormFile foto, CancellationToken ct)
        {
            if (foto == null)
                return BadRequest(Result<int>.Failure(400, "Debes incluir una imagen."));

            // Extraemos el stream del archivo HTTP y se lo pasamos al Command
            using var stream = foto.OpenReadStream();
            var command = new CreateInventarioCommand(dto, stream, foto.FileName);
            
            var result = await _mediator.Send(command, ct);

            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpGet]
        public async Task<ActionResult<Result<List<InventarioDtos>>>> Get(CancellationToken ct)
        {
            var query = new GetInventariosQuery();
            var result = await _mediator.Send(query, ct);
    
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpGet("{id}")]
        public async Task<ActionResult<Result<InventarioDtos?>>> GetById(int id, CancellationToken ct)
        {
            var query = new GetInventarioByIdQuery(id);
            var result = await _mediator.Send(query, ct);
    
    
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpPatch("{id}")]
        public async Task<ActionResult<Result<bool>>> Patch([FromRoute] int id, [FromBody] PatchInventarioDto dto, CancellationToken ct)
        {
            var command = new PatchInventarioCommand(id, dto);
            var result = await _mediator.Send(command, ct);
    
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update([FromRoute] int id, [FromBody] UpdateInventarioDto dto, CancellationToken ct)
        {
            var command = new UpdateInventarioCommand(id, dto);
            var result = await _mediator.Send(command, ct);
    
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }


    }
}