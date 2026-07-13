using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Meseta_Verde.Application.Common
{
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

