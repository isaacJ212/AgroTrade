using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class RegistroTransferenciaMockConfiguration : IEntityTypeConfiguration<RegistroTransferenciaMock>
    {
        public void Configure(EntityTypeBuilder<RegistroTransferenciaMock> builder)
        {
            builder.ToTable("registros_transferencia_mock");
            builder.HasKey(t => t.IdTransferencia);
            builder.Property(t => t.MontoEnviado).HasPrecision(18, 2);

            builder.HasOne(t => t.Pedido)
                .WithMany(p => p.TransferenciasDistribuidas)
                .HasForeignKey(t => t.IdPedido)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
