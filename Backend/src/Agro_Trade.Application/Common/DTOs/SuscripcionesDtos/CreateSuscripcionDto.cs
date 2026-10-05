using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.SuscripcionesDtos
{
    public class CreateSuscripcionDto
    {
        [Required(ErrorMessage = "El ID del usuario es obligatorio.")]
        public int IdUsuario { get; set; }

<<<<<<< HEAD
        [Required(ErrorMessage = "El tipo de plan es obligatorio.")]
        public int TipoPlan { get; set; }
=======
        public int IdPlan { get; set; }
>>>>>>> f9cee1e4a6d9d324d3d908dc89f2268a03844f10

        [Required(ErrorMessage = "La tarifa es obligatoria.")]
        public decimal TarifaPago { get; set; }
        
        [Required(ErrorMessage = "Los meses de duración son obligatorios.")]
        public int MesesDuracion { get; set; }
    }
}