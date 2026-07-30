namespace Agro_Trade.Application.Common.DTOs.ComprasDtos
{
    public record AddCartItemRequestDto(int ProductId, int Quantity);
    public record CheckoutRequestDto(string MetodoPago);
}
