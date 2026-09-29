using Agro_Trade.Application.Common.Interface;
using Microsoft.AspNetCore.Http;

namespace Agro_Trade.Application.Helpers;

public class AppContextAccessor : IAppContext
{
    private readonly IHttpContextAccessor _httpContextAccesor;

    public AppContextAccessor(IHttpContextAccessor httpContextAccesor)
    {
        _httpContextAccesor = httpContextAccesor;
    }
    //INMPLEMENTACION DE ACCESSOR PARA EL CONTEXTO HTTP DE LAS REQUEST ESTA CLASE LA USARE UNICAMENTE
    //PARA OBTENER EL IP ADDRESS PERO SE PUEDE METER MAS COSAS COMO EL USER AGENT ETC
    public string IpAdress => _httpContextAccesor.HttpContext.Connection.RemoteIpAddress.ToString() ?? string.Empty;
}