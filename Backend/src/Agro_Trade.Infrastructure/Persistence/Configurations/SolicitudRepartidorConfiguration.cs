using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class SolicitudRepartidorConfiguration : IEntityTypeConfiguration<SolicitudRepartidor>
    {
        public void Configure(EntityTypeBuilder<SolicitudRepartidor> builder)
        {
            builder.ToTable("solicitud_repartidor");
            builder.HasKey(p => p.IdSolicitud);
            builder.HasOne(p => p.Usuario).WithMany().HasForeignKey(P => P.IdUsuario);

            builder.Property(e => e.DatosRepartidor).HasColumnType("jsonb");
        }
    }
}
