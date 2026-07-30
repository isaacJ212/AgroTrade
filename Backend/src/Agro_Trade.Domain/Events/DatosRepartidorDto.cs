using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Domain.Events
{
    public class DatosRepartidorDto
    {
        //Regex Nicaragua Ceula
      
        public string NumeroCedula { get; set; } = string.Empty;
       
        public string PlacaVehiculo { get; set; }= string.Empty;
        public string TipoVehiculo { get; set; }= string.Empty;
        public string MarcaVehiculo { get; set; }= string.Empty;
        public string ZonaOperaciones { get; set; }= string.Empty;
        public string Departamento { get; set; }= string.Empty;
        public string UrlFotoPerfil { get; set; } = string.Empty;
        public string UrlFotoCedula { get; set; } = string.Empty;
        
        public string UrlRecordPolicial { get; set; } = string.Empty;
       
        public string UrlLicencia { get; set; } = string.Empty;
       
        public string BancoNombre { get; set; } = string.Empty;
        
        public string NumeroCuenta { get; set; } = string.Empty;



    }
}
