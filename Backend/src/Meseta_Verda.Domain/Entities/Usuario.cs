using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class Usuario
    {
        
        [Key]
        public int IdUsuario { get; set; }

        public string NombreCompleto { get; set; } 
        public string Email { get; set; } 
        public string? PasswordHash { get; set; } 
        public bool IdentidadVerificada { get; set; }
        
        public string? OAuthProvider { get; set; }
        public string? OAuthProviderId { get; set; }
        public string? Telefono { get; set; }
        public string? DireccionBase { get; set; }
        public DateTime? FechaRegistro { get; set; }

        
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
        public virtual ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();
        public virtual ICollection<ConversacionParticipante> ConversacionParticipantes { get; set; } = new List<ConversacionParticipante>();
        public virtual ICollection<Valoracion> ValoracionesRealizadas { get; set; } = new List<Valoracion>();
    }
}