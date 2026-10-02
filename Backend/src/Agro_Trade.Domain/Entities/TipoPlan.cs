using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities;

public class TipoPlan
{
    [Key]
    public int Id { get; set; }
    public string NombrePlan { get; set; }
    public decimal Precio { get; set; }
    public string Descripcion { get; set; }
    public bool IsActive { get; set; }
}