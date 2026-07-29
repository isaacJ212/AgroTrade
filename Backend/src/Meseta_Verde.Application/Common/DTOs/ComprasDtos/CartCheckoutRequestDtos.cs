namespace Meseta_Verde.Application.Common.DTOs.ComprasDtos
{
    public record AddCartItemRequestDto(int ProductId, int Quantity);
    public record CheckoutRequestDto(string MetodoPago);
}
