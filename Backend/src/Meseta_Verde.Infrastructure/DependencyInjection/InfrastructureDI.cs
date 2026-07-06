using Meseta_Verde.Application.Interfaces;
using Meseta_Verde.Infrastructure.Persistence;
using Meseta_Verde.Infrastructure.Persistence.UnitofWork;
using Meseta_Verde.Infrastructure.Repository;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Infrastructure.DependencyInjection
{
    public static class InfrastructureDI
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services)
        {
            services.AddScoped<IUnitofWork,UnitOfWork>();
            services.AddScoped<IUserRepository, UserRepository>();
            return services;

        }
    }
}
