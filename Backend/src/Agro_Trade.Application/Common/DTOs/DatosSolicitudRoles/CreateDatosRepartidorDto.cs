using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles
{
    public class CreateDatosRepartidorDto
    {
        private string _numeroCedula = string.Empty;

        //Regex Nicaragua Ceula
        [Required(ErrorMessage = "El número de cédula es obligatorio.")]
        [RegularExpression(@"^[0-9]{3}-[0-9]{6}-[0-9]{4}[A-Za-z]$",
        ErrorMessage = "La cédula debe tener el formato oficial con guiones (ej. 001-120794-0005A).")]
        public string NumeroCedula
        {
            get => _numeroCedula;
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                {
                    _numeroCedula = string.Empty;
                    return;
                }

                // Remove any existing dashes/spaces
                var clean = value.Replace("-", "").Replace(" ", "").Trim().ToUpper();

                // If it's 14 characters (3+6+4+1), format it with dashes
                if (clean.Length == 14 && Regex.IsMatch(clean, @"^[0-9]{13}[A-Za-z]$"))
                {
                    _numeroCedula = $"{clean.Substring(0, 3)}-{clean.Substring(3, 6)}-{clean.Substring(9, 4)}{clean.Substring(13, 1)}";
                }
                else
                {
                    _numeroCedula = value;
                }
            }
        }


        [RegularExpression(@"^[A-Za-z]{1,2}[- ]?[0-9]{3,6}$",
        ErrorMessage = "El formato de placa nicaragüense no es válido (ej. M-123456 o CZ-1234).")]
        public string PlacaVehiculo { get; set; }= string.Empty;


        [Required(ErrorMessage = "El tipo de vehículo es obligatorio.")]
        public string TipoVehiculo { get; set; }= string.Empty;


        [Required(ErrorMessage = "La foto de la cédula es obligatoria.")] 
        public IFormFile FotoCedula { get; set; } = null!;


        [Required(ErrorMessage = "La foto de perfil es obligatoria.")]
        public IFormFile FotoPerfil { get; set; } = null!;


        [Required(ErrorMessage = "La foto del Record Policial es obligatoria.")]
        public IFormFile RecordPolicial { get; set; } = null!;


        [Required(ErrorMessage = "La foto de la licencia es obligatoria.")]
        public IFormFile FotoLicencia { get; set; } = null!;




        [Required(ErrorMessage = "El número de cuenta es obligatorio.")]
        public int IdCuentaBancaria { get; set; }

        [Required(ErrorMessage = "La marca del vehículo es obligatoria.")]
        public string MarcaVehiculo { get; set; } = string.Empty;
        [Required(ErrorMessage = "El municipio de operaciones es obligatorio.")]
        public string Municipio { get; set; } = string.Empty;
        [Required(ErrorMessage = "El Departamento de operaciones es obligatoria.")]
        public string Departamento { get; set; } = string.Empty;



    }
}
