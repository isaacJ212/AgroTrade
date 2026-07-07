using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.CategoriasDtos
{
    public class UpdateCategoryDto
    {
        [Required(ErrorMessage = "El nombre de la categoría es obligatorio.")]
        [StringLength(50, ErrorMessage = "El nombre de la categoría no puede exceder los 50 caracteres.")]
        public string Nombre { get; set; }
    }
}
