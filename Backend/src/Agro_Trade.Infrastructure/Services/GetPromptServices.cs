using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Infrastructure.Services

{
    public class GetPromptServices : IBotServices
    {
        private readonly IMemoryCache _cache;
        private TimeSpan _cacheExpiration = TimeSpan.FromHours(1);
        public GetPromptServices(IMemoryCache cache)
        {
            _cache = cache;
            traerPrompts();
        }

        private Dictionary<string, string> _prompts = new();

        public void traerPrompts()
        {
           string rutaCarpeta = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "../../../../Embebido");
           if(!Directory.Exists(rutaCarpeta))
            {
                throw new DirectoryNotFoundException($"La carpeta '{rutaCarpeta}' no existe.");
            }   
            string[] archivos = Directory.GetFiles(rutaCarpeta, "*.md");

            foreach (string archivo in archivos)
            {
                string nombreArchivo = Path.GetFileNameWithoutExtension(archivo);
                string contenidoArchivo = File.ReadAllText(archivo);
                _prompts[nombreArchivo] = contenidoArchivo;
            }
        }

        public string GetPrompt(string nombreArchivo)
        {
            if (_prompts.TryGetValue(nombreArchivo, out string? contenido))
            {
                return contenido;
            }
            else
            {
                throw new KeyNotFoundException($"No se encontró el prompt con el nombre '{nombreArchivo}'.");
            }
        }

       public List<History> GetHistory(string userId)
    {
        string cacheKey = $"history_of_{userId}";
        
        // Obtenemos una copia segura o la lista existente
        return _cache.GetOrCreate(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = _cacheExpiration;
            return new List<History>();
        });
    }

        public void AddToUserHistory(   string userId, string message, string role)
        {
            string cacheKey = $"history_of_{userId}";
           
                var history = GetHistory(userId);
                lock(history)
                {
                    history.Add(new History { Role = role, Content = message });
                    
                }
        }
       
    }
}