using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using Microsoft.AspNetCore.Http;

namespace Agro_Trade.Application.Features.Productos.Commands
{
    public record CreateProductoCommand(
        int IdCategoria,
        int IdProveedor,
        string Nombre,
        string? Descripcion,
        string UnidadMedida,
        IFormFile? FotoProducto = null) : IRequest<Result<int>>;

    public class CreateProductoCommandHandler : IRequestHandler<CreateProductoCommand, Result<int>>
    {
        private readonly IUnitofWork _unitOfWork;
        private readonly IStorageService _storageService;

        public CreateProductoCommandHandler(IUnitofWork unitOfWork, IStorageService storageService)
        {
            _unitOfWork = unitOfWork;
            _storageService = storageService;
        }

        public async Task<Result<int>> Handle(CreateProductoCommand request, CancellationToken cancellationToken)
        {
            var categoriaExiste = await _unitOfWork.Categorias.AnyAsync(c => c.IdCategoria == request.IdCategoria, cancellationToken);
            if (!categoriaExiste)
            {
                return Result<int>.Failure(404, "La categoría especificada no existe.");
            }

            var proveedorExiste = await _unitOfWork.Proveedores.AnyAsync(p => p.IdProveedor == request.IdProveedor, cancellationToken);
            if (!proveedorExiste)
            {
                return Result<int>.Failure(404, "El proveedor especificado no existe.");
            }

            var fotoUrl = await HandleUploadAsync(request.FotoProducto, cancellationToken);
            var urlFinal = fotoUrl ?? "https://via.placeholder.com/600x400.png?text=Producto";

            var producto = new Producto
            {
                IdCategoria = request.IdCategoria,
                IdProveedor = request.IdProveedor,
                Nombre = request.Nombre,
                Descripcion = request.Descripcion,
                UnidadMedida = request.UnidadMedida,
                urlFotoProducto = urlFinal
            };

            await _unitOfWork.Productos.AddAsync(producto, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);

            return Result<int>.Success(201, producto.IdProducto, "Producto creado correctamente.", true);
        }

        public async Task<string?> HandleUploadAsync(IFormFile? file, CancellationToken ct)
        {
            if (file == null || file.Length == 0)
                return null;

            using var stream = file.OpenReadStream();
            var fileName = file.FileName;

            string[] allowedExtensions = [".jpg", ".jpeg", ".png", ".webp"];
            var extension = Path.GetExtension(fileName).ToLowerInvariant();

            if (!allowedExtensions.Contains(extension))
                return null;

            string bucketName = "imagenes_meseta_verde";
            string uniqueName = $"{Guid.NewGuid()}{extension}";

            return await _storageService.UploadFileAsync(stream, bucketName, uniqueName, ct);
        }
    }
}
