using System;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class TipoPlan
    {
        [Key]
        public int Id { get; set; }
        public string NombrePlan { get; set; } = null!;
        public string? Descripcion { get; set; }
        public string Beneficios { get; set; } = null!;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public bool IsActive { get; set; } = true;
    }
}
