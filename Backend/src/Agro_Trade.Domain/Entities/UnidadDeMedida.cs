using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities;

public class UnidadDeMedida
{
    [Key]
    [Required]
    public int Id { get; set; }

    // kilogramo
    public string Nombre { get; set; } = null!;
    // Kg
    public string Codigo { get; set; } = null!;
    // 1 kilogramo → 2 kilogramos
    public int Factor { get; set; }

    // ID de la unidad base (ej.: gramos para kilogramo); nullable porque algunas unidades son base
    public int? IdBase { get; set; }

    public ICollection<Producto> Productos { get; set; } = new List<Producto>();
}