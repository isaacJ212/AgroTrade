using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ProductosDtos
{
    public class UpdateProductoDto
    {
        [Required(ErrorMessage = "El Id de la categoría es obligatorio.")]
        public int IdCategoria { get; set; }

        [Required(ErrorMessage = "El Id del proveedor es obligatorio.")]
        public int IdProveedor { get; set; }

        [Required(ErrorMessage = "El nombre del producto es obligatorio.")]
        [StringLength(200, ErrorMessage = "El nombre del producto no puede exceder los 200 caracteres.")]
        public string Nombre { get; set; } = null!;

        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "El Id de la unidad de medida es obligatorio.")]
        public int IdUnidadMedida { get; set; }
    }
}
