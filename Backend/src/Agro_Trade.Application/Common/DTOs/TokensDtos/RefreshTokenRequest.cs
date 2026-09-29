using System.ComponentModel.DataAnnotations;

namespace Agro_Trade.Application.Common.DTOs.TokensDtos;

public record RefreshTokenRequest([Required] string RefreshToken);
public record RefreshTokenResult(string RawToken, string HashedToken, DateTime ExpiresAtUtc);
public record RevokeAllSessionsRequest(string? RefreshToken);

public record SessionResponse(
    Guid Id,
    string IpAddress,
    string? UserAgent,
    string? DeviceName,
    DateTime CreatedAt,
    DateTime ExpiresAt
);

public record TokensResponse(
    string AccessToken,
    string RefreshToken,
    DateTime RefreshTokenExpiresAt
);