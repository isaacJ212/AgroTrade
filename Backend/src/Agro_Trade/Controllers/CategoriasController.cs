using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.CategoriasDtos;
using Agro_Trade.Application.Features.Categorias.Commands;
using Agro_Trade.Application.Features.Categorias.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoriasController : ControllerBase
    {
        private readonly IMediator _mediator;

        public CategoriasController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<ActionResult<Result<List<CategoriaDto>>>> Get()
        {
            var result = await _mediator.Send(new GetCategoriasQuery());
            return Ok(result);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Result<CategoriaDto?>>> GetById(int id)
        {
            var result = await _mediator.Send(new GetCategoriaByIdQuery(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateCategoriaCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<Result<bool>>> Update([FromRoute] int id, [FromBody]  UpdateCategoryDto dto)
        {
            if (id <= 0)
            {
                return BadRequest(Result<bool>.Failure(400, "El ID de la categor�a es inv�lido."));
            }

            var result = await _mediator.Send(new UpdateCategoriaCommand(id, dto.Nombre ));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<Result<bool>>> Delete(int id)
        {
            var result = await _mediator.Send(new DeleteCategoriaCommand(id));
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }
    }
}