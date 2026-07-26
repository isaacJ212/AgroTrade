using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verda.Domain.Entities
{
    public class Repartidor
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public int IdUsuario { get; set; }
        [ForeignKey("IdUsuario")]
        public Usuario Usuario { get; set; } 
        public string PlacaVehiculo { get; set; } = string.Empty;
        public string Estado { get; set; } = "DISPONIBLE"; // "EN ENTREGA", "DISPONIBLE", "NO DISPONIBLE"
        public string Vehiculo { get; set; } = string.Empty;
        public decimal PromedioCalificacion { get; set; }
        public string CuentaBancaria { get; set; } = string.Empty;
        public string UrlFotoPerfil { get; set; } = string.Empty;
        public string ZonaOperaciones { get; set; } = string.Empty;
        public string Departamento { get; set;} = string.Empty;



    }
}
