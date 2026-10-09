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

        public string Nombre {get; set;}
        public string PrimerApellido{get;set;}
        public string SegundoApellido {get;set;}
        public string Email { get; set; } 
        public string? PasswordHash { get; set; } 
        public bool IdentidadVerificada { get; set; }
        
        public string EstadoCuenta { get; set; } = "Activo"; 
        public string? OAuthProvider { get; set; }
        public string? OAuthProviderId { get; set; }
        public string? Telefono { get; set; }
        public string? Departamento { get; set; }
        public string? Municipio { get; set; }

        public string? DireccionExacta { get; set; } // esta es para tipo de las chancha repato x cuadras 

        public DateTime? FechaRegistro { get; set; }

        public virtual ICollection<Pedido> Pedidos { get; set; } = new List<Pedido>();
        public virtual ICollection<UsuarioRol> UsuariosRoles { get; set; } = new List<UsuarioRol>();
        public virtual ICollection<ConversacionParticipante> ConversacionParticipantes { get; set; } = new List<ConversacionParticipante>();
        public virtual ICollection<Valoracion> ValoracionesRealizadas { get; set; } = new List<Valoracion>();
        public virtual ICollection<Valoracion> ValoracionesRecibidas { get; set; } = new List<Valoracion>();
    }
}