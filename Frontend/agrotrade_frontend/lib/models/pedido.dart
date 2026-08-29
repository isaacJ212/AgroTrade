class Pedido {
  final int id;
  final String comprador;
  final String monto;
  final String estado;

  const Pedido({
    required this.id,
    required this.comprador,
    required this.monto,
    required this.estado,
  });
}
