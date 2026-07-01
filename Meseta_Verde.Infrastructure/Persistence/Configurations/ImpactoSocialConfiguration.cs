using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class ImpactoSocialConfiguration : IEntityTypeConfiguration<ImpactoSocial>
    {
        public void Configure(EntityTypeBuilder<ImpactoSocial> builder)
        {
            builder.ToTable("impacto_social");
            builder.HasKey(i => i.IdImpacto);

            builder.HasOne(i => i.Pedido)
               .WithMany()
               .HasForeignKey(i => i.IdPedido);

            builder.HasOne(i => i.Proveedor)
               .WithMany()
               .HasForeignKey(i => i.IdProveedor);

            builder.HasOne(i => i.DetallePedido)
               .WithMany()
               .HasForeignKey(i => i.IdDetallePedido);
        }
    }
}
