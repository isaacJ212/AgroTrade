using System;

namespace Agro_Trade.Application.Common.DTOs.ValoracionesDtos
{
    public class ValoracionDto
    {
        public int IdValoracion { get; set; }
        public int IdPedido { get; set; }
        public int IdUsuarioCliente { get; set; }
        public string NombreCliente { get; set; } = string.Empty;
        public int IdProveedor { get; set; }
        public string NombreProveedor { get; set; } = string.Empty;
        public string? TipoValoracion { get; set; }
        public int Puntuacion { get; set; }
        public string? Comentario { get; set; }
        public DateTime FechaValoracion { get; set; }
    }
}
