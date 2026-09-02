using Agro_Trade.Application.Common.DTOs.BotCommunication;

namespace Agro_Trade.Application.Common.Interface
{
    public interface IBotServices
    {
        void traerPrompts();
        string GetPrompt(string nombreArchivo);
        List<History> GetHistory(string userId);
        void AddToUserHistory(string userId, string message, string role);
    }
}