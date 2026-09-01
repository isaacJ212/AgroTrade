using System;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class Actividad
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Title { get; set; }

        public string? IconType { get; set; } 
        public string? IconClass { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
