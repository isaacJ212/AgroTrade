using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class ProductoConfiguration : IEntityTypeConfiguration<Producto>
    {
        public void Configure(EntityTypeBuilder<Producto> builder)
        {
            builder.ToTable("productos");
            builder.HasKey(p => p.IdProducto);

            builder.Property(p => p.Nombre).IsRequired().HasMaxLength(200);
            builder.Property(p => p.UnidadMedida).IsRequired().HasMaxLength(50);

            builder.HasMany(p => p.Inventarios)
               .WithOne(i => i.Producto)
               .HasForeignKey(i => i.IdProducto);

            builder.HasOne(p => p.Categoria)
               .WithMany(c => c.Productos)
               .HasForeignKey(p => p.IdCategoria);

            builder.HasOne(p => p.Proveedor)
               .WithMany(pv => pv.Productos)
               .HasForeignKey(p => p.IdProveedor);
        }
    }
}
