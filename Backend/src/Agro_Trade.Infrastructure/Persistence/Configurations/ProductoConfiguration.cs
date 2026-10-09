using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class ProductoConfiguration : IEntityTypeConfiguration<Producto>
    {
        public void Configure(EntityTypeBuilder<Producto> builder)
        {
            builder.ToTable("productos");
            builder.HasKey(p => p.IdProducto);

            builder.Property(p => p.Nombre).IsRequired().HasMaxLength(200);

            builder.HasMany(p => p.Inventarios)
               .WithOne(i => i.Producto)
               .HasForeignKey(i => i.IdProducto);

            builder.HasOne(p => p.Categoria)
               .WithMany(c => c.Productos)
               .HasForeignKey(p => p.IdCategoria);

            builder.HasOne(p => p.Proveedor)
               .WithMany(pv => pv.Productos)
               .HasForeignKey(p => p.IdProveedor);

            builder.HasOne(p => p.UnidadDeMedida)
               .WithMany(u => u.Productos)
               .HasForeignKey(p => p.IdUnidadDeMedida)
               .OnDelete(DeleteBehavior.Restrict);
        }
    }
}

