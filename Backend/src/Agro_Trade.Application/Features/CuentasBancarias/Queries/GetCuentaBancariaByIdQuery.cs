using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.CuentasBancarias.Queries;

public record GetCuentaBancariaByIdQuery(int IdCuentaBancaria, int IdUsuario)
    : IRequest<Result<CuentaBancariaDto?>>;

public class GetCuentaBancariaByIdHandler(IRepository<CuentaBancaria> repository)
    : IRequestHandler<GetCuentaBancariaByIdQuery, Result<CuentaBancariaDto?>>
{
    public async Task<Result<CuentaBancariaDto?>> Handle(
        GetCuentaBancariaByIdQuery request,
        CancellationToken ct)
    {
        if (request.IdCuentaBancaria <= 0)
            return Result<CuentaBancariaDto?>.Failure(400, "El ID de la cuenta bancaria es inválido.");

        var cuenta = await repository.FirstOrDefaultAsync(
            c => c.IdCuenta == request.IdCuentaBancaria &&
                 c.IdUsuario == request.IdUsuario &&
                 c.isActive,
            ct,
            c => c.Banco);
        if (cuenta is null)
            return Result<CuentaBancariaDto?>.Failure(404, "No se encontró la cuenta bancaria.");

        var data = new CuentaBancariaDto
        {
            IdCuentaBancaria = cuenta.IdCuenta,
            NumeroCuentaBancaria = cuenta.NumeroCuenta,
            NombreBanco = cuenta.Banco.NombreBanco,
            Titular = cuenta.Titular
        };

        return Result<CuentaBancariaDto?>.Success(
            200, data, "Cuenta bancaria obtenida correctamente.", true);
    }
}
