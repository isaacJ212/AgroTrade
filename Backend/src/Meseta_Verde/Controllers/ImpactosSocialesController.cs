using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.ImpactoSocialDtos;
using Meseta_Verde.Application.Features.ImpactoSocial.Queries;
using Meseta_Verde.Application.Common.DTOs.InventarioDtos;



namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ImpactosSocialesController : ControllerBase
    {

        private readonly IMediator _mediator;

        

        public ImpactosSocialesController(IMediator mediator)
        {
            _mediator = mediator;
        }


        [HttpGet("global")]
        public async Task<ActionResult<Result<ImpactoSocialGlobalDto>>> GetGlobal(CancellationToken ct)
        {
            var query = new GetImpactoGlobalQuery();
            var result = await _mediator.Send(query, ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }




        [HttpGet("proveedor/{id}")] 
        public async Task<ActionResult<Result<ImpactoProveedorDto>>> GetByProveedor(int id, CancellationToken ct)
        {
            var query = new GetImpactoProveedorQuery(id);
            var result = await _mediator.Send(query, ct);
    
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpGet("historial/{idProveedor}")]
        public async Task<ActionResult<Result<List<HistorialImpactoDto>>>> GetHistorial(int idProveedor, CancellationToken ct)
        {
            var query = new GetHistorialImpactoQuery(idProveedor);
            var result = await _mediator.Send(query, ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        [HttpGet("ranking")]
        public async Task<ActionResult<Result<List<RankingProveedorDto>>>> GetRanking([FromQuery] int top, CancellationToken ct)
        {
        
            var query = new GetRankingImpactoQuery(top > 0 ? top : 5);
            var result = await _mediator.Send(query, ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }


        [HttpGet("estadisticas")]
        public async Task<ActionResult<Result<List<EstadisticaImpactoDto>>>> GetEstadisticas([FromQuery] DateTime fechaInicio, [FromQuery] DateTime fechaFin, CancellationToken ct)
        {
            var query = new GetEstadisticasImpactoQuery(fechaInicio, fechaFin);
            var result = await _mediator.Send(query, ct);
            return result.IsSuccess ? Ok(result) : StatusCode(result.StatusCode, result);
        }



        
    }
}