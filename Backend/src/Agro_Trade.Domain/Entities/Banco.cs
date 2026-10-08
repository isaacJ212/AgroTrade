using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities;

public class Banco
{
    [Key]
    public int IdBanco { get; set; }

    public string NombreBanco { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    
}