using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class LogisticaEntregaConfiguration : IEntityTypeConfiguration<LogisticaEntrega>
    {
        public void Configure(EntityTypeBuilder<LogisticaEntrega> builder)
        {
            builder.ToTable("logistica_entregas");
            builder.HasKey(l => l.IdEntrega);
            builder.HasIndex(l => l.IdPedido).IsUnique();

            builder.HasOne(l => l.Pedido)
               .WithMany()
               .HasForeignKey(l => l.IdPedido);

            builder.HasOne(l => l.UsuarioRepartidor)
               .WithMany()
               .HasForeignKey(l => l.IdUsuarioRepartidor);
        }
    }
}
