using EFCore.NamingConventions;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Application.DependencyInjection;
using Meseta_Verde.Infrastructure.DependencyInjection;
using Meseta_Verde.Infrastructure.Persistence;
using Meseta_Verde.Infrastructure.Repository;
using Meseta_Verde.Middlewares;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.OpenApi.Models;
using Npgsql;


namespace Meseta_Verde
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
            builder.Services.AddDbContext<MesetaVerdeDbContext>(options =>
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

          
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();
            app.UseCors("AllowAll");
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseMiddleware<ExceptionHandlingMiddleware>();
            app.UseAuthorization();


            app.MapControllers();

            app.Run();

        } } }
