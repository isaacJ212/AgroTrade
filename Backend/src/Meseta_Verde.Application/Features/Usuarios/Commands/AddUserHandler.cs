using MediatR;
using Meseta_Verda.Domain.Entities;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.UsersDtos;
using Meseta_Verde.Application.Common.Interface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Features.Usuarios.Commands
{
    public record AddUserCommand(CreateUserDto dto) : IRequest<Result<UserDto>>;
    public class AddUserHandler(IUnitofWork context, IRepository<UsuarioRol> rol, IEmailService emailService, IVerificationCodeRepository verificationCodeRepository) : IRequestHandler<AddUserCommand, Result<UserDto>>
    {
        public async Task<Result<UserDto>> Handle(AddUserCommand request, CancellationToken ct)
        {
            var dto = request.dto;
            //Validamos
            if (await context.Users.UserExistsAsync(dto.Email, ct))
                return Result<UserDto>.Failure(400, "Este Email ya esta en uso");

            // Obtenemos la hora local de nicaragua
            
            var newUser = new Usuario
            {
                NombreCompleto = dto.NombreCompleto,
                Email = dto.Email,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                IdentidadVerificada = false,
                FechaRegistro = DateTime.UtcNow,
                Telefono = dto.Telefono,
                DireccionBase = dto.DireccionBase

            };
            var user = await context.Users.AddAsync(newUser, ct);

            await context.SaveChangesAsync(ct);

            var userRol = new UsuarioRol
            {
                IdUsuario = user.IdUsuario,
                IdRol = 1 //id de rol cliente
            };

            await rol.AddAsync(userRol, ct);

            await context.SaveChangesAsync(ct);
            if (user != null)
            {
                var verificationCode = GenerateVerificationCode();
                await verificationCodeRepository.SaveCodeAsync(user.IdUsuario, verificationCode, TimeSpan.FromMinutes(10), ct);
                await emailService.SendVerificationCodeAsync(user.Email, verificationCode, ct);

                var mapped = new UserDto {
                    Id = user.IdUsuario,
                    Name = user.NombreCompleto,
                    Email = user.Email,
                    IdentidadVerificada = user.IdentidadVerificada,
                    Telefono = user.Telefono,
                    DireccionBase = user.DireccionBase,
                    FechaRegistro = user.FechaRegistro
                };

                return Result<UserDto>.Succes(201, mapped, "Usuario Registrado. Se envió un código de verificación a tu correo.", true);

            }

            return Result<UserDto>.Failure(400, "Algo fallo al crear el usuario, por favor intente mas tarde");

        }

        private static string GenerateVerificationCode()
        {
            var random = new Random();
            return random.Next(100000, 999999).ToString();
        }

    } }
