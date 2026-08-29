using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Agro_Trade.Application.Common
{
    public class Result
    {
        public int StatusCode { get; set; }
        public string Message { get; set; } = string.Empty;
        public bool IsSuccess { get; set; }

        public static Result Success(int statusCode = 200, string message = "Operaci\u00f3n realizada correctamente.")
            => new() { StatusCode = statusCode, Message = message, IsSuccess = true };

        public static Result Failure(int statusCode, string message)
            => new() { StatusCode = statusCode, Message = message, IsSuccess = false };
    }

    public  class Result<T>
    {
        public int StatusCode { get; set; }
        public T Data { get; set; }
        public string Message { get; set; }
        public bool IsSuccess { get; set; }

        public static Result<T> Success(int statusCode, T data, string message, bool IsSucces)=> new () { StatusCode = statusCode, Data = data, Message = message, IsSuccess = IsSucces? true : false };
        public static Result<T> Failure(int statusCode, string message) => new () { StatusCode = statusCode, Data = default, Message = message, IsSuccess = false };
    }
}

