using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Agro_Trade.Domain.Entities;

public class CuentaBancaria
{
    [Key]
    public int IdCuenta { get; set; }
    
    public int IdUsuario { get; set; } 
    public int IdBanco { get; set; }
    
    //props
    [ForeignKey("IdUsuario")]
    public Usuario Usuario { get; set; }
    [ForeignKey("IdBanco")]
    public Banco Banco { get; set; }
    
    required public string NumeroCuenta {get; set; } = string.Empty;
    public TimeSpan CreatedAt { get; set; }
    public string Titular { get; set; } = string.Empty;
    public bool isActive { get; set; }
    
    
}