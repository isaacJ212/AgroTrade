using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class RolConfiguration : IEntityTypeConfiguration<Rol>
    {
        public void Configure(EntityTypeBuilder<Rol> builder)
        {
            builder.ToTable("Roles");
            builder.HasKey(r => r.IdRol);

            builder.Property(r => r.NombreRol).IsRequired().HasMaxLength(100);

            builder.HasMany(r => r.UsuariosRoles)
               .WithOne(ur => ur.Rol)
               .HasForeignKey(ur => ur.IdRol);

            builder.HasMany(r => r.RolesPermisos)
               .WithOne(rp => rp.Rol)
               .HasForeignKey(rp => rp.IdRol);
        }
    }
}
