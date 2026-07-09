using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.Interface;
using Meseta_Verde.Application.Common.DTOs.InventarioDtos;
using Meseta_Verda.Domain.Entities;
using MediatR;
//using Microsoft.AspNetCore.Http;

namespace Meseta_Verde.Application.Features.Inventarios
{
    public record CreateInventarioCommand(CreateInventarioDto Dto, IFormFile Foto) : IRequest<Result<int>>;
    public class CreateInventarioCommandHandler : IRequestHandler<CreateInventarioCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IStorageService _storageService;

       public CreateInventarioCommandHandler(IUnitofWork unitOfWork, IStorageService storageService)
        {
            _unitOfWork = unitOfWork;
            _storageService = storageService;
        }


        public async Task<Result<int>> Handle(CreateInventarioCommand request, CancellationToken ct)
        {
            var dto = request.Dto;
            var file = request.Foto;

            // 1. Validaciones de la imagen
            if (file == null || file.Length == 0)
                return Result<int>.Failure(400, "La imagen es obligatoria.");

            var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".webp" };
            var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
            if (!allowedExtensions.Contains(extension))
                return Result<int>.Failure(400, "Formato de imagen no válido.");

            // Validar que proveedor y producto existan
            if (!await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == dto.IdProveedor, ct))
                return Result<int>.Failure(404, "Proveedor no encontrado.");

            if (!await _unitOfWork.Productos.AnyAsync(p => p.IdProducto == dto.IdProducto, ct))
                return Result<int>.Failure(404, "Producto no encontrado.");

            // 2. Subir imagen a Storage
            string bucketName = "inventario-fotos"; // O inyectarlo desde configuración
            string uniqueFileName = $"{Guid.NewGuid()}{extension}";
            string fotoUrl = await _storageService.UploadFileAsync(file, bucketName, uniqueFileName, ct);

            if (string.IsNullOrEmpty(fotoUrl))
                return Result<int>.Failure(500, "Error al subir la imagen al servidor.");

            // 3. Guardar en Base de Datos
            var inventario = new InventarioProveedor
            {
                IdProveedor = dto.IdProveedor,
                IdProducto = dto.IdProducto,
                StockActual = dto.StockActual,
                CostoProduccion = dto.CostoProduccion,
                PrecioVenta = dto.PrecioVenta,
                EsOfertaExcedente = dto.EsOfertaExcedente,
                PorcentajeDescuento = dto.PorcentajeDescuento,
                FechaCosecha = dto.FechaCosecha,
                FotoUrl = fotoUrl,
                Disponible = true
            };

            await _unitOfWork.BeginTransactionAsync(ct);


            try
            {
                await _unitOfWork.InventarioProveedor.AddAsync(inventario, ct);
                await _unitOfWork.CommitAsync(ct);
                return Result<int>.Succes(201, inventario.IdInventario, "Inventario creado exitosamente.", true);
            }
            catch (Exception)
            {
                await _unitOfWork.RollbackAsync(ct);
                
                // 4. Rollback Storage: Eliminar archivo huérfano si la BD falló
                await _storageService.DeleteFileAsync(bucketName, fotoUrl, ct);
                
                return Result<int>.Failure(500, "Error al guardar en base de datos. La imagen fue descartada.");
            }

        }

    }
}