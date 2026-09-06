using Agro_Trade.Application.Common.DTOs.BotCommunication;

namespace Agro_Trade.Application.Common.Interface
{
    public interface IBotServices
    {
        void traerPrompts();
        string GetPrompt(string nombreArchivo);
        List<History> GetHistory(string chatId, string userId);
        void AddToUserHistory(string chatId, string userId, string message, string role);
        List<BotConversation> GetUserHistory(string userId);
    }
}