namespace Agro_Trade.Application.Exceptions
{
        public class ApiExceptions : ApplicationException
    {
        public int statusCode { get; set; }
        public ApiExceptions(int statusCode, string message) : base(message)
        {
            this.statusCode = statusCode;
         }
        
    }

    public sealed class BotException : ApiExceptions
    {
        public BotException(int statusCode, string message) : base(statusCode, message)
        {
        }
    }
}