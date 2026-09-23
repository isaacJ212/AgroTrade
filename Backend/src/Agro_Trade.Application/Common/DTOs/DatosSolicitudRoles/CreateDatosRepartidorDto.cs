using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles
{
    public class CreateDatosRepartidorDto
    {
        //Regex Nicaragua Ceula
        [Required(ErrorMessage ="El número de cédula es obligatorio.")]
        [RegularExpression(@"^[0-9]{3}-[0-9]{6}-[0-9]{4}[A-Za-z]$",
        ErrorMessage = "La cédula debe tener el formato oficial con guiones (ej. 001-120794-0005A).")]
        public string NumeroCedula { get; set; } = string.Empty;


        [RegularExpression(@"^[A-Za-z]{1,2}[- ]?[0-9]{3,6}$",
        ErrorMessage = "El formato de placa nicaragüense no es válido (ej. M-123456 o CZ-1234).")]
        public string PlacaVehiculo { get; set; }= string.Empty;


        [Required(ErrorMessage = "El tipo de vehículo es obligatorio.")]
        public string TipoVehiculo { get; set; }= string.Empty;


        [Required(ErrorMessage = "La foto de la cédula es obligatoria.")] 
        public IFormFile UrlFotoCedula { get; set; } = null!;


        [Required(ErrorMessage = "La foto de perfil es obligatoria.")]
        public IFormFile UrlFotoPerfil { get; set; } = null!;


        [Required(ErrorMessage = "La foto del Record Policial es obligatoria.")]
        public IFormFile UrlRecordPolicial { get; set; } = null!;


        [Required(ErrorMessage = "La foto de la licencia es obligatoria.")]
        public IFormFile UrlLicencia { get; set; } = null!;


        [Required(ErrorMessage = "El nombre del banco es obligatorio.")]
        public string BancoNombre { get; set; } = string.Empty;


        [Required(ErrorMessage = "El número de cuenta es obligatorio.")]
        public string NumeroCuenta { get; set; } = string.Empty;

        [Required(ErrorMessage = "La marca del vehículo es obligatoria.")]
        public string MarcaVehiculo { get; set; } = string.Empty;
        [Required(ErrorMessage = "La zona de operaciones es obligatoria.")]
        public string ZonaOperaciones { get; set; } = string.Empty;
        [Required(ErrorMessage = "El Departamento de operaciones es obligatoria.")]
        public string Departamento { get; set; } = string.Empty;



    }
}
