using MediatR;
using Agro_Trade.Domain.Common.Purchases;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;

namespace Agro_Trade.Application.Features.Pedidos.CarritoServices.Commands
{
    public record AddCartItemCommand(int UserId, int ProductId, int Quantity) : IRequest<Result>;

    public class AddCartItemCommandHandler(ICartRepository cartRepository) : IRequestHandler<AddCartItemCommand, Result>
    {
        public  async Task<Result> Handle(AddCartItemCommand request, CancellationToken cancellationToken)
        {
            if (request.UserId <= 0 || request.ProductId <= 0 || request.Quantity <= 0)
                return Result.Failure(400, "Usuario, producto y cantidad deben ser validos.");

            var cart = await cartRepository.GetCart(request.UserId);
            var item = cart.Items.FirstOrDefault(i => i.ProductId == request.ProductId);

            if (item is null)
                cart.Items.Add(new CartItem { ProductId = request.ProductId, Quantity = request.Quantity });
            else
                item.Quantity += request.Quantity;

            await cartRepository.SaveCart(cart);
            return Result.Success(200, "Producto agregado al carrito.");
        }
    }
}
