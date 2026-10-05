using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class TipoPlanConfiguration : IEntityTypeConfiguration<TipoPlan>
    {
        public void Configure(EntityTypeBuilder<TipoPlan> builder)
        {
            builder.ToTable("tipos_planes");
            builder.HasKey(t => t.Id);

            builder.Property(t => t.NombrePlan).IsRequired().HasMaxLength(100);
            builder.Property(t => t.Precio).HasColumnType("decimal(18,2)");
            builder.Property(t => t.Coste).HasColumnType("decimal(18,2)");
            builder.Property(t => t.Descripcion).HasMaxLength(500);
            builder.Property(t => t.Beneficios).HasColumnType("text"); // JSON or long text
            builder.Property(t => t.IsActive).HasDefaultValue(true);
        }
    }
}
