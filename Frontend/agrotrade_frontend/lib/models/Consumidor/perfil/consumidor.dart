class Consumidor {
  final int idUsuario;
  final String nombreCompleto;
  final String email;
  final bool identidadVerificada;
  final String estadoCuenta;
  final String? telefono;
  final String? direccionBase;
  final String? departamento;
  final DateTime? fechaRegistro;

  const Consumidor({
    required this.idUsuario,
    required this.nombreCompleto,
    required this.email,
    required this.identidadVerificada,
    this.estadoCuenta = "Activo",
    this.telefono,
    this.direccionBase,
    this.departamento,
    this.fechaRegistro,
  });

  factory Consumidor.fromJson(Map<String, dynamic> json) {
    return Consumidor(
      idUsuario: json['idUsuario'] as int,
      nombreCompleto: json['nombreCompleto'] as String? ?? '',
      email: json['email'] as String? ?? '',
      identidadVerificada: json['identidadVerificada'] as bool? ?? false,
      estadoCuenta: json['estadoCuenta'] as String? ?? 'Activo',
      telefono: json['telefono'] as String?,
      direccionBase: json['direccionBase'] as String?,
      departamento: json['departamento'] as String?,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.tryParse(json['fechaRegistro'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreCompleto': nombreCompleto,
      'email': email,
      'identidadVerificada': identidadVerificada,
      'estadoCuenta': estadoCuenta,
      'telefono': telefono,
      'direccionBase': direccionBase,
      'departamento': departamento,
      'fechaRegistro': fechaRegistro?.toIso8601String(),
    };
  }
}
