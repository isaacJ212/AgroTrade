using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.BotCommunication;
using Agro_Trade.Application.Common.Interface;
using MediatR;

namespace Agro_Trade.Application.Features.AgroBot.Queries
{
    public record GetUserConversationsQuery(string UserId) : IRequest<Result<List<BotConversation>>>;

    public class GetUserConversationsQueryHandler(IBotServices botServices) 
        : IRequestHandler<GetUserConversationsQuery, Result<List<BotConversation>>>
    {
        public Task<Result<List<BotConversation>>> Handle(GetUserConversationsQuery request, CancellationToken cancellationToken)
        {
            if (string.IsNullOrWhiteSpace(request.UserId))
            {
                return Task.FromResult(Result<List<BotConversation>>.Failure(400, "El UserId es requerido."));
            }

            var conversations = botServices.GetUserHistory(request.UserId);
            return Task.FromResult(Result<List<BotConversation>>.Success(200, conversations, "Conversaciones obtenidas correctamente.", true));
        }
    }
}
