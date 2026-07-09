using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.ProveedoresDtos
{
    public class ProveedorDto
    {
        public int IdProveedor { get; set; }
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "El nombre del proveedor es obligatorio.")]
        [MaxLength(150, ErrorMessage = "El nombre del proveedor no puede exceder los 150 caracteres.")]
        public string NombreProveedor { get; set; } = null!;

        [MaxLength(150, ErrorMessage = "El nombre de la finca no puede exceder los 150 caracteres.")]
        public string? NombreFinca { get; set; }

        public string? UbicacionGps { get; set; }

        public string? Biografia { get; set; }

        public float? CalificacionPromedio { get; set; }
    }
}