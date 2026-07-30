using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class ConversacionConfiguration : IEntityTypeConfiguration<Conversacion>
    {
        public void Configure(EntityTypeBuilder<Conversacion> builder)
        {
            builder.ToTable("conversaciones");
            builder.HasKey(c => c.IdConversacion);

            builder.Property(c => c.CreadaEn).HasDefaultValueSql("now()");

            builder.HasMany(c => c.Participantes)
               .WithOne(cp => cp.Conversacion)
               .HasForeignKey(cp => cp.IdConversacion);

            builder.HasMany(c => c.Mensajes)
               .WithOne(m => m.Conversacion)
               .HasForeignKey(m => m.IdConversacion);

            builder.HasOne(c => c.Pedido)
               .WithMany()
               .HasForeignKey(c => c.IdPedido);
        }
    }
}
