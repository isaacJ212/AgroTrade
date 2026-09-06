class ImpactoSocial {
  final int idImpacto;
  final int idProveedor;
  final int idPedido;
  final int idDetallePedido;
  final DateTime fechaRegistro;
  final double productosSalvados;
  final double beneficioExtraProductor;

  const ImpactoSocial({
    required this.idImpacto,
    required this.idProveedor,
    required this.idPedido,
    required this.idDetallePedido,
    required this.fechaRegistro,
    required this.productosSalvados,
    required this.beneficioExtraProductor,
  });

  factory ImpactoSocial.fromJson(Map<String, dynamic> json) {
    return ImpactoSocial(
      idImpacto: json['idImpacto'] as int,
      idProveedor: json['idProveedor'] as int,
      idPedido: json['idPedido'] as int,
      idDetallePedido: json['idDetallePedido'] as int,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.tryParse(json['fechaRegistro'] as String) ?? DateTime.now()
          : DateTime.now(),
      productosSalvados: (json['productosSalvados'] as num?)?.toDouble() ?? 0.0,
      beneficioExtraProductor: (json['beneficioExtraProductor'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idImpacto': idImpacto,
      'idProveedor': idProveedor,
      'idPedido': idPedido,
      'idDetallePedido': idDetallePedido,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'productosSalvados': productosSalvados,
      'beneficioExtraProductor': beneficioExtraProductor,
    };
  }

  String get beneficioFormateado {
    return '\$${beneficioExtraProductor.toStringAsFixed(2)}';
  }
}
