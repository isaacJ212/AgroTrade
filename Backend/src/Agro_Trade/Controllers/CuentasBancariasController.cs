using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Features.CuentasBancarias.Commands;
using Agro_Trade.Application.Features.CuentasBancarias.Queries;
using Agro_Trade.Application.Helpers;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Agro_Trade.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class CuentasBancariasController(IMediator mediator) : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<Result<List<CuentaBancariaDto>>>> Get(CancellationToken ct)
    {
        if (!TryGetAuthenticatedUserId(out var userId))
            return Unauthorized(Result<List<CuentaBancariaDto>>.Failure(401, "JWT inválido."));

        var result = await mediator.Send(new GetCuentasBancariasQuery(userId), ct);
        return StatusCode(result.StatusCode, result);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<Result<CuentaBancariaDto?>>> GetById(int id, CancellationToken ct)
    {
        if (!TryGetAuthenticatedUserId(out var userId))
            return Unauthorized(Result<CuentaBancariaDto?>.Failure(401, "JWT inválido."));

        var result = await mediator.Send(new GetCuentaBancariaByIdQuery(id, userId), ct);
        return StatusCode(result.StatusCode, result);
    }

    [HttpPost]
    public async Task<ActionResult<Result<CuentaBancariaDto>>> Create(
        [FromBody] CreateCuentaBancariaDto dto,
        CancellationToken ct)
    {
        if (!TryGetAuthenticatedUserId(out var userId))
            return Unauthorized(Result<CuentaBancariaDto>.Failure(401, "JWT inválido."));

        var result = await mediator.Send(new CreateCuentaBancariaCommand(userId, dto), ct);
        return StatusCode(result.StatusCode, result);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<Result<bool>>> Update(
        int id,
        [FromBody] UpdateCuentaBancariaDto dto,
        CancellationToken ct)
    {
        if (!TryGetAuthenticatedUserId(out var userId))
            return Unauthorized(Result<bool>.Failure(401, "JWT inválido."));

        var result = await mediator.Send(new UpdateCuentaBancariaCommand(id, userId, dto), ct);
        return StatusCode(result.StatusCode, result);
    }

    [HttpDelete("{id:int}")]
    public async Task<ActionResult<Result<bool>>> Delete(int id, CancellationToken ct)
    {
        if (!TryGetAuthenticatedUserId(out var userId))
            return Unauthorized(Result<bool>.Failure(401, "JWT inválido."));

        var result = await mediator.Send(new DeleteCuentaBancariaCommand(id, userId), ct);
        return StatusCode(result.StatusCode, result);
    }

    private bool TryGetAuthenticatedUserId(out int userId)
    {
        userId = 0;
        try
        {
            return int.TryParse(User.GetUserId(), out userId);
        }
        catch (InvalidOperationException)
        {
            return false;
        }
    }
}
