class NotificacionEntrega {
  final int pedidoId;
  final String zonaEntrega;
  final double totalPedido;
  final DateTime fechaCreacion;
  final String horaLabel;
  final String estado ;

  const NotificacionEntrega({
    required this.estado,
    this.horaLabel = "Hora est",
    required this.pedidoId,
    required this.zonaEntrega,
    required this.totalPedido,
    required this.fechaCreacion,
  });

  factory NotificacionEntrega.fromJson(Map<String, dynamic> json) {
    return NotificacionEntrega(
      pedidoId: json['pedidoId'] as int,
      estado: json['estado'] as String? ?? '',
      zonaEntrega: json['zonaEntrega'] as String? ?? '',
      totalPedido: (json['totalPedido'] as num?)?.toDouble() ?? 0.0,
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pedidoId': pedidoId,
      'zonaEntrega': zonaEntrega,
      'totalPedido': totalPedido,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  String get totalFormateado {
    return '\$${totalPedido.toStringAsFixed(2)}';
  }

  String get tiempoTranscurrido {
    final diferencia = DateTime.now().difference(fechaCreacion);
    if (diferencia.inMinutes < 1) return 'Justo ahora';
    if (diferencia.inMinutes < 60) return 'Hace ${diferencia.inMinutes} min';
    if (diferencia.inHours < 24) return 'Hace ${diferencia.inHours} h';
    return 'Hace ${diferencia.inDays} días';
  }
}
