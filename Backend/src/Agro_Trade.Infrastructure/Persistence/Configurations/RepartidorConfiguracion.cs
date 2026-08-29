using Agro_Trade.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Infrastructure.Persistence.Configurations
{
    public class RepartidorConfiguracion : IEntityTypeConfiguration<Repartidor>
    {
        public void Configure(EntityTypeBuilder<Repartidor> builder)
        {
            builder.ToTable("repartidor");
            builder.HasKey(p=>p.Id);

            builder.HasOne(p=>p.Usuario).WithMany().HasForeignKey(p=> p.IdUsuario);
        }
    }
}
