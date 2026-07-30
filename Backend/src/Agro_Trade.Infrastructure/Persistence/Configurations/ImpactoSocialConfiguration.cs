using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class ImpactoSocialConfiguration : IEntityTypeConfiguration<ImpactoSocial>
    {
        public void Configure(EntityTypeBuilder<ImpactoSocial> builder)
        {
            builder.ToTable("impacto_social");
            builder.HasKey(i => i.IdImpacto);

            builder.HasOne(i => i.Pedido)
               .WithMany(p => p.ImpactosSociales)
               .HasForeignKey(i => i.IdPedido);

            builder.HasOne(i => i.Proveedor)
               .WithMany(p => p.ImpactosSociales)
               .HasForeignKey(i => i.IdProveedor);

            builder.HasOne(i => i.DetallePedido)
               .WithOne(d => d.ImpactoSocial)
               .HasForeignKey<ImpactoSocial>(i => i.IdDetallePedido);
        }
    }
}
