using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class NotificacionEntrega
    {
        [Key]
        public int IdNotificacion { get; set; }
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;
        public int IdUsuarioRepartidor { get; set; }
        public Usuario UsuarioRepartidor { get; set; } = null!;
        public string ZonaEntrega { get; set; } = string.Empty;
        public string Estado { get; set; } = "PENDIENTE";
        public DateTime FechaCreacion { get; set; } = DateTime.UtcNow;
    }
}
