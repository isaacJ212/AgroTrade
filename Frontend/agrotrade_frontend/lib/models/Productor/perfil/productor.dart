class Productor {
  final int idProveedor;
  final int idUsuario;
  final String nombreProveedor;
  final String? nombreFinca;
  final String? ubicacionGps;
  final String? biografia;
  final double calificacionPromedio;
  final String? banco;
  final int? idCuentaBancaria;

  const Productor({
    required this.idProveedor,
    required this.idUsuario,
    required this.nombreProveedor,
    this.nombreFinca,
    this.ubicacionGps,
    this.biografia,
    this.calificacionPromedio = 0.0,
    this.banco,
    this.idCuentaBancaria,
  });

  factory Productor.fromJson(Map<String, dynamic> json) {
    return Productor(
      idProveedor: json['idProveedor'] as int,
      idUsuario: json['idUsuario'] as int,
      nombreProveedor: json['nombreProveedor'] as String? ?? '',
      nombreFinca: json['nombreFinca'] as String?,
      ubicacionGps: json['ubicacionGps'] as String?,
      biografia: json['biografia'] as String?,
      calificacionPromedio:
          (json['calificacionPromedio'] as num?)?.toDouble() ?? 0.0,
      banco: json['banco'] as String?,
      idCuentaBancaria: json['idCuentaBancaria'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProveedor': idProveedor,
      'idUsuario': idUsuario,
      'nombreProveedor': nombreProveedor,
      'nombreFinca': nombreFinca,
      'ubicacionGps': ubicacionGps,
      'biografia': biografia,
      'calificacionPromedio': calificacionPromedio,
      'banco': banco,
      'idCuentaBancaria': idCuentaBancaria,
    };
  }
}
