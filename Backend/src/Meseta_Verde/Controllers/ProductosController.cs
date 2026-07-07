using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ProductosDtos;
using Meseta_Verde.Application.Features.Productos.Commands;
using Meseta_Verde.Application.Features.Productos.Queries;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductosController : ControllerBase
    {
        private readonly IMediator _mediator;

        public ProductosController(IMediator mediator)
        {
            _mediator = mediator;
        }

        [HttpGet]
        public async Task<ActionResult<Result<List<ProductoDto>>>> Get()
        {
            var result = await _mediator.Send(new GetProductosQuery());
            return Ok(result);
        }

        [HttpPost]
        public async Task<ActionResult<Result<int>>> Create([FromBody] CreateProductoCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }
        
    }
}