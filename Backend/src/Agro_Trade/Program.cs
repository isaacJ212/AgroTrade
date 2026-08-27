using EFCore.NamingConventions;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.DependencyInjection;
using Agro_Trade.Infrastructure.DependencyInjection;
using Agro_Trade.Infrastructure.Persistence;
using Agro_Trade.Infrastructure.Repository;
using Agro_Trade.Middlewares;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.OpenApi.Models;
using Npgsql;


namespace Agro_Trade
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            var dataSourceBuilder = new NpgsqlDataSourceBuilder(builder.Configuration.GetConnectionString("MesetaVerdeDatabase"));
            dataSourceBuilder.EnableDynamicJson(); 
            var dataSource = dataSourceBuilder.Build();
            // Add services to the container.
            builder.Services.AddHttpContextAccessor();
            builder.Services.AddDbContext<AgroTradeDbContext>(options =>
                options.UseNpgsql(dataSource)
                       .UseSnakeCaseNamingConvention());
            builder.Services.AddScoped<IUserRepository, UserRepository>();
            // Inyección de Dependencias
            builder.Services.AddApplicationServices();
            builder.Services.AddInfrastructureServices(builder.Configuration);

            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = builder.Configuration["Jwt:Issuer"],
                        ValidAudience = builder.Configuration["Jwt:Audience"],
                        IssuerSigningKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(
                            System.Text.Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]))
                    };
                });
            builder.Services.AddAuthorization();
            builder.Services.AddControllers();
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen(c =>
            {
                c.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
                {
                    Description = "JWT Authorization header usando el esquema Bearer. \r\n\r\n Escribe 'Bearer' [espacio] y luego tu token.",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement()
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            },
                            Scheme = "oauth2",
                            Name = "Bearer",
                            In = ParameterLocation.Header,
                        },
                        new List<string>()
                    }
                });
            });

            //uso de corqs
            builder.Services.AddCors(options =>
            {
                options.AddPolicy("AllowAll", policy =>
                {
                    policy.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader();
                });
            });





            var app = builder.Build();

          
            // Habilitar Swagger siempre (tanto en Local como en Producción en Render)
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {       
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "Agro Trade API v1");
                c.RoutePrefix = "swagger"; 
            });

            app.UseHttpsRedirection();
            app.UseCors("AllowAll");
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseMiddleware<ExceptionHandlingMiddleware>();
            app.UseAuthorization();


            app.MapControllers();


            // Aplicar migraciones de EF Core automáticamente al iniciar el contenedor
            using (var scope = app.Services.CreateScope())
            {
                var services = scope.ServiceProvider;
                try
                {
                    var dbContext = services.GetRequiredService<AgroTradeDbContext>();
                    dbContext.Database.Migrate();
                }
                catch (Exception ex)
                {
                    var logger = services.GetRequiredService<ILogger<Program>>();
                    logger.LogError(ex, "Ocurrió un error al aplicar las migraciones en PostgreSQL.");
                }
            }



            app.Run();

        } } }
