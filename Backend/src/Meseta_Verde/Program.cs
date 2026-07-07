using EFCore.NamingConventions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.AspNetCore.Builder;
using Meseta_Verde.Infrastructure.Persistence;
using Meseta_Verde.Application.DependencyInjection;
using Meseta_Verde.Infrastructure.DependencyInjection;
using Meseta_Verde.Middlewares;


namespace Meseta_Verde
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddHttpContextAccessor();

            builder.Services.AddDbContext<MesetaVerdeDbContext>(options =>
                options.UseNpgsql(builder.Configuration.GetConnectionString("MesetaVerdeDatabase"))
                       .UseSnakeCaseNamingConvention());

            // Inyección de Dependencias
            builder.Services.AddApplicationServices();
            builder.Services.AddInfrastructureServices(builder.Configuration);

            builder.Services.AddControllers();
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseMiddleware<ExceptionHandlingMiddleware>();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
