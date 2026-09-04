class LogisticaEntregaRepartidor {
  final int idEntrega;
  final int idPedido;
  final int idUsuarioRepartidor;
  final String? estadoActual;
  final String? ubicacionActual;
  final DateTime? fechaEstimada;
  final DateTime? fechaEntregaReal;

  const LogisticaEntregaRepartidor({
    required this.idEntrega,
    required this.idPedido,
    required this.idUsuarioRepartidor,
    this.estadoActual,
    this.ubicacionActual,
    this.fechaEstimada,
    this.fechaEntregaReal,
  });

  factory LogisticaEntregaRepartidor.fromJson(Map<String, dynamic> json) {
    return LogisticaEntregaRepartidor(
      idEntrega: json['idEntrega'] as int,
      idPedido: json['idPedido'] as int,
      idUsuarioRepartidor: json['idUsuarioRepartidor'] as int,
      estadoActual: json['estadoActual'] as String?,
      ubicacionActual: json['ubicacionActual'] as String?,
      fechaEstimada: json['fechaEstimada'] != null
          ? DateTime.tryParse(json['fechaEstimada'] as String)
          : null,
      fechaEntregaReal: json['fechaEntregaReal'] != null
          ? DateTime.tryParse(json['fechaEntregaReal'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEntrega': idEntrega,
      'idPedido': idPedido,
      'idUsuarioRepartidor': idUsuarioRepartidor,
      'estadoActual': estadoActual,
      'ubicacionActual': ubicacionActual,
      'fechaEstimada': fechaEstimada?.toIso8601String(),
      'fechaEntregaReal': fechaEntregaReal?.toIso8601String(),
    };
  }

  String get estadoAmigable {
    if (estadoActual == null) return 'Pendiente';
    return estadoActual!.toUpperCase();
  }
}
