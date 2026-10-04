using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.CuentasBancarias.Commands;

public record CreateCuentaBancariaCommand(int IdUsuario, CreateCuentaBancariaDto dto)
    : IRequest<Result<CuentaBancariaDto>>;

public class CreateCuentaBancariaHandler(IUnitofWork _context, IRepository<CuentaBancaria> _repository)
    : IRequestHandler<CreateCuentaBancariaCommand, Result<CuentaBancariaDto>>
{
    public async Task<Result<CuentaBancariaDto>> Handle(CreateCuentaBancariaCommand request,
        CancellationToken ct)
    {
        var dto = request.dto;

        if (!await _context.Usuarios.AnyAsync(u => u.IdUsuario == request.IdUsuario, ct))
            return Result<CuentaBancariaDto>.Failure(409, "Usuario No Existe");
        if (!await ValidateAsync(request.IdUsuario, dto, ct))
            return Result<CuentaBancariaDto>.Failure(409, "El número de cuenta ya existe o el banco no es válido.");

        var CuentaBancaria = new CuentaBancaria()
        {
            NumeroCuenta = dto.NumeroCuentaBancaria,
            Titular = dto.Titular,
            IdBanco = dto.IdBanco,
            CreatedAt = DateTime.UtcNow,
            IdUsuario = request.IdUsuario,
            isActive = true
        };

        await _repository.AddAsync(CuentaBancaria, ct);
        await _context.SaveChangesAsync(ct);
        
        var dtoCargado = await _repository.FirstOrDefaultAsync(
            c => c.IdCuenta == CuentaBancaria.IdCuenta,
            ct,
            c => c.Banco);

        var response = new CuentaBancariaDto
        {
            IdCuentaBancaria = dtoCargado.IdCuenta,
            NumeroCuentaBancaria = dtoCargado.NumeroCuenta,
            NombreBanco = dtoCargado.Banco.NombreBanco,
            Titular = dtoCargado.Titular,
        };
        
        return Result<CuentaBancariaDto>.Success(201,  response, "datos creados exitosamente", true);



    }

    public async Task<bool> ValidateAsync(int id, CreateCuentaBancariaDto dto, CancellationToken ct)
    {
        if (!await _context.Usuarios.AnyAsync(u => u.IdUsuario == id, ct) ||
            await _repository.AnyAsync(c => c.NumeroCuenta == dto.NumeroCuentaBancaria, ct) ||
            !await _context.Bancos.AnyAsync(b => b.IdBanco == dto.IdBanco, ct))
        {
            return false;
        }

        return true;
    }
}
