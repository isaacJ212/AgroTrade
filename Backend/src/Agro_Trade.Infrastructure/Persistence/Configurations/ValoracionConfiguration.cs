using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
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
            builder.Property(v => v.FechaValoracion).HasColumnName("fecha_valoracion").IsRequired();
            builder.Property(v => v.IdProveedor).HasColumnName("id_proveedor").IsRequired();

            builder.HasOne(v => v.Pedido)
               .WithMany(p => p.Valoraciones)
               .HasForeignKey(v => v.IdPedido)
               .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(v => v.UsuarioCliente)
               .WithMany(u => u.ValoracionesRealizadas)
               .HasForeignKey(v => v.IdUsuarioCliente)
               .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(v => v.Proveedor)
               .WithMany(p => p.ValoracionesRecibidas)
               .HasForeignKey(v => v.IdProveedor)
               .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
