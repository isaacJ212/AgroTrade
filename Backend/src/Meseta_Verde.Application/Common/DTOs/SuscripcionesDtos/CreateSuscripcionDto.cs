using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.SuscripcionesDtos
{
    public class CreateSuscripcionDto
    {
        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int IdUsuario { get; set; }

        [Required(ErrorMessage = "El tipo de plan es obligatorio.")]
        public string TipoPlan { get; set; } = string.Empty;

        [Required(ErrorMessage = "La tarifa es obligatoria.")]
        public decimal TarifaPago { get; set; }
        
        [Required(ErrorMessage = "Los meses de duración son obligatorios.")]
        public int MesesDuracion { get; set; }
    }
}