using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.CuentasBancarias.Commands;

public record DeleteCuentaBancariaCommand(int IdCuentaBancaria, int IdUsuario) : IRequest<Result<bool>>;

public class DeleteCuentaBancariaHandler(IUnitofWork context, IRepository<CuentaBancaria> repository)
    : IRequestHandler<DeleteCuentaBancariaCommand, Result<bool>>
{
    public async Task<Result<bool>> Handle(DeleteCuentaBancariaCommand request, CancellationToken ct)
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

        cuenta.isActive = false;
        await repository.UpdateAsync(cuenta, ct);
        await context.SaveChangesAsync(ct);

        return Result<bool>.Success(200, true, "Cuenta bancaria eliminada correctamente.", true);
    }
}
