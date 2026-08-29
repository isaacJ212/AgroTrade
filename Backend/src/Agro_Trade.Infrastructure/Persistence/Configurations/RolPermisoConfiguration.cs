using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class RolPermisoConfiguration : IEntityTypeConfiguration<RolPermiso>
    {
        public void Configure(EntityTypeBuilder<RolPermiso> builder)
        {
            builder.ToTable("roles_permisos");
            builder.HasKey(rp => new { rp.IdRol, rp.IdPermisos });
        }
    }
}
