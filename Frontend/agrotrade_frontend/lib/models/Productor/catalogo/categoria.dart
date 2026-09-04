class Categoria {
  final int idCategoria;
  final String nombre;

  const Categoria({
    required this.idCategoria,
    required this.nombre,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria'] as int,
      nombre: json['nombre'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
    };
  }
}
