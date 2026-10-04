using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.CuentasBancarias.Queries;

public record GetCuentasBancariasQuery(int IdUsuario) : IRequest<Result<List<CuentaBancariaDto>>>;

public class GetCuentasBancariasHandler(IRepository<CuentaBancaria> repository)
    : IRequestHandler<GetCuentasBancariasQuery, Result<List<CuentaBancariaDto>>>
{
    public async Task<Result<List<CuentaBancariaDto>>> Handle(
        GetCuentasBancariasQuery request,
        CancellationToken ct)
    {
        var cuentas = await repository.FindAsync(
            c => c.IdUsuario == request.IdUsuario && c.isActive,
            ct,
            c => c.Banco);
        var data = cuentas.Select(c => new CuentaBancariaDto
        {
            IdCuentaBancaria = c.IdCuenta,
            NumeroCuentaBancaria = c.NumeroCuenta,
            NombreBanco = c.Banco.NombreBanco,
            Titular = c.Titular
        }).ToList();

        return Result<List<CuentaBancariaDto>>.Success(
            200, data, "Cuentas bancarias obtenidas correctamente.", true);
    }
}
