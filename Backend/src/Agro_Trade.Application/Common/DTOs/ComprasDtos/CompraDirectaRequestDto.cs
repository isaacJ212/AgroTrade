namespace Agro_Trade.Application.Common.DTOs.ComprasDtos
{
    public record CartItemDto(int ProductId, int Quantity);
    public record CompraDirectaRequestDto(List<CartItemDto> Items, string MetodoPago);
}
