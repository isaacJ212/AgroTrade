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
    final rawRoles = json['Roles'] ?? json['roles'];
    final rolesList = rawRoles is List ? rawRoles.map((e) => e.toString()).toList() : <String>[];
    return LoginResponseDto(
      userName: readString(json, const ['UserName', 'userName']) ?? '',
      token: readString(json, const ['Token', 'token']) ?? '',
      roles: rolesList,
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
