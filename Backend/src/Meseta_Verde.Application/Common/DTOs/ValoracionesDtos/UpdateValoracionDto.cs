using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.ValoracionesDtos
{
    public class UpdateValoracionDto
    {
        [Range(1, 5, ErrorMessage = "La puntuación debe estar entre 1 y 5")]
        public int? Puntuacion { get; set; }

        [MaxLength(500)]
        public string? Comentario { get; set; }
    }
}
