using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class UnidadDeMedidaConfiguration : IEntityTypeConfiguration<UnidadDeMedida>
    {
        public void Configure(EntityTypeBuilder<UnidadDeMedida> builder)
        {
            builder.ToTable("unidades_de_medida");
            builder.HasKey(u => u.Id);

            builder.Property(u => u.Nombre).IsRequired().HasMaxLength(100);
            builder.Property(u => u.Codigo).IsRequired().HasMaxLength(20);

            // Catálogo canónico — IDs fijos para compatibilidad con clientes
            builder.HasData(
                new UnidadDeMedida { Id = 1, Nombre = "Kilogramo",  Codigo = "kg",  Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 2, Nombre = "Gramo",      Codigo = "g",   Factor = 1000, IdBase = 1 },
                new UnidadDeMedida { Id = 3, Nombre = "Libra",      Codigo = "lb",  Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 4, Nombre = "Quintal",    Codigo = "qq",  Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 5, Nombre = "Unidad",     Codigo = "und", Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 6, Nombre = "Litro",      Codigo = "L",   Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 7, Nombre = "Mililitro",  Codigo = "mL",  Factor = 1000, IdBase = 6 },
                new UnidadDeMedida { Id = 8, Nombre = "Docena",     Codigo = "dz",  Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 9, Nombre = "Caja",       Codigo = "cj",  Factor = 1, IdBase = null },
                new UnidadDeMedida { Id = 10, Nombre = "Tonelada",  Codigo = "t",   Factor = 1, IdBase = null }
            );
        }
    }
}
