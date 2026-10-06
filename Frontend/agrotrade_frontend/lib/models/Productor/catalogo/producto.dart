class Producto {
  final int idProducto;
  final int idCategoria;
  final int idProveedor;
  final String nombre;
  final String? descripcion;
  final String unidadMedida;

  const Producto({
    required this.idProducto,
    required this.idCategoria,
    required this.idProveedor,
    required this.nombre,
    this.descripcion,
    required this.unidadMedida,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'] as int,
      idCategoria: json['idCategoria'] as int,
      idProveedor: json['idProveedor'] as int,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      unidadMedida: json['unidadMedida'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'idCategoria': idCategoria,
      'idProveedor': idProveedor,
      'nombre': nombre,
      'descripcion': descripcion,
      'unidadMedida': unidadMedida,
    };
  }
}
