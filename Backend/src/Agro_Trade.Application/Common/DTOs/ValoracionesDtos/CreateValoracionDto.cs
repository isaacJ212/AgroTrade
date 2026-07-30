using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.ValoracionesDtos
{
    public class CreateValoracionDto
    {
        [Required]
        public int IdPedido { get; set; }

        [Required]
        public int IdProveedor { get; set; }

        [MaxLength(50)]
        public string? TipoValoracion { get; set; }

        [Required]
        [Range(1, 5, ErrorMessage = "La puntuación debe estar entre 1 y 5")]
        public int Puntuacion { get; set; }

        [MaxLength(500)]
        public string? Comentario { get; set; }
    }
}
