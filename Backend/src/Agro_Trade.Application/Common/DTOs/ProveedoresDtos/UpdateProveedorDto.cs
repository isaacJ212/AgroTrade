
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ProveedoresDtos
{
    public class UpdateProveedorDto
    {
        [Required]
        public int IdUsuario { get; set; }
        [Required(ErrorMessage = "El nombre del proveedor es obligatorio.")]
        [MaxLength(150, ErrorMessage = "El nombre no puede exceder 150 caracteres.")]
        public string NombreProveedor { get; set; } = null!;
        [MaxLength(150)]
        public string? NombreFinca { get; set; }
        public string? UbicacionGps { get; set; }
        public string? Biografia { get; set; }
        public float? CalificacionPromedio { get; set; }
    }
}
