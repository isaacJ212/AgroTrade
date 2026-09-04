class Suscripcion {
  final int idSuscripcionApp;
  final int idUsuario;
  final String tipoPlan;
  final double tarifaPago;
  final String? estado;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool renovacionAutomatica;
  final DateTime creadaEn;

  const Suscripcion({
    required this.idSuscripcionApp,
    required this.idUsuario,
    required this.tipoPlan,
    required this.tarifaPago,
    this.estado,
    required this.fechaInicio,
    this.fechaFin,
    this.renovacionAutomatica = true,
    required this.creadaEn,
  });

  factory Suscripcion.fromJson(Map<String, dynamic> json) {
    return Suscripcion(
      idSuscripcionApp: json['idSuscripcionApp'] as int,
      idUsuario: json['idUsuario'] as int,
      tipoPlan: json['tipoPlan'] as String? ?? '',
      tarifaPago: (json['tarifaPago'] as num?)?.toDouble() ?? 0.0,
      estado: json['estado'] as String?,
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.tryParse(json['fechaInicio'] as String) ?? DateTime.now()
          : DateTime.now(),
      fechaFin: json['fechaFin'] != null
          ? DateTime.tryParse(json['fechaFin'] as String)
          : null,
      renovacionAutomatica: json['renovacionAutomatica'] as bool? ?? true,
      creadaEn: json['creadaEn'] != null
          ? DateTime.tryParse(json['creadaEn'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSuscripcionApp': idSuscripcionApp,
      'idUsuario': idUsuario,
      'tipoPlan': tipoPlan,
      'tarifaPago': tarifaPago,
      'estado': estado,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'renovacionAutomatica': renovacionAutomatica,
      'creadaEn': creadaEn.toIso8601String(),
    };
  }
}
