using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Meseta_Verde.Infrastructure.Persistence.Configurations
{
    public class NotificacionEntregaConfiguration : IEntityTypeConfiguration<NotificacionEntrega>
    {
        public void Configure(EntityTypeBuilder<NotificacionEntrega> builder)
        {
            builder.ToTable("notificaciones_entrega");
            builder.HasKey(n => n.IdNotificacion);
            builder.Property(n => n.ZonaEntrega).HasMaxLength(200);
            builder.Property(n => n.Estado).HasMaxLength(20);
            builder.HasIndex(n => new { n.IdPedido, n.IdUsuarioRepartidor }).IsUnique();

            builder.HasOne(n => n.Pedido).WithMany().HasForeignKey(n => n.IdPedido);
            builder.HasOne(n => n.UsuarioRepartidor).WithMany().HasForeignKey(n => n.IdUsuarioRepartidor);
        }
    }
}
