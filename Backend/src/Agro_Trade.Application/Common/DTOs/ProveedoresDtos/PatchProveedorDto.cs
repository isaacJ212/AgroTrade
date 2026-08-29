
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ProveedoresDtos
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
