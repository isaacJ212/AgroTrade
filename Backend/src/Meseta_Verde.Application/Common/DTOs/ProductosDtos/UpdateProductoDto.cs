using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.ProductosDtos
{
    public class UpdateProductoDto
    {
        [Required(ErrorMessage = "El Id de la categoría es obligatorio.")]
        public int IdCategoria { get; set; }

        [Required(ErrorMessage = "El Id del proveedor es obligatorio.")]
        public int IdProveedor { get; set; }

        [Required(ErrorMessage = "El nombre del producto es obligatorio.")]
        [StringLength(200, ErrorMessage = "El nombre del producto no puede exceder los 200 caracteres.")]
        public string Nombre { get; set; }

        public string? Descripcion { get; set; }

        [Required(ErrorMessage = "La unidad de medida es obligatoria.")]
        [StringLength(50, ErrorMessage = "La unidad de medida no puede exceder los 50 caracteres.")]
        public string UnidadMedida { get; set; }
    }
}
