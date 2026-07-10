using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Meseta_Verde.Application.Common.Interface;

namespace Meseta_Verde.Infrastructure.Services
{ //tenre problema por que no se me sale  el pqquet nuge que voy a ocupar.

 //recurso revisado > https://www.youtube.com/watch?v=ABrR-cuBC9A&pp=ygUgY29tbyB1c2FyIGxvcyBidWNrZXQgZGUgc3VwYWJhc2U%3D
    public class SupabaseStorageService : IStorageService
    {
        private readonly Supabase.Client _supabaseClient;

        public SupabaseStorageService(Supabase.Client supabaseClient)
        {
            _supabaseClient = supabaseClient;
        }

        //https://www.youtube.com/watch?v=P8PrW09ZWjw

        public async Task<string> UploadFileAsync(Stream file, string bucketName, string fileName, CancellationToken ct)
        {
            using var memoryStream = new MemoryStream();
            await file.CopyToAsync(memoryStream, ct);
            var fileBytes = memoryStream.ToArray();

            // Sube el archivo al bucket
            await _supabaseClient.Storage.From(bucketName).Upload(fileBytes, fileName, new Supabase.Storage.FileOptions { Upsert = true });

            // Obtiene la URL pública
            var publicUrl = _supabaseClient.Storage.From(bucketName).GetPublicUrl(fileName);
            return publicUrl;
        }
        

        public async Task DeleteFileAsync(string bucketName, string fileUrl, CancellationToken ct)
        {
            // Extraer el nombre del archivo de la URL pública
            var uri = new Uri(fileUrl);
            var fileName = uri.Segments.Last();

            await _supabaseClient.Storage.From(bucketName).Remove(new List<string> { fileName });
        }
        
    }
}