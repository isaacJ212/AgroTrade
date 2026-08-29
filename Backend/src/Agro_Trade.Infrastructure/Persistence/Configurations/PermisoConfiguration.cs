using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class PermisoConfiguration : IEntityTypeConfiguration<Permiso>
    {
        public void Configure(EntityTypeBuilder<Permiso> builder)
        {
            builder.ToTable("permisos");
            builder.HasKey(p => p.IdPermiso);

            builder.HasMany(p => p.RolesPermisos)
               .WithOne(rp => rp.Permiso)
               .HasForeignKey(rp => rp.IdPermisos);
        }
    }
}
