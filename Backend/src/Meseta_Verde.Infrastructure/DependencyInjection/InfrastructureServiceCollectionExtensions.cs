using EFCore.NamingConventions;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Infrastructure.Persistence;
using Meseta_Verde.Infrastructure.Persistence.UnitofWork;
using Meseta_Verde.Infrastructure.Repository;
using Meseta_Verde.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Meseta_Verde.Infrastructure.DependencyInjection
{
    public static class InfrastructureServiceCollectionExtensions
    {
        public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
        {
            var connectionString = configuration.GetConnectionString("MesetaVerdeDatabase")
                ?? configuration.GetConnectionString("DefaultConnection");

            services.AddDbContext<MesetaVerdeDbContext>(options =>
                options.UseNpgsql(connectionString)
                       .UseSnakeCaseNamingConvention());

           
            services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
            services.AddScoped<ITokenServices, TokenServices>();
            services.AddScoped<IUnitofWork, UnitOfWork>();

            return services;
        }
    }
}