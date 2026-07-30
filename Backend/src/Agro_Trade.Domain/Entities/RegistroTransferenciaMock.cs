using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Domain.Entities
{
    public class RegistroTransferenciaMock
    {
        [Key]
        [MaxLength(64)]
        public string IdTransferencia { get; set; } = null!;

        public int IdPedido { get; set; }
        public Pedido Pedido { get; set; } = null!;

        [MaxLength(150)]
        public string Proveedor { get; set; } = null!;

        [MaxLength(100)]
        public string BancoDestino { get; set; } = null!;

        [MaxLength(100)]
        public string Cuenta { get; set; } = null!;

        public decimal MontoEnviado { get; set; }

        [MaxLength(50)]
        public string Estado { get; set; } = null!;
    }
}
