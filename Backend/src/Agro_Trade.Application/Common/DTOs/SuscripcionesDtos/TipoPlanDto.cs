namespace Agro_Trade.Application.Common.DTOs.SuscripcionesDtos
{
    public class TipoPlanDto
    {
        public int Id { get; set; }
        public string NombrePlan { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public decimal Coste { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public string Beneficios { get; set; } = string.Empty;
        public bool IsActive { get; set; }
    }
}
