namespace Meseta_Verde.Application.Common.DTOs.ComprasDtos
{
    public class CheckoutResponseDto
    {
        public int PedidoId { get; set; }
        public decimal Total { get; set; }
        public decimal TotalProductores { get; set; }
        public string MetodoPago { get; set; } = string.Empty;
        public int RepartidoresNotificados { get; set; }
        public List<TransferenciaCheckoutDto> Transferencias { get; set; } = [];
    }

    public class TransferenciaCheckoutDto
    {
        public string IdTransferencia { get; set; } = string.Empty;
        public string Proveedor { get; set; } = string.Empty;
        public decimal MontoEnviado { get; set; }
        public string Estado { get; set; } = string.Empty;
    }
}
