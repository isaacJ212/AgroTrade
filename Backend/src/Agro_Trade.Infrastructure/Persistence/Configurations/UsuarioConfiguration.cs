using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class UsuarioConfiguration : IEntityTypeConfiguration<Usuario>
    {
        public void Configure(EntityTypeBuilder<Usuario> builder)
        {
            builder.ToTable("usuarios");
            builder.HasKey(u => u.IdUsuario);

            builder.Property(u => u.Email).IsRequired().HasMaxLength(255);
            builder.Property(u => u.NombreCompleto).IsRequired().HasMaxLength(200);
            builder.HasIndex(u => u.Email).IsUnique();

            builder.HasMany(u => u.UsuariosRoles)
               .WithOne(ur => ur.Usuario)
               .HasForeignKey(ur => ur.IdUsuario);

            builder.HasMany(u => u.Pedidos)
               .WithOne(p => p.UsuarioCliente)
               .HasForeignKey(p => p.IdUsuarioCliente);
        }
    }
}