using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Agro_Trade.Domain.Entities
{
    public class SuscripcionApp
    {
        [Key]
        public int IdSuscripcionApp { get; set; }
        
        public int IdUsuario { get; set; }
        public Usuario Usuario { get; set; } = null!;
        
        [Required]
        public int IdPlan { get; set; }
        [ForeignKey("IdPlan")]
        public TipoPlan Plan { get; set; }
        public decimal TarifaPago { get; set; }
        public string? Estado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public bool RenovacionAutomatica { get; set; } = true;
        public DateTime CreadaEn { get; set; } = DateTime.UtcNow;
    }
}