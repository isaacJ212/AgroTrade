class Producto {
  final int idProducto;
  final int idCategoria;
  final int idProveedor;
  final String nombre;
  final String? descripcion;
  final int idUnidadMedida;
  final String? unidadMedida;

  const Producto({
    required this.idProducto,
    required this.idCategoria,
    required this.idProveedor,
    required this.nombre,
    this.descripcion,
    required this.idUnidadMedida,
    this.unidadMedida,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'] as int? ?? 0,
      idCategoria: json['idCategoria'] as int? ?? 0,
      idProveedor: json['idProveedor'] as int? ?? 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      idUnidadMedida: json['idUnidadMedida'] as int? ?? 1,
      unidadMedida: json['unidadMedida'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'idCategoria': idCategoria,
      'idProveedor': idProveedor,
      'nombre': nombre,
      'descripcion': descripcion,
      'idUnidadMedida': idUnidadMedida,
      if (unidadMedida != null) 'unidadMedida': unidadMedida,
    };
  }
}
