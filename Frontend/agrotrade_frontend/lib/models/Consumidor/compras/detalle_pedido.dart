class DetallePedidoConsumidor {
  final int idDetallePedido;
  final int idPedido;
  final int idInventario;
  final double cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetallePedidoConsumidor({
    required this.idDetallePedido,
    required this.idPedido,
    required this.idInventario,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetallePedidoConsumidor.fromJson(Map<String, dynamic> json) {
    return DetallePedidoConsumidor(
      idDetallePedido: json['idDetallePedido'] as int,
      idPedido: json['idPedido'] as int,
      idInventario: json['idInventario'] as int,
      cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0.0,
      precioUnitario: (json['precioUnitario'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDetallePedido': idDetallePedido,
      'idPedido': idPedido,
      'idInventario': idInventario,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  String get subtotalFormateado {
    return '\$${subtotal.toStringAsFixed(2)}';
  }
}
