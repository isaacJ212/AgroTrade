using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities;

public class UnidadDeMedida
{
    [Key]
    [Required]
    public int Id { get; set; }

    //kilogramo
    public string Nombre { get; set; }
    // Kg
    public string Codigo { get; set; }
    // 1 kilogramo 2 kilogramos
    public int Factor { get; set; }
    
    //POR EJEMPLO EL ID 1 SERIA GRAMOS QUE SERIA LA BASE DE KILOGRAMO
    public int? IdBase { get; set; }// base 1 osea kilogramo
    //nullable por que hay algunos que no necesitan base 
    
    

}