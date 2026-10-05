
using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class SuscripcionAppConfiguration : IEntityTypeConfiguration<SuscripcionApp>
    {
        public void Configure(EntityTypeBuilder<SuscripcionApp> builder)
        {
            builder.ToTable("suscripciones_app");
            builder.HasKey(s => s.IdSuscripcionApp);

            builder.HasOne(s => s.TipoPlan)
               .WithMany()
               .HasForeignKey(s => s.IdPlan)
               .IsRequired();
            builder.Property(s => s.CreadaEn).HasDefaultValueSql("now()");
            builder.Property(s => s.RenovacionAutomatica).HasDefaultValue(true);
            
            builder.HasOne(d => d.Plan)
                .WithMany() 
                .HasForeignKey(d => d.IdTipoPlan);


            builder.HasOne(s => s.Usuario)
               .WithMany()
               .HasForeignKey(s => s.IdUsuario);
        }
    }
}
