
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.ProveedoresDtos
{
    public class PatchProveedorDto
    {
        public int? IdUsuario { get; set; }
        [MaxLength(150)]
        public string? NombreProveedor { get; set; }
        [MaxLength(150)]
        public string? NombreFinca { get; set; }
        public string? UbicacionGps { get; set; }
        public string? Biografia { get; set; }
        public float? CalificacionPromedio { get; set; }
    }
}
