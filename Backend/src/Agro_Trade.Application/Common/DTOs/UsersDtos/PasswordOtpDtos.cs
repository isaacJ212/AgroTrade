namespace Agro_Trade.Application.Common.DTOs.UsersDtos;

public sealed record VerifyChangePasswordOtpDto(string Code);

public sealed record ResetPasswordAfterOtpDto(string NewPassword);

public sealed record PasswordRecoveryEmailDto(string Email);

public sealed record VerifyPasswordRecoveryCodeDto(string Email, string Code);

public sealed record ResetPasswordByRecoveryCodeDto(string Email, string NewPassword);
