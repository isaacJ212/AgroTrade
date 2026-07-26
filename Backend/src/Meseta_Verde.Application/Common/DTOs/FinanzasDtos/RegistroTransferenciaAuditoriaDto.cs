namespace Meseta_Verde.Application.Common.DTOs.FinanzasDtos
{
    public class RegistroTransferenciaAuditoriaDto
    {
        public string IdTransferencia { get; set; } = string.Empty;
        public int IdPedido { get; set; }
        public decimal TotalPedido { get; set; }
        public string Proveedor { get; set; } = string.Empty;
        public string BancoDestino { get; set; } = string.Empty;
        public string Cuenta { get; set; } = string.Empty;
        public decimal MontoEnviado { get; set; }
        public string Estado { get; set; } = string.Empty;
    }
}
