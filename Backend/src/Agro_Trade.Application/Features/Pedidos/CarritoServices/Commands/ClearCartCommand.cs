using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.CarritoServices.Commands
{
    public record ClearCartCommand(int UserId) : IRequest<Result>;

    public class ClearCartCommandHandler(ICartRepository cartRepository) : IRequestHandler<ClearCartCommand, Result>
    {
        public Task<Result> Handle(ClearCartCommand request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0)
                return Task.FromResult(Result.Failure(400, "El usuario es invalido."));

            cartRepository.ClearCart(request.UserId);
            return Task.FromResult(Result.Success(200, "Carrito vaciado correctamente."));
        }
    }
}
