using Agro_Trade.Domain.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.DatosSolicitudRoles
{
    public class SolicitudRepartidorDto
    {
        public int IdSolicitud { get; set; }
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; } = string.Empty;
        public DatosRepartidorDto DatosRepartidor { get; set; }
        public string Estado { get; set; }
        public DateTime FechaSolicitud { get; set; }
        public string Departamento { get; set; }
    }
}
