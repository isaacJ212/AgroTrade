using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class ValoracionConfiguration : IEntityTypeConfiguration<Valoracion>
    {
        public void Configure(EntityTypeBuilder<Valoracion> builder)
        {
            builder.ToTable("valoraciones");
            builder.HasKey(v => v.IdValoracion);

            builder.Property(v => v.TipoValoracion).HasColumnName("tipo_valoracion");
            builder.Property(v => v.Puntuacion).HasColumnName("puntuacion").IsRequired();
            builder.Property(v => v.Comentario).HasColumnName("comentario");

            builder.HasOne(v => v.Pedido)
               .WithMany()
               .HasForeignKey(v => v.IdPedido);

            builder.HasOne(v => v.UsuarioCliente)
               .WithMany()
               .HasForeignKey(v => v.IdUsuarioCliente);
        }
    }
}
