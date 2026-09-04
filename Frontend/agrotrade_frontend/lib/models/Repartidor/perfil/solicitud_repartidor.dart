import 'datos_repartidor.dart';

class SolicitudRepartidor {
  final int idSolicitud;
  final int idUsuario;
  final DatosRepartidor datosRepartidor;
  final String estado;
  final DateTime fechaSolicitud;

  const SolicitudRepartidor({
    required this.idSolicitud,
    required this.idUsuario,
    required this.datosRepartidor,
    this.estado = "pendiente",
    required this.fechaSolicitud,
  });

  factory SolicitudRepartidor.fromJson(Map<String, dynamic> json) {
    return SolicitudRepartidor(
      idSolicitud: json['idSolicitud'] as int,
      idUsuario: json['idUsuario'] as int,
      datosRepartidor: json['datos_repartidor'] != null 
          ? DatosRepartidor.fromJson(json['datos_repartidor'])
          : DatosRepartidor.fromJson({}),
      estado: json['estado'] as String? ?? 'pendiente',
      fechaSolicitud: json['fechaSolicitud'] != null
          ? DateTime.tryParse(json['fechaSolicitud'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSolicitud': idSolicitud,
      'idUsuario': idUsuario,
      'datos_repartidor': datosRepartidor.toJson(),
      'estado': estado,
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
    };
  }
}
