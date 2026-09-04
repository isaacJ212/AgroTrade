class Inventario {
  final int idInventario;
  final int idProveedor;
  final int idProducto;
  final String? fotoUrl;
  final String? videoUrl;
  final double stockActual;
  final double costoProduccion;
  final double precioVenta;
  final bool esOfertaExcedente;
  final double? porcentajeDescuento;
  final DateTime? fechaCosecha;
  final bool disponible;

  const Inventario({
    required this.idInventario,
    required this.idProveedor,
    required this.idProducto,
    this.fotoUrl,
    this.videoUrl,
    required this.stockActual,
    required this.costoProduccion,
    required this.precioVenta,
    required this.esOfertaExcedente,
    this.porcentajeDescuento,
    this.fechaCosecha,
    required this.disponible,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      idInventario: json['idInventario'] as int,
      idProveedor: json['idProveedor'] as int,
      idProducto: json['idProducto'] as int,
      fotoUrl: json['fotoUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      stockActual: (json['stockActual'] as num?)?.toDouble() ?? 0.0,
      costoProduccion: (json['costoProduccion'] as num?)?.toDouble() ?? 0.0,
      precioVenta: (json['precioVenta'] as num?)?.toDouble() ?? 0.0,
      esOfertaExcedente: json['esOfertaExcedente'] as bool? ?? false,
      porcentajeDescuento: (json['porcentajeDescuento'] as num?)?.toDouble(),
      fechaCosecha: json['fechaCosecha'] != null
          ? DateTime.tryParse(json['fechaCosecha'] as String)
          : null,
      disponible: json['disponible'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idInventario': idInventario,
      'idProveedor': idProveedor,
      'idProducto': idProducto,
      'fotoUrl': fotoUrl,
      'videoUrl': videoUrl,
      'stockActual': stockActual,
      'costoProduccion': costoProduccion,
      'precioVenta': precioVenta,
      'esOfertaExcedente': esOfertaExcedente,
      'porcentajeDescuento': porcentajeDescuento,
      'fechaCosecha': fechaCosecha?.toIso8601String(),
      'disponible': disponible,
    };
  }

  String get precioVentaFormateado {
    return '\$${precioVenta.toStringAsFixed(2)}';
  }
}
