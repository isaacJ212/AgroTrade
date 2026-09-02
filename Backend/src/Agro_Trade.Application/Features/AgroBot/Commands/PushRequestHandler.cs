using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Application.Exceptions;
using Google.GenAI;
using Google.GenAI.Types;
using MediatR;
using Microsoft.Extensions.Configuration;

namespace Agro_Trade.Application.Features.AgroBot.Commands
{
    public record PushRequest(string UserId, BotRequest BotRequest) : IRequest<Result<BotResponse>>;
    public class PushRequestHandler(IBotServices botServices, IConfiguration cfg) : IRequestHandler<PushRequest, Result<BotResponse>>
    {
        public async Task<Result<BotResponse>> Handle(PushRequest request, CancellationToken cancellationToken)
        {

            var dto = request.BotRequest;
            // INICIALIZAMOS EL CLIENTE DE GEMINI
            var apiKey = cfg["Gemini:ApiKey"] ?? System.Environment.GetEnvironmentVariable("GEMINI_API_KEY") ?? "";
            var ai = new Client(apiKey: apiKey);
            // VALIDAMOS QUE LOS CAMPOS NO ESTÉN VACÍOS AUNQUE EL MENSAJE SI PODRIA ESTAR MEJOR PREVENIR
            if(string.IsNullOrWhiteSpace(dto.Message) || string.IsNullOrWhiteSpace(dto.Module))
            {
                return Result<BotResponse>.Failure(400,"El Mensaje No Puede Estar Vacío.");
            }
            //OBTENEMOS EL SYSTEM PROMPT SEGUN EL MODULO EN EL QUE SE ENCUENTRE, TAMBIEN OBTENEMOS EL HISTORIAL DEL CHAT
            var systemPrompt = botServices.GetPrompt(dto.Module);
            
            botServices.AddToUserHistory(request.UserId, dto.Message, "user");
            var history = botServices.GetHistory(request.UserId);
            // PARSEAMOS EL HISTORIAL A LA ESTRUCTURA QUE REQUIERE GEMINI
            var contentList = new List<Content>();
           if (history != null && history.Any())
{
    foreach (var item in history)
    {
       if (item != null && !string.IsNullOrEmpty(item.Content))
        {
            contentList.Add(new Content 
            { 
                Role = item.Role ?? "user", 
                Parts = new List<Part> { new Part { Text = item.Content } } 
            });
        }
    }
}
            // SEGUN LO QUE ENTENDI LA TEMPERATURA ES PARA CONTROLAR LA CREATIVIDAD DE LA RESPUESTA, ENTRE MAS ALTA MAS CREATIVA, ENTRE MAS BAJA MAS CONSERVADORA
            var config = new GenerateContentConfig
            {
                SystemInstruction = new Content
                {
                    Parts = new List<Part> { new Part { Text = systemPrompt } } 
                },
                Temperature = 0.3f
            };
            string respuesta = string.Empty;
            int intentos = 0;
            int maxIntentos = 3;
            while (intentos < maxIntentos)
            {
                try
                {
                      // POR FUN CONSUMIMOS LA API
            var response = await ai.Models.GenerateContentAsync(
                model: "gemini-3.6-flash",
                contents: contentList,
                config: config,
                cancellationToken : cancellationToken
            );

            respuesta = response.Text ?? "Algo ocurrio al procesar la respuesta porfavor intenta nuevamente.";
            break;
                }catch(Google.GenAI.ServerError ex){
                    intentos++;
                    if(intentos >= maxIntentos)
                    {
                        return Result<BotResponse>.Failure(503, "El Servicio de IA está saturado temporalmente, intenta de nuevo más tarde.");     
                    }
                    await Task.Delay(10000); // Espera 10 segundos antes de reintentar
                }
            }

            
            botServices.AddToUserHistory(request.UserId, respuesta, "model");

            return Result<BotResponse>.Success(200, new BotResponse { Response = respuesta }, "Operación realizada correctamente.", true);
            
            
        }
     
}}