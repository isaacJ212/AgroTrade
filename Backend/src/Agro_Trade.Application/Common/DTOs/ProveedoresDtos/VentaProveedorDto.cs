namespace Agro_Trade.Application.Common.DTOs.ProveedoresDtos
{
    public class VentaProveedorDto
    {
        public int IdPedido { get; set; }
        public int IdDetallePedido { get; set; }
        public string Producto { get; set; } = string.Empty;
        public float Cantidad { get; set; }
        public decimal Subtotal { get; set; }
        public decimal NetoProveedor { get; set; }
        public DateTime FechaPedido { get; set; }
    }
}
