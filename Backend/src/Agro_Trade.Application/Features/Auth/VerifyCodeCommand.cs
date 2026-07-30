using MediatR;
using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.AuthServices;

namespace Agro_Trade.Application.Features.Auth
{
    public record VerifyCodeCommand(VerifyCodeDto dto) : IRequest<Result<LoginResponse>>;
}
