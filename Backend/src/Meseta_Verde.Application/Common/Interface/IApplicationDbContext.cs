using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verda.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using System.Threading;


namespace Meseta_Verde.Application.Common.Interface
{
    public interface IApplicationDbContext
    {

        public interface IApplicationDbContext
        {
            DbSet<Categoria> Categorias { get; set; }
            Task<int> SaveChangesAsync(CancellationToken cancellationToken);
        }
    }
}