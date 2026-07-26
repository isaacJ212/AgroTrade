using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.FinanzasDtos;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Application.Features.Finanzas.Queries
{
    public record GetDashboardAuditoriaACHQuery : IRequest<Result<List<RegistroTransferenciaAuditoriaDto>>>;

    public class GetDashboardAuditoriaACHHandler(IRepository<RegistroTransferenciaMock> transferenciaRepository) : IRequestHandler<GetDashboardAuditoriaACHQuery, Result<List<RegistroTransferenciaAuditoriaDto>>>
    {
        public async Task<Result<List<RegistroTransferenciaAuditoriaDto>>> Handle(GetDashboardAuditoriaACHQuery request, CancellationToken cancellationToken)
        {
            var transferencias = await transferenciaRepository.FindAsync(t => true, cancellationToken, t => t.Pedido);
            var data = transferencias.Select(t => new RegistroTransferenciaAuditoriaDto
            {
                IdTransferencia = t.IdTransferencia,
                IdPedido = t.IdPedido,
                TotalPedido = t.Pedido.Total,
                Proveedor = t.Proveedor,
                BancoDestino = t.BancoDestino,
                Cuenta = t.Cuenta,
                MontoEnviado = t.MontoEnviado,
                Estado = t.Estado
            }).ToList();

            return Result<List<RegistroTransferenciaAuditoriaDto>>.Success(200, data, "Auditoria ACH obtenida correctamente.", true);
        }
    }
}
