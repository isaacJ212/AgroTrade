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

class UnidadMedidaModel {
  final int id;
  final String nombre;
  final String codigo;
  final int? factor;
  final int? idBase;

  const UnidadMedidaModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.factor,
    this.idBase,
  });

  factory UnidadMedidaModel.fromJson(Map<String, dynamic> json) {
    return UnidadMedidaModel(
      id: json['id'] as int? ?? (json['idUnidadMedida'] as int? ?? 0),
      nombre: json['nombre'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      factor: json['factor'] as int?,
      idBase: json['idBase'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'codigo': codigo,
    'factor': factor,
    'idBase': idBase,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnidadMedidaModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$nombre ($codigo)';

  static const List<UnidadMedidaModel> defaultUnidades = [
    UnidadMedidaModel(id: 1, nombre: 'Kilogramo', codigo: 'kg'),
    UnidadMedidaModel(id: 2, nombre: 'Gramo', codigo: 'g'),
    UnidadMedidaModel(id: 3, nombre: 'Libra', codigo: 'lb'),
    UnidadMedidaModel(id: 4, nombre: 'Quintal', codigo: 'qq'),
    UnidadMedidaModel(id: 5, nombre: 'Unidad', codigo: 'und'),
    UnidadMedidaModel(id: 6, nombre: 'Litro', codigo: 'L'),
    UnidadMedidaModel(id: 7, nombre: 'Mililitro', codigo: 'mL'),
    UnidadMedidaModel(id: 8, nombre: 'Docena', codigo: 'dz'),
    UnidadMedidaModel(id: 9, nombre: 'Caja', codigo: 'cj'),
    UnidadMedidaModel(id: 10, nombre: 'Tonelada', codigo: 't'),
  ];
}

int resolverIdUnidadMedida(dynamic valor) {
  if (valor == null) return 1;
  if (valor is int && valor > 0) return valor;
  final str = valor.toString().trim();
  final parsed = int.tryParse(str);
  if (parsed != null && parsed > 0) return parsed;

  final lower = str.toLowerCase();
  return switch (lower) {
    'kg' || 'kilogramo' || 'kilogramos' => 1,
    'g' || 'gr' || 'gramo' || 'gramos' => 2,
    'lb' || 'libra' || 'libras' => 3,
    'qq' || 'quintal' || 'quintales' => 4,
    'und' || 'unidad' || 'unidades' => 5,
    'l' || 'litro' || 'litros' => 6,
    'ml' || 'mililitro' || 'mililitros' => 7,
    'dz' || 'docena' || 'docenas' => 8,
    'cj' || 'caja' || 'cajas' => 9,
    't' || 'tonelada' || 'toneladas' => 10,
    _ => 1,
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
  final int idUnidadMedida;
  const Producto({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    required this.precio,
    required this.estado,
    required this.imagenUrl,
    this.idUnidadMedida = 1,
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
    int? idUnidadMedida,
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
      idUnidadMedida: idUnidadMedida ?? this.idUnidadMedida,
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
  final int idCliente;
  final DateTime fecha;
  final EstadoPedido estado;
  final List<LineaPedido> productos;
  final double envio;
  final double? latitud;
  final double? longitud;
  const PedidoRecibido({
    required this.codigo,
    required this.cliente,
    required this.idCliente,
    required this.fecha,
    required this.estado,
    required this.productos,
    this.direccion = '',
    this.nota = '',
    this.envio = 0,
    this.latitud,
    this.longitud,
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
    idCliente: idCliente,
    fecha: fecha,
    estado: estado ?? this.estado,
    productos: productos ?? this.productos,
    direccion: direccion,
    nota: nota,
    envio: envio,
    latitud: latitud,
    longitud: longitud,
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

class Conversacion {
  final int idConversacion, idPedido, idCliente, idProductor;
  final DateTime creadaEn;
  const Conversacion({
    required this.idConversacion,
    required this.idPedido,
    required this.idCliente,
    required this.idProductor,
    required this.creadaEn,
  });
}

class MensajeChat {
  final int idMensaje, idConversacion, idEmisor;
  final String nombreEmisor, contenido;
  final DateTime enviadoEn;
  final bool leido, isOffline;
  const MensajeChat({
    required this.idMensaje,
    required this.idConversacion,
    required this.idEmisor,
    required this.nombreEmisor,
    required this.contenido,
    required this.enviadoEn,
    this.leido = false,
    this.isOffline = false,
  });
}
