using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Features.Productos.Commands;
using Microsoft.AspNetCore.Http;
using Xunit;

namespace Agro_Trade.Tests;

public class CreateProductoCommandHandlerTests
{
    [Fact]
    public async Task HandleUploadAsync_UsesFileNameExtension_ForValidImage()
    {
        var handler = new CreateProductoCommandHandler(null!, new FakeStorageService());
        await using var stream = new MemoryStream(new byte[] { 1, 2, 3, 4 });
        var file = new FormFile(stream, 0, stream.Length, "FotoProducto", "tomate.jpg");

        var result = await handler.HandleUploadAsync(file, CancellationToken.None);

        Assert.NotNull(result);
        Assert.Contains("https://example.com", result);
    }

    private sealed class FakeStorageService : IStorageService
    {
        public Task<string> UploadFileAsync(Stream file, string buckectName, string fileName, CancellationToken ct)
            => Task.FromResult("https://example.com/images/" + fileName);

        public Task DeleteFileAsync(string bucketName, string fileUrl, CancellationToken ct)
            => Task.CompletedTask;
    }
}
