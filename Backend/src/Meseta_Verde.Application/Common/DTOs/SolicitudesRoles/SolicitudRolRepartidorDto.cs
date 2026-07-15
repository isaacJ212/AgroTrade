using Meseta_Verda.Domain.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.SolicitudesRoles
{
    public class SolicitudRolRepartidorDto
    {
        public int IdSolicitud { get; set; }
        public int IdUsuario { get; set; }
        public string NombreUsuario { get; set; } = string.Empty;
        public DatosRepartidorDto DatosRepartidor { get; set; }
        public string Estado { get; set; }
        public DateTime FechaSolicitud { get; set; }
    }
}