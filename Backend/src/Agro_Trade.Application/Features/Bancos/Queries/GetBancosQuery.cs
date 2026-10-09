using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.Bancos.Queries;

public record GetBancosQuery : IRequest<Result<List<BancoDto>>>;

public class GetBancosHandler(IRepository<Banco> repository)
    : IRequestHandler<GetBancosQuery, Result<List<BancoDto>>>
{
    public async Task<Result<List<BancoDto>>> Handle(GetBancosQuery request, CancellationToken ct)
    {
        var bancos = await repository.FindAsync(banco => banco.IsActive, ct);
        var data = bancos
            .OrderBy(banco => banco.NombreBanco)
            .Select(banco => new BancoDto
            {
                IdBanco = banco.IdBanco,
                NombreBanco = banco.NombreBanco
            })
            .ToList();

        return Result<List<BancoDto>>.Success(200, data, "Bancos activos obtenidos correctamente.", true);
    }
}