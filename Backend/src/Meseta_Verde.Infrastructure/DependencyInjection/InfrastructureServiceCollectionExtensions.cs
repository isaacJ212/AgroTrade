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
            //configuracion de posgres``
            var connectionString = configuration.GetConnectionString("MesetaVerdeDatabase")
                ?? configuration.GetConnectionString("DefaultConnection");

            services.AddDbContext<MesetaVerdeDbContext>(options =>
                options.UseNpgsql(connectionString)
                       .UseSnakeCaseNamingConvention());

         

           // Configuración de Supabase
            var supabaseUrl = configuration["Supabase:Url"];
            var supabaseKey = configuration["Supabase:ServiceRoleKey"]; // Usamos ServiceRole para escritura interna
    
            services.AddSingleton(provider => new Supabase.Client(supabaseUrl, supabaseKey));
            services.AddSingleton<IDeliveryRequestRepository, DeliveryRequestRespository>();
            //registramos servicio de supabase
            services.AddScoped<IStorageService, SupabaseStorageService>();

            services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
            services.AddScoped<ITokenServices, TokenServices>();
            services.AddScoped<IEmailService, SmtpEmailService>();
            services.AddScoped<IVerificationCodeRepository, InMemoryVerificationCodeRepository>();
            services.AddScoped<IUnitofWork, UnitOfWork>();

            return services;
        }
    }
}