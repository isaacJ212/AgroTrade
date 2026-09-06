using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using MediatR;

namespace Agro_Trade.Application.Features.AgroBot.Queries
{
    public record GetChatHistoryQuery(string ChatId, string UserId) : IRequest<Result<List<History>>>;

    public class GetChatHistoryQueryHandler(IBotServices botServices) 
        : IRequestHandler<GetChatHistoryQuery, Result<List<History>>>
    {
        public Task<Result<List<History>>> Handle(GetChatHistoryQuery request, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(request.ChatId) || string.IsNullOrWhiteSpace(request.UserId))
            {
                return Task.FromResult(Result<List<History>>.Failure(400, "El ChatId y el UserId son requeridos."));
            }

            var history = botServices.GetHistory(request.ChatId, request.UserId);
            return Task.FromResult(Result<List<History>>.Success(200, history, "Historial obtenido correctamente.", true));
        }
    }
}
