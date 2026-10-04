using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.CuentasBancarias.Commands;

public record UpdateCuentaBancariaCommand(
    int IdCuentaBancaria,
    int IdUsuario,
    UpdateCuentaBancariaDto Dto) : IRequest<Result<bool>>;

public class UpdateCuentaBancariaHandler(
    IUnitofWork context,
    IRepository<CuentaBancaria> repository)
    : IRequestHandler<UpdateCuentaBancariaCommand, Result<bool>>
{
    public async Task<Result<bool>> Handle(UpdateCuentaBancariaCommand request, CancellationToken ct)
    {
        if (request.IdCuentaBancaria <= 0)
            return Result<bool>.Failure(400, "El ID de la cuenta bancaria es inválido.");

        var cuenta = await repository.FirstOrDefaultAsync(
            c => c.IdCuenta == request.IdCuentaBancaria &&
                 c.IdUsuario == request.IdUsuario &&
                 c.isActive,
            ct);
        if (cuenta is null)
            return Result<bool>.Failure(404, "No se encontró la cuenta bancaria.");

        if (!await context.Bancos.AnyAsync(b => b.IdBanco == request.Dto.IdBanco, ct))
            return Result<bool>.Failure(404, "El banco especificado no existe.");

        if (await repository.AnyAsync(
                c => c.NumeroCuenta == request.Dto.NumeroCuentaBancaria &&
                     c.IdCuenta != request.IdCuentaBancaria,
                ct))
            return Result<bool>.Failure(409, "El número de cuenta ya existe.");

        cuenta.NumeroCuenta = request.Dto.NumeroCuentaBancaria;
        cuenta.IdBanco = request.Dto.IdBanco;
        cuenta.Titular = request.Dto.Titular;

        await repository.UpdateAsync(cuenta, ct);
        await context.SaveChangesAsync(ct);

        return Result<bool>.Success(200, true, "Cuenta bancaria actualizada correctamente.", true);
    }
}
