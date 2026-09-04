using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using Microsoft.Extensions.Caching.Memory;

namespace Agro_Trade.Infrastructure.Services

{
    public class GetPromptServices : IBotServices
    {
        private readonly IMemoryCache _cache;
        private TimeSpan _cacheExpiration = TimeSpan.FromDays(1);
        public GetPromptServices(IMemoryCache cache)
        {
            _cache = cache;
            traerPrompts();
        }

        private Dictionary<string, string> _prompts = new();

        public void traerPrompts()
        {
            string[] rutasPosibles =
            {
                // Si se copia al directorio de salida de la aplicación (bin o publish/Docker)
                Path.Combine(AppContext.BaseDirectory, "Embebido"),

                // Desde AppContext.BaseDirectory en desarrollo (ej. Agro_Trade/bin/Debug/net8.0)
                Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "Agro_Trade.Infrastructure", "Embebido"),
                Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "Embebido"),

                // Desde el directorio de trabajo actual (Directory.GetCurrentDirectory)
                Path.Combine(Directory.GetCurrentDirectory(), "Embebido"),
                Path.Combine(Directory.GetCurrentDirectory(), "Agro_Trade.Infrastructure", "Embebido"),
                Path.Combine(Directory.GetCurrentDirectory(), "..", "Agro_Trade.Infrastructure", "Embebido"),
                Path.Combine(Directory.GetCurrentDirectory(), "src", "Agro_Trade.Infrastructure", "Embebido"),
                Path.Combine(Directory.GetCurrentDirectory(), "Backend", "src", "Agro_Trade.Infrastructure", "Embebido")
            };

            string rutaCarpeta = rutasPosibles
                .Select(ruta => Path.GetFullPath(ruta))
                .FirstOrDefault(Directory.Exists) ?? throw new DirectoryNotFoundException(
                    $"La carpeta 'Embebido' no se encontró en ninguna de las rutas esperadas: {string.Join("; ", rutasPosibles.Select(Path.GetFullPath))}.");

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

        private readonly object _lock = new();

        public List<BotConversation> GetUserHistory(string userId)
        {
            if (string.IsNullOrWhiteSpace(userId))
            {
                return new List<BotConversation>();
            }

            string historyCacheKey = $"history_of_{userId}";

            lock (_lock)
            {
                var userChats = _cache.GetOrCreate(historyCacheKey, entry =>
                {
                    entry.SlidingExpiration = _cacheExpiration;
                    return new List<BotConversation>();
                }) ?? new List<BotConversation>();

                // Retornamos una copia profunda defensiva para garantizar que la colección y sus mensajes estén intactos
                return userChats.Select(c => new BotConversation
                {
                    ChatId = c.ChatId,
                    UserId = c.UserId,
                    History = c.History.Select(h => new History { Role = h.Role, Content = h.Content }).ToList()
                }).ToList();
            }
        }

        public void AddToUserHistory(string chatId, string userId, string message, string role)
        {
            if (string.IsNullOrWhiteSpace(chatId) || string.IsNullOrWhiteSpace(userId) || string.IsNullOrWhiteSpace(message) || string.IsNullOrWhiteSpace(role))
            {
                throw new ArgumentException("chatId, userId, message y role no pueden ser nulos o vacíos.");
            }

            string historyCacheKey = $"history_of_{userId}";

            lock (_lock)
            {
                var userChats = _cache.GetOrCreate(historyCacheKey, entry =>
                {
                    entry.SlidingExpiration = _cacheExpiration;
                    return new List<BotConversation>();
                }) ?? new List<BotConversation>();

                var chat = userChats.FirstOrDefault(c => c.ChatId == chatId);
                if (chat == null)
                {
                    chat = new BotConversation 
                    { 
                        ChatId = chatId, 
                        UserId = userId, 
                        History = new List<History>() 
                    };
                    userChats.Add(chat);
                }

                // El mensaje se agrega directamente al historial de la conversación
                chat.History.Add(new History { Role = role, Content = message });

                _cache.Set(historyCacheKey, userChats, new MemoryCacheEntryOptions { SlidingExpiration = _cacheExpiration });
            }
        }

        public List<History> GetHistory(string chatId, string userId)
        {
            if (string.IsNullOrWhiteSpace(chatId) || string.IsNullOrWhiteSpace(userId))
            {
                return new List<History>();
            }

            string historyCacheKey = $"history_of_{userId}";

            lock (_lock)
            {
                var userChats = _cache.GetOrCreate(historyCacheKey, entry =>
                {
                    entry.SlidingExpiration = _cacheExpiration;
                    return new List<BotConversation>();
                }) ?? new List<BotConversation>();

                var chat = userChats.FirstOrDefault(c => c.ChatId == chatId);
                if (chat == null)
                {
                    return new List<History>();
                }

                return chat.History.Select(h => new History { Role = h.Role, Content = h.Content }).ToList();
            }
        }


        
    }
}