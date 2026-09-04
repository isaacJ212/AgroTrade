using System.Runtime.CompilerServices;
using Agro_Trade.Application.Exceptions;

namespace Agro_Trade.Middlewares
{
    public class ExceptionHandlingMiddleware(RequestDelegate next, ILogger<ExceptionHandlingMiddleware> logger)
    {
        public async Task Invoke(HttpContext context)
        {
            try
            {
                await next(context);
            } catch(ApiExceptions ex)
            {
                logger.LogError("Ocurrio un error controlado en la Aplicacion");
                Console.WriteLine(ex.ToString());
                var endpoint = context.GetEndpoint();
                var name = endpoint.DisplayName ?? "Endpoint Desconocido";
                Console.WriteLine($"El endpoint del error es {name}");
                Console.WriteLine(ex.Message);
                context.Response.StatusCode = ex.statusCode;
                await context.Response.WriteAsJsonAsync(new
                {
                    Error = ex.Message
                });
            }catch(Exception ex)
            {
                logger.LogError("Ocurrio un error no controlado en la Aplicacion");
                Console.WriteLine(ex.ToString());
                var endpoint = context.GetEndpoint();
                var name = endpoint.DisplayName ?? "Endpoint Desconocido";
                Console.WriteLine($"El endpoint del error es {name}");
                Console.WriteLine(ex.Message);
                context.Response.StatusCode = 500;
                await context.Response.WriteAsJsonAsync(new
                {
                    Error = "error inesperado en el servidor por favor intente mas tarde"
                });
            }
           
        }
    }
}
