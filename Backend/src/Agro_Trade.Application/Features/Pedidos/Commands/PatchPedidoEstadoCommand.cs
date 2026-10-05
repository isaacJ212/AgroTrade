using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.Commands
{
    public sealed record PatchPedidoEstadoCommand(int IdPedido, string NuevoEstado) : IRequest<Result<bool>>;

    public class PatchPedidoEstadoHandler(IRepository<Pedido> pedidoRepo)
        : IRequestHandler<PatchPedidoEstadoCommand, Result<bool>>
    {
        private static readonly HashSet<string> _estadosValidos = new(StringComparer.OrdinalIgnoreCase)
        {
            "Pendiente", "Preparando", "Listo", "Entregado", "Cancelado", "Rechazado"
        };

        public async Task<Result<bool>> Handle(PatchPedidoEstadoCommand request, CancellationToken ct)
        {
            if (request.IdPedido <= 0)
                return Result<bool>.Failure(400, "IdPedido inválido.");

            if (!_estadosValidos.Contains(request.NuevoEstado))
                return Result<bool>.Failure(400,
                    $"Estado '{request.NuevoEstado}' no permitido. Use: {string.Join(", ", _estadosValidos)}");

            var pedido = await pedidoRepo.FirstOrDefaultAsync(p => p.IdPedido == request.IdPedido, ct);
            if (pedido == null)
                return Result<bool>.Failure(404, $"Pedido {request.IdPedido} no encontrado.");

            pedido.EstadoEnvio = request.NuevoEstado;
            await pedidoRepo.UpdateAsync(pedido, ct);

            return Result<bool>.Success(200, true,
                $"Pedido {request.IdPedido} actualizado a '{request.NuevoEstado}'.", true);
        }
    }
}
