using MediatR;
using Agro_Trade.Domain.Entities;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.UsersDtos;
using Agro_Trade.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Features.Usuarios.Commands
{
    public record AddUserCommand(CreateUserDto dto) : IRequest<Result<UserDto>>;

    public class AddUserHandler(
        IUnitofWork context, 
        IRepository<UsuarioRol> rol, 
        IEmailService emailService, 
        IVerificationCodeRepository verificationCodeRepository) : IRequestHandler<AddUserCommand, Result<UserDto>>
    {
        public async Task<Result<UserDto>> Handle(AddUserCommand request, CancellationToken ct)
        {
            var dto = request.dto;
            
            if (dto.IdRol <= 0)
                return Result<UserDto>.Failure(400, "Ingresa un ID de rol válido.");

            // VALIDEMOS QUE NO SE PUEDE CREAR USUARIOS ADMINISTRADORES SIN AYUDA DEL SOPORTE TECNICO
            if (dto.IdRol == 4)
                return Result<UserDto>.Failure(403, "NO PUEDES CREAR UNA CUENTA CON ESTE ROL");

            try
            {
                // Creamos una transacción, así si falla no se guardan usuarios corruptos
                await context.BeginTransactionAsync(ct);

                var exist = await context.Users.UserExistsAsync(dto.Email, ct);
                if (exist)
                {
                    await context.RollbackAsync(ct);
                    return Result<UserDto>.Failure(400, "Este Email ya está en uso.");
                }

                var newUser = new Usuario
                {
                    Nombre = dto.Nombre,
                    PrimerApellido = dto.PrimerApellido,
                    SegundoApellido = dto.SegundoApellido,
                    Email = dto.Email,
                    PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                    IdentidadVerificada = false,
                    FechaRegistro = DateTime.UtcNow,
                    Telefono = dto.Telefono,
                    Departamento = dto.Departamento,
                    Municipio = dto.Municipio,
                    DireccionExacta = dto.DireccionExacta
                };

                var user = await context.Users.AddAsync(newUser, ct);
                await context.SaveChangesAsync(ct);

                var userRol = new UsuarioRol
                {
                    IdUsuario = user.IdUsuario,
                    IdRol = dto.IdRol ?? 1 // 1 = Cliente/Comprador por defecto
                };

                await rol.AddAsync(userRol, ct);
                await context.SaveChangesAsync(ct);

                var verificationCode = GenerateVerificationCode();
                await verificationCodeRepository.SaveCodeAsync(user.IdUsuario, verificationCode, TimeSpan.FromMinutes(10), ct);
                
                await emailService.SendVerificationCodeAsync(
                    user.Email,
                    verificationCode,
                    "Código de Verificación 2FA - AgroTrade",
                    "Código de verificación",
                    "Tu código de verificación para Agro Trade es:",
                    ct);

                var roles = await context.Users.GetRolesByUserIdAsync(user.IdUsuario, ct);
                var mapped = new UserDto
                {
                    Id = user.IdUsuario,
                    Name = $"{(user.Nombre + " " + user.PrimerApellido + " " + user.SegundoApellido).Trim()}",
                    Email = user.Email,
                    IdentidadVerificada = user.IdentidadVerificada,
                    Telefono = user.Telefono,
                    DireccionBase = $"{(user.Departamento + ", " + user.Municipio + ", " + user.DireccionExacta).Trim(new char[] { ',', ' ' })}",
                    FechaRegistro = user.FechaRegistro,
                    Departamento = user.Departamento,
                    Municipio = user.Municipio,
                    EstadoCuenta = user.EstadoCuenta,
                    Roles = roles.ToList()
                };

                // Confirmamos los cambios en la base de datos de manera segura
                await context.CommitAsync(ct); 

                return Result<UserDto>.Success(201, mapped, "Usuario Registrado. Se envió un código de verificación a tu correo.", true);
            }
            catch (Exception ex)
            {
                await context.RollbackAsync(ct);
                // Tip de Hackathon: Es buena práctica registrar el error 'ex' internamente en consola para debuguear rápido
                Console.WriteLine($"[HANDLER ERROR]: {ex.Message}"); 
                return Result<UserDto>.Failure(500, "Algo falló al crear el usuario, por favor intente más tarde.");
            }
        }

        private static string GenerateVerificationCode()
        {
            return RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        }
    }
}
