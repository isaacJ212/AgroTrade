namespace Agro_Trade.Application.Common.DTOs.ComprasDtos
{
    public class NotificacionEntregaDto
    {
        public int PedidoId { get; set; }
        public string ZonaEntrega { get; set; } = string.Empty;
        public decimal TotalPedido { get; set; }
        public DateTime FechaCreacion { get; set; }
    }
}
