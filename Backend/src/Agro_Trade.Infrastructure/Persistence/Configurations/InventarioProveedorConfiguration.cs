using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class InventarioProveedorConfiguration : IEntityTypeConfiguration<InventarioProveedor>
    {
        public void Configure(EntityTypeBuilder<InventarioProveedor> builder)
        {
            builder.ToTable("inventario_proveedor");
            builder.HasKey(i => i.IdInventario);

            builder.HasOne(i => i.Producto)
               .WithMany(p => p.Inventarios)
               .HasForeignKey(i => i.IdProducto);

            builder.HasOne(i => i.Proveedor)
               .WithMany(p => p.Inventarios)
               .HasForeignKey(i => i.IdProveedor);

            builder.HasMany(i => i.DetallesPedido)
               .WithOne(d => d.Inventario)
               .HasForeignKey(d => d.IdInventario);

            builder.Property(i => i.EsOfertaExcedente).HasDefaultValue(false);
            builder.Property(i => i.Disponible).HasDefaultValue(true);
        }
    }
}
