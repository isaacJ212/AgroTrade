using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class MensajeConfiguration : IEntityTypeConfiguration<Mensaje>
    {
        public void Configure(EntityTypeBuilder<Mensaje> builder)
        {
            builder.ToTable("mensajes");
            builder.HasKey(m => m.IdMensaje);

            builder.Property(m => m.Contenido).IsRequired();
            builder.Property(m => m.EnviadoEn).HasDefaultValueSql("now()");
            builder.Property(m => m.Leido).HasDefaultValue(false);
            builder.Property(m => m.IdUsuarioEmisor).HasColumnName("id_emisor");

            builder.HasOne(m => m.Emisor)
               .WithMany()
               .HasForeignKey(m => m.IdUsuarioEmisor);

            builder.HasOne(m => m.Conversacion)
               .WithMany(c => c.Mensajes)
               .HasForeignKey(m => m.IdConversacion);
        }
    }
}
