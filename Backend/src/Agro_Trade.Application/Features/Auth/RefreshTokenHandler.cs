using Agro_Trade.Application.Common;
using Agro_Trade.Application.Common.DTOs.TokensDtos;
using Agro_Trade.Application.Common.Interface;
using Agro_Trade.Domain.Entities;
using MediatR;

namespace Agro_Trade.Application.Features.Auth;

public record RefreshTokenCommand(RefreshTokenRequest Request) : IRequest<Result<TokensResponse>>;

public sealed class RefreshTokenHandler : IRequestHandler<RefreshTokenCommand, Result<TokensResponse>>
{
    private readonly IUnitofWork _unitOfWork;
    private readonly IRepository<RefreshToken> _refreshTokens;
    private readonly ITokenServices _tokenServices;
    private readonly IAppContext _appContext;

    public RefreshTokenHandler(
        IUnitofWork unitOfWork,
        IRepository<RefreshToken> refreshTokens,
        ITokenServices tokenServices,
        IAppContext appContext)
    {
        _unitOfWork = unitOfWork;
        _refreshTokens = refreshTokens;
        _tokenServices = tokenServices;
        _appContext = appContext;
    }

    public async Task<Result<TokensResponse>> Handle(
        RefreshTokenCommand request,
        CancellationToken cancellationToken)
    {
        var tokenHash = _tokenServices.ComputeHash(request.Request.RefreshToken);
        var currentToken = await _refreshTokens.FirstOrDefaultAsync(
            token => token.Hash == tokenHash,
            cancellationToken);

        if (currentToken is null ||
            currentToken.IsRevoked ||
            currentToken.ExpiresAt <= DateTime.UtcNow)
        {
            return Result<TokensResponse>.Failure(401, "El refresh token no es válido o ha expirado.");
        }

        var user = await _unitOfWork.Users.GetByIdAsync(currentToken.UserId, cancellationToken);
        if (user is null || !string.Equals(user.EstadoCuenta, "Activo", StringComparison.OrdinalIgnoreCase))
        {
            return Result<TokensResponse>.Failure(401, "El usuario no está disponible.");
        }

        var nextToken = _tokenServices.GenerateRefreshToken();
        var nextRefreshToken = new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = user.IdUsuario,
            ExpiresAt = nextToken.ExpiresAtUtc,
            CreatedAt = DateTime.UtcNow,
            Hash = nextToken.HashedToken,
            CreatedByIp = _appContext.IpAdress
        };

        currentToken.RevokedAt = DateTime.UtcNow;
        await _refreshTokens.UpdateAsync(currentToken, cancellationToken);
        await _refreshTokens.AddAsync(nextRefreshToken, cancellationToken);

        var accessToken = await _tokenServices.GenerateTokenAsync(user, nextRefreshToken.Id);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result<TokensResponse>.Success(
            200,
            new TokensResponse(accessToken, nextToken.RawToken, nextToken.ExpiresAtUtc),
            "Tokens renovados correctamente.",
            true);
    }
}