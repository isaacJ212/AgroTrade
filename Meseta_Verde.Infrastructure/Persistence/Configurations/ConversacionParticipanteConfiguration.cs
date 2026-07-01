using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class ConversacionParticipanteConfiguration : IEntityTypeConfiguration<ConversacionParticipante>
    {
        public void Configure(EntityTypeBuilder<ConversacionParticipante> builder)
        {
            builder.ToTable("conversacion_participantes");
            builder.HasKey(cp => new { cp.IdConversacion, cp.IdUsuario });

            builder.HasOne(cp => cp.Usuario)
               .WithMany(u => u.ConversacionParticipantes)
               .HasForeignKey(cp => cp.IdUsuario);
        }
    }
}
