import 'dart:typed_data';

String dinero(num value) => 'C\$ ${value.toStringAsFixed(2)}';
String numero(num value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(2);
String fechaCorta(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
double? decimal(String value) {
  final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
  return parsed != null && parsed.isFinite ? parsed : null;
}

enum EstadoProducto {
  disponible,
  pocoInventario,
  agotado;

  String get label => switch (this) {
    disponible => 'Disponible',
    pocoInventario => 'Poco inventario',
    agotado => 'Agotado',
  };
}

class Costo {
  final String concepto;
  final String monto;
  const Costo({required this.concepto, required this.monto});
}

class Producto {
  final int id;
  final String nombre, unidad, imagenUrl, categoria, sufijoPrecio, etiqueta;
  final double cantidad, precio, costoProduccion;
  final EstadoProducto estado;
  final String? cosecha, ubicacion, descripcion;
  final DateTime? fechaCosecha;
  final bool publicado;
  final List<Costo> costos;
  final List<Uint8List> fotos;
  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    required this.precio,
    required this.estado,
    required this.imagenUrl,
    this.categoria = 'Verduras',
    this.sufijoPrecio = '',
    this.etiqueta = 'Fresco',
    this.cosecha,
    this.ubicacion,
    this.descripcion,
    this.fechaCosecha,
    this.costoProduccion = 0,
    this.publicado = true,
    this.costos = const [],
    this.fotos = const [],
  });
  String get cantidadTexto => '${numero(cantidad)} $unidad';
  String get precioTexto => '${dinero(precio)} / $unidad';
  Producto copyWith({
    int? id,
    String? nombre,
    String? categoria,
    String? unidad,
    double? cantidad,
    double? precio,
    double? costoProduccion,
    String? descripcion,
    String? ubicacion,
    DateTime? fechaCosecha,
    bool? publicado,
    List<Uint8List>? fotos,
  }) {
    final stock = cantidad ?? this.cantidad;
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      unidad: unidad ?? this.unidad,
      cantidad: stock,
      precio: precio ?? this.precio,
      costoProduccion: costoProduccion ?? this.costoProduccion,
      estado: stock <= 0
          ? EstadoProducto.agotado
          : stock <= 15
          ? EstadoProducto.pocoInventario
          : EstadoProducto.disponible,
      imagenUrl: imagenUrl,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      fechaCosecha: fechaCosecha ?? this.fechaCosecha,
      cosecha: fechaCosecha != null ? fechaCorta(fechaCosecha) : cosecha,
      publicado: publicado ?? this.publicado,
      fotos: fotos ?? this.fotos,
      costos: costos,
      etiqueta: etiqueta,
      sufijoPrecio: sufijoPrecio,
    );
  }
}

enum EstadoPedido {
  pendiente,
  enPreparacion,
  listo,
  rechazado;

  String get label => switch (this) {
    pendiente => 'Pendiente',
    enPreparacion => 'En preparación',
    listo => 'Listo',
    rechazado => 'Rechazado',
  };
}

class LineaPedido {
  final int productoId;
  final String nombre, unidad, imagenUrl;
  final double cantidad, precio;
  final bool preparado;
  const LineaPedido({
    required this.productoId,
    required this.nombre,
    required this.unidad,
    required this.cantidad,
    required this.precio,
    this.imagenUrl = '',
    this.preparado = false,
  });
  double get total => cantidad * precio;
  LineaPedido conPreparacion(bool value) => LineaPedido(
    productoId: productoId,
    nombre: nombre,
    unidad: unidad,
    cantidad: cantidad,
    precio: precio,
    imagenUrl: imagenUrl,
    preparado: value,
  );
}

class PedidoRecibido {
  final String codigo, cliente, direccion, nota;
  final DateTime fecha;
  final EstadoPedido estado;
  final List<LineaPedido> productos;
  final double envio;
  const PedidoRecibido({
    required this.codigo,
    required this.cliente,
    required this.fecha,
    required this.estado,
    required this.productos,
    this.direccion = '',
    this.nota = '',
    this.envio = 0,
  });
  double get subtotal => productos.fold(0, (sum, p) => sum + p.total);
  double get monto => subtotal + envio;
  String get montoTexto => dinero(monto);
  int get preparados => productos.where((p) => p.preparado).length;
  bool get todoPreparado =>
      productos.isNotEmpty && preparados == productos.length;
  PedidoRecibido copyWith({
    EstadoPedido? estado,
    List<LineaPedido>? productos,
  }) => PedidoRecibido(
    codigo: codigo,
    cliente: cliente,
    fecha: fecha,
    estado: estado ?? this.estado,
    productos: productos ?? this.productos,
    direccion: direccion,
    nota: nota,
    envio: envio,
  );
}

class OfertaProductor {
  final int productoId;
  final double cantidad, descuento;
  final DateTime fin;
  final bool activa;
  const OfertaProductor({
    required this.productoId,
    required this.cantidad,
    required this.descuento,
    required this.fin,
    required this.activa,
  });
  bool vigente(DateTime now) =>
      activa && now.isBefore(DateTime(fin.year, fin.month, fin.day + 1));
}

class DatosFinca {
  final String nombre, ubicacion, cultivo, descripcion, portadaUrl;
  final double hectareas;
  final Uint8List? foto;
  const DatosFinca({
    required this.nombre,
    required this.ubicacion,
    required this.cultivo,
    required this.hectareas,
    required this.descripcion,
    required this.portadaUrl,
    this.foto,
  });
}

class DatosProductor {
  final String nombre, correo, telefono, ubicacion;
  final Uint8List? foto;
  const DatosProductor({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.ubicacion,
    this.foto,
  });
}
