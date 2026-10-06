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
        public class AddUserHandler(IUnitofWork context, IRepository<UsuarioRol> rol, IEmailService emailService, IVerificationCodeRepository verificationCodeRepository) : IRequestHandler<AddUserCommand, Result<UserDto>>
        {
            public async Task<Result<UserDto>> Handle(AddUserCommand request, CancellationToken ct)
            {
              
                var dto = request.dto;
                //VALIDEMOS QUE NO SE PUEDE CREAR USUARIOS ADMINISTRADORES SIN AYUDA DEL SOPORTE TECNICO
                if( dto.IdRol == 4)
                    return Result<UserDto>.Failure( 403,"NO PUEDES CREAR UNA CUENTA CON ESTE ROL");
                
            //Validamos
            var exist = await context.Users.UserExistsAsync(dto.Email, ct);
                if (exist)
                    return Result<UserDto>.Failure(400, "Este Email ya esta en uso");
                
                 
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
                if (user != null)
                {
                   var verificationCode = GenerateVerificationCode();
                   await verificationCodeRepository.SaveCodeAsync(user.IdUsuario, verificationCode, TimeSpan.FromMinutes(10), ct);
                   await emailService.SendVerificationCodeAsync(
                       user.Email,
                       verificationCode,
                       "Código de Verificación 2FA - AgroTrade",
                       "Código de verificación",
                       "Tu código de verificación para Agro Trade es:",
                       ct);

                    var mapped = new UserDto {
                        Id = user.IdUsuario,
                        Name = $"{(user.Nombre + " " + user.PrimerApellido + " " + user.SegundoApellido).Trim()}",
                        Email = user.Email,
                        IdentidadVerificada = user.IdentidadVerificada,
                        Telefono = user.Telefono,
                        DireccionBase = $"{(user.Departamento + ", " + user.Municipio + ", " + user.DireccionExacta).Trim(new char[] { ',', ' ' })}",
                        FechaRegistro = user.FechaRegistro
                    };

                   
                    return Result<UserDto>.Success(201, mapped, "Usuario Registrado. Se envió un código de verificación a tu correo.", true);

                }

                return Result<UserDto>.Failure(400, "Algo fallo al crear el usuario, por favor intente mas tarde");

            }

            private static string GenerateVerificationCode()
            {
                return RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
            }

        } }
        
