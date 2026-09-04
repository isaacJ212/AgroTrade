namespace Agro_Trade.Application.Common.DTOs.BotCommunication
{
    public class BotConversation
    {
        public string UserId { get; set; } = string.Empty;
        public string ChatId { get; set; } = string.Empty;
        public List<History> History { get; set; } = new List<History>();
    }
}