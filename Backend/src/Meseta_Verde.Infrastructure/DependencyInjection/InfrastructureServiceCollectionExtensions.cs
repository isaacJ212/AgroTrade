using EFCore.NamingConventions;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Infrastructure.Persistence;
using Meseta_Verde.Infrastructure.Repository;
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

            services.AddScoped<IApplicationDbContext>(provider =>
                provider.GetRequiredService<MesetaVerdeDbContext>());

            services.AddScoped<IUnitOfWork, UnitOfWork>();

            return services;
        }
    }
}