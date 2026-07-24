using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common.Interface
{
    public interface IStorageService
    {
        Task<string> UploadFileAsync(Stream file, string buckectName, string fileName, CancellationToken ct);
        Task DeleteFileAsync(string bucketName,string fileUrl, CancellationToken ct);
    }
}