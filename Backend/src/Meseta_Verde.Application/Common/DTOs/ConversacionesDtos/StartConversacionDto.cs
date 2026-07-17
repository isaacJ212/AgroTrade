using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace Meseta_Verde.Application.Common.DTOs.ConversacionesDtos
{
    public class StartConversacionDto
    {
        [Required(ErrorMessage = "El ID del pedido es obligatorio.")]
        public int IdPedido { get; set; }

        [Required(ErrorMessage = "El ID del cliente es obligatorio.")]
        public int IdUsuarioCliente { get; set; }

        [Required(ErrorMessage = "El ID del proveedor/repartidor es obligatorio.")]
        public int IdUsuarioReceptor { get; set; }
    }
}