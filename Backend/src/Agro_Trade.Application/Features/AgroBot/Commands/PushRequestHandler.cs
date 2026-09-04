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

            // 1. Validamos que los campos obligatorios no estén vacíos
            if (string.IsNullOrWhiteSpace(dto.Message) || string.IsNullOrWhiteSpace(dto.Module))
            {
                return Result<BotResponse>.Failure(400, "El Mensaje y el Módulo son obligatorios.");
            }

            // 2. Si no viene un chatId, generamos un identificador único para la conversación
            if (string.IsNullOrWhiteSpace(dto.chatId))
            {
                dto.chatId = Guid.NewGuid().ToString();
            }

            // 3. Obtenemos el System Prompt según el módulo solicitado
            var systemPrompt = botServices.GetPrompt(dto.Module);

            // 4. Obtenemos el historial previo de este chat y usuario
            var history = botServices.GetHistory(dto.chatId, request.UserId);

            // 5. Parseamos el historial previo a la estructura que requiere Gemini
            var contentList = new List<Content>();
            if (history != null && history.Any())
            {
                foreach (var item in history)
                {
                    if (item != null && !string.IsNullOrWhiteSpace(item.Content))
                    {
                        contentList.Add(new Content 
                        { 
                            Role = item.Role ?? "user", 
                            Parts = new List<Part> { new Part { Text = item.Content } } 
                        });
                    }
                }
            }

            // 6. Añadimos el mensaje actual del usuario al contexto para Gemini
            contentList.Add(new Content
            {
                Role = "user",
                Parts = new List<Part> { new Part { Text = dto.Message } }
            });

            // 7. Inicializamos el cliente de Gemini y configuración
            var apiKey = cfg["Gemini:ApiKey"] ?? System.Environment.GetEnvironmentVariable("GEMINI_API_KEY") ?? "";
            var modelName = cfg["Gemini:Model"] ?? "gemini-3.6-flash";
            var ai = new Client(apiKey: apiKey);

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
                    var response = await ai.Models.GenerateContentAsync(
                        model: modelName,
                        contents: contentList,
                        config: config,
                        cancellationToken: cancellationToken
                    );

                    respuesta = response.Text ?? "Algo ocurrió al procesar la respuesta, por favor intenta nuevamente.";
                    break;
                }
                catch (Google.GenAI.ServerError)
                {
                    intentos++;
                    if (intentos >= maxIntentos)
                    {
                        return Result<BotResponse>.Failure(503, "El Servicio de IA está saturado temporalmente, intenta de nuevo más tarde.");     
                    }
                    await Task.Delay(10000, cancellationToken);
                }
            }

            // 8. Al responder exitosamente, guardamos en el historial con los parámetros en el orden correcto (chatId, userId, message, role)
            botServices.AddToUserHistory(dto.chatId, request.UserId, dto.Message, "user");
            botServices.AddToUserHistory(dto.chatId, request.UserId, respuesta, "model");

            // 9. Retornamos la respuesta con el ChatId correspondiente
            return Result<BotResponse>.Success(200, new BotResponse 
            { 
                ChatId = dto.chatId, 
                Response = respuesta 
            }, "Operación realizada correctamente.", true);
        }
    }
}