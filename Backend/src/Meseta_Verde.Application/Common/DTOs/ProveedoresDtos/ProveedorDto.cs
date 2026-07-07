using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.ProveedoresDtos
{
    public class ProveedorDto
    {
        public int IdProveedor {get;set;}
        public int IdUsuario {get;set;}
        public string? NombreProveedor {get;set;}
        public string? NombreFinca {get;set;}
        public string? UbicacionGps {get;set;}
        public string? Biografia {get;set;}
        public float? CalificacionPromedio {get;set;}

    }
}