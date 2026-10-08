namespace Agro_Trade.Application.Common.DTOs.UnidadesDeMedidaDtos
{
    public class UnidadDeMedidaDto
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = null!;
        public string Codigo { get; set; } = null!;
        public int Factor { get; set; }
        public int? IdBase { get; set; }
    }
}
