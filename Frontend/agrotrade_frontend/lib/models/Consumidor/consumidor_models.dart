class ProductoMercado {
  final int id;
  final String nombre;
  final String finca;
  final double precio;
  final String unidad;
  final String distancia;
  final String categoria;
  final bool pocoInventario;
  final String imagenUrl;
  final String? descripcion;
  final double? calificacion;
  final int? valoraciones;
  final bool cosechadoHoy;

  const ProductoMercado({
    required this.id,
    required this.nombre,
    required this.finca,
    required this.precio,
    required this.unidad,
    required this.distancia,
    required this.categoria,
    required this.imagenUrl,
    this.pocoInventario = false,
    this.descripcion,
    this.calificacion,
    this.valoraciones,
    this.cosechadoHoy = false,
  });
}

class ProductoCercano {
  final String nombre;
  final String finca;
  final double precio;
  final String unidad;
  final String distancia;
  final String imagenUrl;

  const ProductoCercano({
    required this.nombre,
    required this.finca,
    required this.precio,
    required this.unidad,
    required this.distancia,
    required this.imagenUrl,
  });
}

class OfertaExcedente {
  final String nombre;
  final double precio;
  final double precioOriginal;
  final int descuento;
  final String vigencia;
  final String imagenUrl;

  const OfertaExcedente({
    required this.nombre,
    required this.precio,
    required this.precioOriginal,
    required this.descuento,
    required this.vigencia,
    required this.imagenUrl,
  });
}

class PedidoConsumidor {
  final String id;
  final String fecha;
  final String estado;
  final double total;
  final int itemsCount;

  const PedidoConsumidor({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.total,
    required this.itemsCount,
  });
}

class PaginatedResponse<T> {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final List<T> items;

  const PaginatedResponse({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });
}
