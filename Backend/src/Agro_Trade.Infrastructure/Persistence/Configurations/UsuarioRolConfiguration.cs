using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class UsuarioRolConfiguration : IEntityTypeConfiguration<UsuarioRol>
    {
        public void Configure(EntityTypeBuilder<UsuarioRol> builder)
        {
            builder.ToTable("usuarios_roles");
            builder.HasKey(ur => new { ur.IdUsuario, ur.IdRol });

            builder.HasOne(ur => ur.Usuario)
               .WithMany(u => u.UsuariosRoles)
               .HasForeignKey(ur => ur.IdUsuario);

            builder.HasOne(ur => ur.Rol)
               .WithMany(r => r.UsuariosRoles)
               .HasForeignKey(ur => ur.IdRol);
        }
    }
}
