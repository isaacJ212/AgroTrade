using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Agro_Trade.Application.Common.Interface;
using Microsoft.Extensions.DependencyInjection;
using Agro_Trade.Application.Features.Usuarios.Commands;
using Agro_Trade.Application.Helpers;

namespace Agro_Trade.Application.DependencyInjection
{
    public static class ApplicationServiceCollectionExtensions
    {
        public static IServiceCollection AddApplicationServices(this IServiceCollection services)
        {
            // SERVICIOS NATIVOS DE LA CAPA DE APLICACION
            services.AddScoped<IAppContext, AppContextAccessor>();
            
            // Usa el ensamblado donde viven los handlers de recuperación y cambio de contraseña.
            // MediatR registra desde aquí todos los IRequestHandler de Application.
            var applicationAssembly = typeof(SendPasswordRecoveryCodeHandler).Assembly;
            services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(applicationAssembly));
            return services;
        }
    }
}