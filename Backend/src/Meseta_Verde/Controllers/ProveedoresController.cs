using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MediatR;
using Meseta_Verde.Application.Common.Interface;
using Microsoft.AspNetCore.Mvc;
using Meseta_Verde.Application.Common.DTOs.ProveedoresDtos;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Features.Proveedores.Queries;
using Meseta_Verde.Application.Features.Proveedores.Commands;


namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProveedoresController : ControllerBase
    {
        private readonly IMediator _mediator;
        private readonly IUnitOfWork _unitOfWork;

        public ProveedoresController(IMediator mediator, IUnitOfWork unitOfWork)
        {
            _mediator = mediator;
            _unitOfWork = unitOfWork;
        }

        [HttpGet]
        public async Task<ActionResult<Result<List<ProveedorDto>>>> Get()
        {
            var result = await _mediator.Send(new GetProveedoresQuery());
            return Ok(result);
        }
        
        [HttpPost]
        public async Task<ActionResult<Result<int>>>Create([FromBody] CreateProveedorCommand command)
        {
            var result = await _mediator.Send(command);
            return StatusCode(result.StatusCode, result);
        }
    }
}