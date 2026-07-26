using MediatR;
using Meseta_Verde.Application.Common;
using Meseta_Verde.Application.Common.DTOs.AuthServices;

namespace Meseta_Verde.Application.Features.Auth
{
    public record VerifyCodeCommand(VerifyCodeDto dto) : IRequest<Result<LoginResponse>>;
}
