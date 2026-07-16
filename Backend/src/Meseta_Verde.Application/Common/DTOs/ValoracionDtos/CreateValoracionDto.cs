using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.DTOs.ValoracionDtos
{
    public class CreateValoracionDto
    {
        public int IdUsuario { get; set; }
        public int IdProveedor { get; set; }
        public int Puntaje { get; set; } 
        public string? Comentario { get; set; }
    }
}