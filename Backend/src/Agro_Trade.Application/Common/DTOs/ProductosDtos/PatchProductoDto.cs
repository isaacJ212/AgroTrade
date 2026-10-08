namespace Agro_Trade.Application.Common.DTOs.ProductosDtos
{
    public class PatchProductoDto
    {
        public int? IdCategoria { get; set; }

        public int? IdProveedor { get; set; }

        public string? Nombre { get; set; }

        public string? Descripcion { get; set; }

        public int? IdUnidadMedida { get; set; }
    }
}

