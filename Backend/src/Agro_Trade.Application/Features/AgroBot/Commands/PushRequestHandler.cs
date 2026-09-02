using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using Google.GenAI;
using Google.GenAI.Types;
using MediatR;
using Microsoft.Extensions.Configuration;

namespace Agro_Trade.Application.Features.AgroBot.Commands
{
    public record PushRequest(BotRequest BotRequest) : IRequest<Result<BotResponse>>;
    public class PushRequestHandler(IBotServices botServices, IConfiguration cfg) : IRequestHandler<PushRequest, Result<BotResponse>>
    {
        public async Task<Result<BotResponse>> Handle(PushRequest request, CancellationToken cancellationToken)
        {
            var dto = request.BotRequest;
            // INICIALIZAMOS EL CLIENTE DE GEMINI
            var apiKey = cfg["Gemini:ApiKey"] ?? System.Environment.GetEnvironmentVariable("GEMINI_API_KEY") ?? "";
            var ai = new Client(apiKey: apiKey);
            // VALIDAMOS QUE LOS CAMPOS NO ESTÉN VACÍOS AUNQUE EL MENSAJE SI PODRIA ESTAR MEJOR PREVENIR
            if(string.IsNullOrWhiteSpace(dto.UserId) || string.IsNullOrWhiteSpace(dto.Message) || string.IsNullOrWhiteSpace(dto.Module))
            {
                return Result<BotResponse>.Failure(400,"El Mensaje No Puede Estar Vacío.");
            }
            //OBTENEMOS EL SYSTEM PROMPT SEGUN EL MODULO EN EL QUE SE ENCUENTRE, TAMBIEN OBTENEMOS EL HISTORIAL DEL CHAT
            var systemPrompt = botServices.GetPrompt(dto.Module);
            
            botServices.AddToUserHistory(dto.UserId, dto.Message, "user");
            var history = botServices.GetHistory(dto.UserId);
            // PARSEAMOS EL HISTORIAL A LA ESTRUCTURA QUE REQUIERE GEMINI
            var contentList = new List<Content>();
            foreach(var item in history)
            {
                contentList.Add(new Content { Role = item.Role, Parts = {new Part { Text = item.Content }} });
            }
            // SEGUN LO QUE ENTENDI LA TEMPERATURA ES PARA CONTROLAR LA CREATIVIDAD DE LA RESPUESTA, ENTRE MAS ALTA MAS CREATIVA, ENTRE MAS BAJA MAS CONSERVADORA
            var config = new GenerateContentConfig
            {
                SystemInstruction = new Content
                {
                    Parts = {new Part {Text = systemPrompt}}
                },
                Temperature = 0.3f
            };
            // POR FUN CONSUMIMOS LA API
            var response = await ai.Models.GenerateContentAsync(
                model: "gemini-2.5-flash",
                contents: contentList,
                config: config,
                cancellationToken : cancellationToken
            );

            string respuesta = response.Text ?? "Algo Fue mal y no se genero la respuesta, por favor intente de nuevo.";
            botServices.AddToUserHistory(dto.UserId, respuesta, "model");

            return Result<BotResponse>.Success(200, new BotResponse { Response = respuesta }, "Operación realizada correctamente.", true);
            
            
        }
     
}}