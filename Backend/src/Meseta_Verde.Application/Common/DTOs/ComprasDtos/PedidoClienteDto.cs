using Microsoft.EntityFrameworkCore.Storage.Json;

namespace Meseta_Verde.Application.Common.DTOs.ComprasDtos
{
    public class PedidoClienteDto
    {
        public int IdPedido { get; set; }
        public DateTime FechaPedido { get; set; }
        public decimal Total { get; set; }
        public string? MetodoPago { get; set; }
        public string? EstadoPago { get; set; }
        public string? EstadoEnvio { get; set; }

        public ICollection<DetallePedidoDto> Detalles { get; set; } = new List<DetallePedidoDto>();
    }

    public class DetallePedidoDto
    {
        public int Id { get; set; }
        public int PedidoId { get; set; }
        public string? Producto { get; set; }
        public float Cantidad { get; set; }
        public decimal TotalLinea { get; set; }
    }
}
