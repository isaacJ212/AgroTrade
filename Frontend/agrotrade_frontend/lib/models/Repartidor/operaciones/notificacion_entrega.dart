class NotificacionEntrega {
  final int idNotificacion;
  final int idPedido;
  final int idUsuarioRepartidor;
  final String zonaEntrega;
  final String estado;
  final DateTime fechaCreacion;

  const NotificacionEntrega({
    required this.idNotificacion,
    required this.idPedido,
    required this.idUsuarioRepartidor,
    required this.zonaEntrega,
    this.estado = "PENDIENTE",
    required this.fechaCreacion,
  });

  factory NotificacionEntrega.fromJson(Map<String, dynamic> json) {
    return NotificacionEntrega(
      idNotificacion: json['idNotificacion'] as int,
      idPedido: json['idPedido'] as int,
      idUsuarioRepartidor: json['idUsuarioRepartidor'] as int,
      zonaEntrega: json['zonaEntrega'] as String? ?? '',
      estado: json['estado'] as String? ?? 'PENDIENTE',
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.tryParse(json['fechaCreacion'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotificacion': idNotificacion,
      'idPedido': idPedido,
      'idUsuarioRepartidor': idUsuarioRepartidor,
      'zonaEntrega': zonaEntrega,
      'estado': estado,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  String get tiempoTranscurrido {
    final diferencia = DateTime.now().difference(fechaCreacion);
    if (diferencia.inMinutes < 1) return 'Justo ahora';
    if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours} h';
    return 'Hace ${diferencia.inDays} días';
  }
}
