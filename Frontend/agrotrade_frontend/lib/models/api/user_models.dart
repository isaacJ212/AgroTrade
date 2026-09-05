import 'json_helpers.dart';

class CreateUserRequestDto {
  final String nombreCompleto;
  final String email;
  final String password;
  final String? telefono;
  final String? direccionBase;
  final String? departamento;
  final int? idRol;

  const CreateUserRequestDto({
    required this.nombreCompleto,
    required this.email,
    required this.password,
    this.telefono,
    this.direccionBase,
    this.departamento,
    this.idRol,
  });

  Map<String, dynamic> toJson() => {
        'nombreCompleto': nombreCompleto,
        'email': email,
        'password': password,
        if (telefono != null && telefono!.isNotEmpty) 'telefono': telefono,
        if (direccionBase != null && direccionBase!.isNotEmpty) 'direccionBase': direccionBase,
        if (departamento != null && departamento!.isNotEmpty) 'departamento': departamento,
        if (idRol != null) 'idRol': idRol,
      };
}

class UpdateUserRequestDto {
  final String? nombreCompleto;
  final String? email;
  final String? telefono;
  final String? direccionBase;
  final String? departamento;

  const UpdateUserRequestDto({
    this.nombreCompleto,
    this.email,
    this.telefono,
    this.direccionBase,
    this.departamento,
  });

  Map<String, dynamic> toJson() => {
        if (nombreCompleto != null) 'nombreCompleto': nombreCompleto,
        if (email != null) 'email': email,
        if (telefono != null) 'telefono': telefono,
        if (direccionBase != null) 'direccionBase': direccionBase,
        if (departamento != null) 'departamento': departamento,
      };
}

class UpdatePasswordRequestDto {
  final String currentPassword;
  final String newPassword;

  const UpdatePasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };
}

class UserDto {
  final int id;
  final String name;
  final String email;
  final bool identidadVerificada;
  final String? telefono;
  final String? direccionBase;
  final String? departamento;
  final String estadoCuenta;
  final DateTime? fechaRegistro;
  final List<String> roles;

  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.identidadVerificada,
    this.telefono,
    this.direccionBase,
    this.departamento,
    this.estadoCuenta = '',
    this.fechaRegistro,
    this.roles = const [],
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: readInt(json, const ['Id', 'id']) ?? 0,
      name: readString(json, const ['Name', 'name']) ?? '',
      email: readString(json, const ['Email', 'email']) ?? '',
      identidadVerificada: readBool(json, const ['IdentidadVerificada', 'identidadVerificada']) ?? false,
      telefono: readString(json, const ['Telefono', 'telefono']),
      direccionBase: readString(json, const ['DireccionBase', 'direccionBase']),
      departamento: readString(json, const ['Departamento', 'departamento']),
      estadoCuenta: readString(json, const ['EstadoCuenta', 'estadoCuenta']) ?? '',
      fechaRegistro: readDateTime(json, const ['FechaRegistro', 'fechaRegistro']),
      roles: (json['Roles'] ?? json['roles'] as List?)?.map<String>((e) => e.toString()).toList() ?? <String>[],
    );
  }
}

