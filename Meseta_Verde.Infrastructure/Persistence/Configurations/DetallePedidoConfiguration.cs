using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class DetallePedidoConfiguration : IEntityTypeConfiguration<DetallePedido>
    {
        public void Configure(EntityTypeBuilder<DetallePedido> builder)
        {
            builder.ToTable("detalles_pedido");
            builder.HasKey(d => d.IdDetallePedido);

            builder.HasOne(d => d.Pedido)
               .WithMany(p => p.Detalles)
               .HasForeignKey(d => d.IdPedido);

            builder.HasOne(d => d.Inventario)
               .WithMany(i => i.DetallesPedido)
               .HasForeignKey(d => d.IdInventario);
        }
    }
}
