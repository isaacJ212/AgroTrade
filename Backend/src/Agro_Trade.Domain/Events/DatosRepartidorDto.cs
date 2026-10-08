using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;

namespace Agro_Trade.Domain.Events
{
    public class DatosRepartidorDto
    {
        //Regex Nicaragua Ceula
       
        public string NumeroCedula { get; set; } = string.Empty;
       
        public string PlacaVehiculo { get; set; }= string.Empty;
        public string TipoVehiculo { get; set; }= string.Empty;
        public string MarcaVehiculo { get; set; }= string.Empty;
        
        [JsonPropertyName("Municipio")]
        public string Municipio { get; set; } = string.Empty;
        
        // Compatibilidad hacia atrás con registros existentes en jsonb
        [JsonPropertyName("ZonaOperaciones")]
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        [Obsolete("Usar Municipio. Mantenido para compatibilidad con datos existentes.")]
        public string ZonaOperaciones 
        { 
            get => Municipio; 
            set => Municipio = value; 
        }
        
        public string Departamento { get; set; }= string.Empty;
        public string UrlFotoPerfil { get; set; } = string.Empty;
        public string UrlFotoCedula { get; set; } = string.Empty;
        
        public string UrlRecordPolicial { get; set; } = string.Empty;
       
        public string UrlLicencia { get; set; } = string.Empty;
       
        public int IdCuentaBancaria { get; set; }
    }
}