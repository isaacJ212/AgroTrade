using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Features.Bancos.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class BancosController(IMediator mediator) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<Result<List<BancoDto>>>> Get(CancellationToken ct)
    {
        var result = await mediator.Send(new GetBancosQuery(), ct);
        return StatusCode(result.StatusCode, result);
    }
}