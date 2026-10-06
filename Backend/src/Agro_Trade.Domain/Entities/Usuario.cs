using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class Usuario
    {
        
        [Key]
        public int IdUsuario { get; set; }

        // Jafet: Se dividió el NombreCompleto en Nombres y Apellidos, dejando NombreCompleto solo de lectura
        public string Nombres { get; set; } = string.Empty;
        public string Apellidos { get; set; } = string.Empty;
        public string NombreCompleto => $"{Nombres} {Apellidos}".Trim();
        public string Email { get; set; } 
        public string? PasswordHash { get; set; } 
        public bool IdentidadVerificada { get; set; }
        
        public string EstadoCuenta { get; set; } = "Activo"; 
        public string? OAuthProvider { get; set; }
        public string? OAuthProviderId { get; set; }
        public string? Telefono { get; set; }
        public string? DireccionBase { get; set; }
        public string? Departamento { get; set; }
        public string? Municipio { get; set; }
        public DateTime? FechaRegistro { get; set; }

        
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
        public virtual ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();
        public virtual ICollection<ConversacionParticipante> ConversacionParticipantes { get; set; } = new List<ConversacionParticipante>();
        public virtual ICollection<Valoracion> ValoracionesRealizadas { get; set; } = new List<Valoracion>();
    }
}