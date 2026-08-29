using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ProductosDtos
{
    public class PatchProductoDto
    {
        public int? IdCategoria { get; set; }

        public int? IdProveedor { get; set; }

        [StringLength(200, ErrorMessage = "El nombre del producto no puede exceder los 200 caracteres.")]
        public string? Nombre { get; set; }

        public string? Descripcion { get; set; }

        [StringLength(50, ErrorMessage = "La unidad de medida no puede exceder los 50 caracteres.")]
        public string? UnidadMedida { get; set; }
    }
}
