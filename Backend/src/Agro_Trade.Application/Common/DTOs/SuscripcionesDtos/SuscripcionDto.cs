using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common.DTOs.SuscripcionesDtos
{
    public class SuscripcionDto
    {
        public int IdSuscripcionApp { get; set; }
        public int IdUsuario { get; set; }
        public string TipoPlan { get; set; } = string.Empty;
        public decimal TarifaPago { get; set; }
        public string? Estado { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public bool RenovacionAutomatica { get; set; }
        public DateTime CreadaEn { get; set; }
    }
}