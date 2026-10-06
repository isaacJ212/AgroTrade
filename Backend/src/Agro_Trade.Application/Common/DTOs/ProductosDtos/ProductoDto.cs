namespace Agro_Trade.Application.Common.DTOs.ProductosDtos
{
    public class ProductoDto
    {
        public int IdProducto { get; set; }
        public int IdCategoria { get; set; }
        public string? CategoriaNombre { get; set; }
        public int IdProveedor { get; set; }
        public int IdUnidadMedida { get; set; }
        public string? UnidadMedida { get; set; }   // código legible: "kg", "lb", "und"...
        public string? Nombre { get; set; }
        public string? Descripcion { get; set; }
        public decimal Precio { get; set; }
        public string? FotoUrl { get; set; }
    }
}