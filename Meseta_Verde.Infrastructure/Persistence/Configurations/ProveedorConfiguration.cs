using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class ProveedorConfiguration : IEntityTypeConfiguration<Proveedor>
    {
        public void Configure(EntityTypeBuilder<Proveedor> builder)
        {
            builder.ToTable("proveedores");
            builder.HasKey(p => p.IdProveedor);

            builder.Property(p => p.NombreProveedor).IsRequired().HasMaxLength(150);
            builder.Property(p => p.NombreFinca).HasMaxLength(150);

            builder.HasOne(p => p.Usuario)
               .WithMany()
               .HasForeignKey(p => p.IdUsuario);
        }
    }
}
