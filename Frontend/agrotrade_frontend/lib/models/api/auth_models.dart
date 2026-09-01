import 'json_helpers.dart';

class LoginResponseDto {
  final String userName;
  final String token;
  final List<String> roles;

  const LoginResponseDto({
    required this.userName,
    required this.token,
    required this.roles,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      userName: readString(json, const ['UserName', 'userName']) ?? '',
      token: readString(json, const ['Token', 'token']) ?? '',
      roles:
          (json['Roles'] ?? json['roles'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }
}

class LoginRequestDto {
  final String email;
  final String password;

  const LoginRequestDto({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class GoogleSignInRequestDto {
  final String idToken;

  const GoogleSignInRequestDto({required this.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};
}
