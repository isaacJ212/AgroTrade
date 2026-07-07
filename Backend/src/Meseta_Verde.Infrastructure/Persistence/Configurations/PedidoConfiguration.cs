using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class PedidoConfiguration : IEntityTypeConfiguration<Pedido>
    {
        public void Configure(EntityTypeBuilder<Pedido> builder)
        {
            builder.ToTable("pedidos");
            builder.HasKey(p => p.IdPedido);

            builder.HasOne(p => p.UsuarioCliente)
               .WithMany(u => u.Pedidos)
               .HasForeignKey(p => p.IdUsuarioCliente);

            builder.HasMany(p => p.Detalles)
               .WithOne(d => d.Pedido)
               .HasForeignKey(d => d.IdPedido);
        }
    }
}
