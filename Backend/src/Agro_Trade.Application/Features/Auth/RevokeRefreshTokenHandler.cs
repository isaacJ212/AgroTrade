using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.Auth;

public record RevokeRefreshTokenCommand(RefreshTokenRequest Request) : IRequest<Result<bool>>;

public sealed class RevokeRefreshTokenHandler : IRequestHandler<RevokeRefreshTokenCommand, Result<bool>>
{
    private readonly IRepository<RefreshToken> _refreshTokens;
    private readonly ITokenServices _tokenServices;
    private readonly IUnitofWork _unitOfWork;

    public RevokeRefreshTokenHandler(
        IRepository<RefreshToken> refreshTokens,
        ITokenServices tokenServices,
        IUnitofWork unitOfWork)
    {
        _refreshTokens = refreshTokens;
        _tokenServices = tokenServices;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result<bool>> Handle(RevokeRefreshTokenCommand request, CancellationToken cancellationToken)
    {
        var tokenHash = _tokenServices.ComputeHash(request.Request.RefreshToken);
        var storedToken = await _refreshTokens.FirstOrDefaultAsync(
            token => token.Hash == tokenHash && token.RevokedAt == null,
            cancellationToken);

        if (storedToken is not null)
        {
            storedToken.RevokedAt = DateTime.UtcNow;
            await _refreshTokens.UpdateAsync(storedToken, cancellationToken);
            await _unitOfWork.SaveChangesAsync(cancellationToken);
        }

        // Idempotent response: do not disclose whether a token was found or already revoked.
        return Result<bool>.Success(200, true, "La sesión quedó revocada si el token estaba activo.", true);
    }
}