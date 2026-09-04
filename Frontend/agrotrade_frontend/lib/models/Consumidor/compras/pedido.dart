class PedidoConsumidor {
  final int idPedido;
  final int idUsuarioCliente;
  final DateTime fechaPedido;
  final double total;
  final String? metodoPago;
  final String? estadoPago;
  final String? estadoEnvio;

  const PedidoConsumidor({
    required this.idPedido,
    required this.idUsuarioCliente,
    required this.fechaPedido,
    required this.total,
    this.metodoPago,
    this.estadoPago,
    this.estadoEnvio,
  });

  factory PedidoConsumidor.fromJson(Map<String, dynamic> json) {
    return PedidoConsumidor(
      idPedido: json['idPedido'] as int,
      idUsuarioCliente: json['idUsuarioCliente'] as int,
      fechaPedido: json['fechaPedido'] != null
          ? DateTime.tryParse(json['fechaPedido'] as String) ?? DateTime.now()
          : DateTime.now(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      metodoPago: json['metodoPago'] as String?,
      estadoPago: json['estadoPago'] as String?,
      estadoEnvio: json['estadoEnvio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPedido': idPedido,
      'idUsuarioCliente': idUsuarioCliente,
      'fechaPedido': fechaPedido.toIso8601String(),
      'total': total,
      'metodoPago': metodoPago,
      'estadoPago': estadoPago,
      'estadoEnvio': estadoEnvio,
    };
  }

  String get totalFormateado {
    return '\$${total.toStringAsFixed(2)}';
  }

  String get fechaFormateada {
    return '${fechaPedido.day}/${fechaPedido.month}/${fechaPedido.year}';
  }
}
