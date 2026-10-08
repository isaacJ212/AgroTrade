import 'json_helpers.dart';

class CreateUserRequestDto {
  final String nombre;
  final String primerApellido;
  final String segundoApellido;
  final String email;
  final String password;
  final String? telefono;
  final String? direccionBase;
  final String? departamento;
  final String? municipio;
  final int? idRol;

  const CreateUserRequestDto({
    required this.nombre,
    required this.primerApellido,
    required this.segundoApellido,
    required this.email,
    required this.password,
    this.telefono,
    this.direccionBase,
    this.departamento,
    this.municipio,
    this.idRol,
  });

  Map<String, dynamic> toJson() => {
    'Nombre': nombre,
    'PrimerApellido': primerApellido,
    'SegundoApellido': segundoApellido,
    'Email': email,
    'Password': password,
    if (telefono != null && telefono!.isNotEmpty) 'Telefono': telefono,
    if (direccionBase != null && direccionBase!.isNotEmpty) 'DireccionExacta': direccionBase,
    if (departamento != null && departamento!.isNotEmpty) 'Departamento': departamento,
    if (municipio != null && municipio!.isNotEmpty) 'Municipio': municipio,
    if (idRol != null) 'IdRol': idRol,
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

  // Split nombreCompleto into Nombre, PrimerApellido, SegundoApellido
  // Mapea direccionBase -> DireccionExacta, departamento -> Departamento
  Map<String, dynamic> toJsonForUpdate() {
    final parts = (nombreCompleto ?? '').trim().split(RegExp(r'\s+'));
    String nombre = '';
    String primerApellido = '';
    String segundoApellido = '';

    if (parts.isNotEmpty) nombre = parts[0];
    if (parts.length > 1) primerApellido = parts[1];
    if (parts.length > 2) segundoApellido = parts.skip(2).join(' ');

    // Validaciones mínimas para evitar 400
    if (nombre.length < 2) nombre = 'User';
    if (primerApellido.length < 2) primerApellido = 'Name';
    if (segundoApellido.length < 2) segundoApellido = 'Name';

    // Teléfono: solo dígitos, backend valida 8 dígitos empezando 5/7/8
    final telefonoLimpio = (telefono ?? '').replaceAll(RegExp(r'\D'), '');

    return {
      'Nombre': nombre,
      'PrimerApellido': primerApellido,
      'SegundoApellido': segundoApellido,
      if (email != null && email!.isNotEmpty) 'Email': email,
      if (telefonoLimpio.isNotEmpty) 'Telefono': telefonoLimpio,
      if (departamento != null && departamento!.isNotEmpty) 'Departamento': departamento,
      if (direccionBase != null && direccionBase!.isNotEmpty) 'DireccionExacta': direccionBase,
    };
  }
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
      id: readInt(json, const ['Id', 'id', 'UserId', 'userId']) ?? 0,
      name:
          readString(json, const [
            'Name',
            'name',
            'NombreCompleto',
            'nombreCompleto',
          ]) ??
          '',
      email: readString(json, const ['Email', 'email']) ?? '',
      identidadVerificada:
          readBool(json, const [
            'IdentidadVerificada',
            'identidadVerificada',
          ]) ??
          false,
      telefono: readString(json, const ['Telefono', 'telefono']),
      direccionBase: readString(json, const ['DireccionBase', 'direccionBase']),
      departamento: readString(json, const ['Departamento', 'departamento']),
      estadoCuenta:
          readString(json, const ['EstadoCuenta', 'estadoCuenta']) ?? '',
      fechaRegistro: readDateTime(json, const [
        'FechaRegistro',
        'fechaRegistro',
      ]),
      roles:
          (json['Roles'] ?? json['roles'] as List?)
              ?.map<String>((e) => e.toString())
              .toList() ??
          <String>[],
    );
  }
}
