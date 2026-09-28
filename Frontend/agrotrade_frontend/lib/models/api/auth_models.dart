import 'json_helpers.dart';

class LoginResponseDto {
  final String userName;
  final String token;
  final List<String> roles;
  final bool requiereCompletarInformacion;

  const LoginResponseDto({
    required this.userName,
    required this.token,
    required this.roles,
    this.requiereCompletarInformacion = false,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['Roles'] ?? json['roles'];
    final rolesList = rawRoles is List
        ? rawRoles.map<String>((e) => e.toString()).toList()
        : <String>[];
    return LoginResponseDto(
      userName: readString(json, const ['UserName', 'userName']) ?? '',
      token: readString(json, const ['Token', 'token']) ?? '',
      roles: rolesList,
      requiereCompletarInformacion:
          readBool(json, const [
            'RequiereCompletarInformacion',
            'requiereCompletarInformacion',
          ]) ??
          false,
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
  final int? idRol;
  const GoogleSignInRequestDto({required this.idToken, this.idRol});

  Map<String, dynamic> toJson() => {'idToken': idToken, 'idRol': idRol};
}

class GoogleCatchDataDto {
  final String departamento;
  final String direccionBase;
  final String telefono;

  const GoogleCatchDataDto({
    required this.departamento,
    required this.direccionBase,
    required this.telefono,
  });

  Map<String, dynamic> toJson() => {
    'departamento': departamento,
    'direccionBase': direccionBase,
    'telefono': telefono,
  };
}
