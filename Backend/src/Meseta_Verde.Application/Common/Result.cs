namespace Meseta_Verde.Application.Common
{
    public class Result<T>
    {
        public int StatusCode { get; set; }
        public T? Data { get; set; }
        public string Message { get; set; } = string.Empty;
        public bool IsSuccess { get; set; }

        public static Result<T> Succes(int statusCode, T data, string message, bool IsSucces) => new() { StatusCode = statusCode, Data = data, Message = message, IsSuccess = IsSucces ? true : false };
        public static Result<T> Failure(int statusCode, string message) => new() { StatusCode = statusCode, Data = default, Message = message, IsSuccess = false };
    }
}
