using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verda.Domain.Entities
{
    public class Valoracion
    {
        [Key]
        public int IdValoracion { get; set; }
        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;

        public int IdUsuarioCliente { get; set; }
        public Usuario UsuarioCliente { get; set; } = null!;

        public string? TipoValoracion { get; set; }
        public int Puntuacion { get; set; }
        public string? Comentario { get; set; }
    }
}