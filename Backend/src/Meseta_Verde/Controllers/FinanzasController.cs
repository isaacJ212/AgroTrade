using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.FinanzasDtos;
using Meseta_Verde.Application.Features.Finanzas.Queries;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Meseta_Verde.Controllers
{
    [ApiController]
    [Route("api/finanzas")]
    [Authorize]
    public class FinanzasController(IMediator mediator) : ControllerBase
    {
        [HttpGet("auditoria-ach")]
        public async Task<ActionResult<Result<List<RegistroTransferenciaAuditoriaDto>>>> GetAuditoriaAch()
        {
            var result = await mediator.Send(new GetDashboardAuditoriaACHQuery());
            return StatusCode(result.StatusCode, result);
        }
    }
}
