import 'package:flutter/foundation.dart';
import '../models/productor_models.dart';
import 'api_session.dart';

/// Estado de sesión del frontend. No sustituye la API ni una base de datos.
/// Las pantallas comparten esta instancia; los formularios editan copias.
class ProductorStore extends ChangeNotifier {
  ProductorStore({DateTime? now}) {
    _cargar(now ?? DateTime.now());
  }
  static final ProductorStore instance = ProductorStore();
  final List<Producto> _productos = [];
  final List<PedidoRecibido> _pedidos = [];
  final Map<int, OfertaProductor> _ofertas = {};

  int _nextId = 4;
  String? _sessionToken;
  late DatosFinca finca;
  late DatosProductor persona;
  bool notificaciones = true;
  List<Producto> get productos => List.unmodifiable(_productos);
  List<PedidoRecibido> get pedidos => List.unmodifiable(_pedidos);
  List<OfertaProductor> get ofertas => List.unmodifiable(_ofertas.values);
  Producto? producto(int id) {
    for (final p in _productos) {
      if (p.id == id) return p;
    }
    return null;
  }

  PedidoRecibido? pedido(String codigo) {
    for (final p in _pedidos) {
      if (p.codigo == codigo) return p;
    }
    return null;
  }

  OfertaProductor? oferta(int id) => _ofertas[id];

  double precioActual(Producto p, {DateTime? now}) {
    final o = oferta(p.id);
    return o != null && o.vigente(now ?? DateTime.now())
        ? p.precio * (1 - o.descuento / 100)
        : p.precio;
  }

  void guardarProducto(Producto p) {
    if (p.nombre.trim().isEmpty ||
        !p.cantidad.isFinite ||
        p.cantidad < 0 ||
        !p.precio.isFinite ||
        p.precio <= 0 ||
        !p.costoProduccion.isFinite ||
        p.costoProduccion < 0 ||
        p.precio < p.costoProduccion ||
        p.fotos.length > 5) {
      throw StateError(
        'Revisa el nombre, las fotos, el inventario y los precios.',
      );
    }
    final index = _productos.indexWhere((item) => item.id == p.id);
    if (p.id != 0 && index < 0)
      throw StateError('El producto ya no está disponible.');
    if (index < 0) {
      _productos.add(p.copyWith(id: _nextId++));
    } else {
      _productos[index] = p;
    }
    final saved = index < 0 ? _productos.last : _productos[index];
    final o = _ofertas[saved.id];
    if (o != null && (o.cantidad > saved.cantidad || !saved.publicado)) {
      _ofertas[saved.id] = OfertaProductor(
        productoId: o.productoId,
        cantidad: o.cantidad,
        descuento: o.descuento,
        fin: o.fin,
        activa: false,
      );
    }
    notifyListeners();
  }

  void aplicarPrecio(int id, double precio) {
    final p = producto(id);
    if (p == null) throw StateError('Selecciona un producto del inventario.');
    guardarProducto(p.copyWith(precio: precio));
  }

  /// Sincroniza los productos traídos del API sin borrar pedidos/ofertas/conversaciones.
  void cargarDesdeApi(List<Producto> productosApi) {
    print('DEBUG: [ProductorStore] cargarDesdeApi → ${productosApi.length} productos');
    _productos.clear();
    _productos.addAll(productosApi);
    // Actualizar _nextId para evitar colisiones con IDs reales
    final maxId = _productos.isEmpty ? 4 : _productos.map((p) => p.id).reduce((a, b) => a > b ? a : b);
    _nextId = maxId + 1;
    notifyListeners();
  }

  /// Elimina un producto del store local (modo offline).
  void eliminarProducto(int id) {
    print('DEBUG: [ProductorStore] eliminarProducto id=$id');
    _productos.removeWhere((p) => p.id == id);
    _ofertas.remove(id);
    notifyListeners();
  }

  /// Sincroniza pedidos traídos del API sin borrar otras colecciones.
  void cargarPedidosDesdeApi(List<PedidoRecibido> pedidosApi) {
    print('DEBUG: [ProductorStore] cargarPedidosDesdeApi → ${pedidosApi.length} pedidos');
    _pedidos.clear();
    _pedidos.addAll(pedidosApi);
    notifyListeners();
  }

  void cambiarEstado(String codigo, EstadoPedido nuevo) {
    final i = _pedidos.indexWhere((p) => p.codigo == codigo);
    if (i < 0) throw StateError('Pedido no encontrado.');
    final p = _pedidos[i];
    final permitido =
        p.estado == EstadoPedido.pendiente &&
            (nuevo == EstadoPedido.enPreparacion ||
                nuevo == EstadoPedido.rechazado) ||
        p.estado == EstadoPedido.enPreparacion &&
            nuevo == EstadoPedido.listo &&
            p.todoPreparado;
    if (!permitido)
      throw StateError('Revisa el estado y la preparación del pedido.');
    if (nuevo == EstadoPedido.enPreparacion) {
      final cantidades = <int, double>{};
      for (final linea in p.productos) {
        final item = producto(linea.productoId);
        if (item == null ||
            !item.publicado ||
            item.unidad != linea.unidad ||
            !linea.cantidad.isFinite ||
            linea.cantidad <= 0) {
          throw StateError(
            'Revisa la disponibilidad de los productos del pedido.',
          );
        }
        cantidades[linea.productoId] =
            (cantidades[linea.productoId] ?? 0) + linea.cantidad;
      }
      for (final cantidad in cantidades.entries) {
        if (producto(cantidad.key)!.cantidad < cantidad.value) {
          throw StateError(
            'No hay inventario suficiente para confirmar este pedido.',
          );
        }
      }
      // Solo se descuenta al confirmar; volver a preparar no vuelve a descontar.
      for (final cantidad in cantidades.entries) {
        final index = _productos.indexWhere((item) => item.id == cantidad.key);
        final item = _productos[index];
        _productos[index] = item.copyWith(
          cantidad: item.cantidad - cantidad.value,
        );
        final o = _ofertas[item.id];
        if (o != null && o.cantidad > _productos[index].cantidad) {
          _ofertas[item.id] = OfertaProductor(
            productoId: o.productoId,
            cantidad: o.cantidad,
            descuento: o.descuento,
            fin: o.fin,
            activa: false,
          );
        }
      }
    }
    _pedidos[i] = p.copyWith(estado: nuevo);
    notifyListeners();
  }

  void preparar(String codigo, int linea, bool value) {
    final i = _pedidos.indexWhere((p) => p.codigo == codigo);
    if (i < 0) throw StateError('Pedido no encontrado.');
    final p = _pedidos[i];
    if (p.estado != EstadoPedido.enPreparacion ||
        linea < 0 ||
        linea >= p.productos.length) {
      throw StateError('El pedido no está en preparación.');
    }
    final items = [...p.productos];
    items[linea] = items[linea].conPreparacion(value);
    _pedidos[i] = p.copyWith(productos: List.unmodifiable(items));
    notifyListeners();
  }

  void guardarOferta(OfertaProductor o, {DateTime? now}) {
    final p = producto(o.productoId);
    if (p == null ||
        !o.cantidad.isFinite ||
        o.cantidad <= 0 ||
        o.cantidad > p.cantidad ||
        !o.descuento.isFinite ||
        o.descuento <= 0 ||
        o.descuento >= 100 ||
        (o.activa && !p.publicado) ||
        !DateTime(
          o.fin.year,
          o.fin.month,
          o.fin.day + 1,
        ).isAfter(now ?? DateTime.now())) {
      throw StateError(
        'Revisa el producto, la cantidad disponible, el descuento y la fecha.',
      );
    }
    _ofertas[o.productoId] = o;
    notifyListeners();
  }

  void guardarFinca(DatosFinca datos) {
    finca = datos;
    notifyListeners();
  }

  void guardarPersona(DatosProductor datos) {
    persona = datos;
    ApiSession.instance.userName = datos.nombre;
    notifyListeners();
  }

  void configurarNotificaciones(bool value) {
    notificaciones = value;
    notifyListeners();
  }

  void reiniciar() {
    _cargar(DateTime.now());
    notifyListeners();
  }

  void asegurarSesion() {
    if (_sessionToken == ApiSession.instance.token) return;
    _cargar(DateTime.now());
    notifyListeners();
  }

  void _cargar(DateTime now) {
    _sessionToken = ApiSession.instance.token;
    _productos.clear();
    _pedidos.clear();
    _ofertas.clear();

    _nextId = 4;
    notificaciones = true;
    finca = const DatosFinca(
      nombre: 'Finca La Esperanza',
      ubicacion: 'Jinotepe, Carazo',
      cultivo: 'Hortalizas',
      hectareas: 15,
      descripcion:
          'Productor local dedicado al cultivo y comercialización de frutas y hortalizas frescas.',
      portadaUrl:
          'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=1200&q=80',
    );
    persona = DatosProductor(
      nombre: ApiSession.instance.userName ?? 'Carlos Martínez',
      correo: 'carlos@agrotrade.com',
      telefono: '8888 1234',
      ubicacion: finca.ubicacion,
    );
    _productos.addAll([
      Producto(
        id: 1,
        nombre: 'Tomate',
        cantidad: 1200,
        unidad: 'kg',
        precio: 18.5,
        costoProduccion: 12,
        categoria: 'Verduras',
        estado: EstadoProducto.disponible,
        fechaCosecha: now.subtract(const Duration(days: 1)),
        imagenUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3DRPxLp5XH4U1fUPLQwkWQn7fUd368gb2lUCx9qEKuUb5LhktbVpEcMTg_3EP_rx99pWkU_cdJ_ZETZlfswgCjwu5DhipxhHqNXYkPJ0&s=10',
        descripcion:
            'Tomate fresco de producción local, cultivado con riego por goteo.',
      ),
      Producto(
        id: 2,
        nombre: 'Aguacate Hass Exportación',
        cantidad: 12,
        unidad: 'Caja',
        precio: 45,
        costoProduccion: 30,
        categoria: 'Frutas',
        estado: EstadoProducto.pocoInventario,
        fechaCosecha: now.subtract(const Duration(days: 2)),
        imagenUrl:
            'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=900&q=60',
      ),
      const Producto(
        id: 3,
        nombre: 'Maíz Amarillo Granel',
        cantidad: 0,
        unidad: 'Tonelada',
        precio: 320,
        costoProduccion: 220,
        categoria: 'Granos',
        estado: EstadoProducto.agotado,
        imagenUrl:
            'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&w=900&q=60',
      ),
    ]);
    final clientes = [
      'María López',
      'Cooperativa Los Andes',
      'Distribuidora Central',
      'Agromercados S.A.',
    ];
    final estados = [
      EstadoPedido.pendiente,
      EstadoPedido.enPreparacion,
      EstadoPedido.listo,
      EstadoPedido.pendiente,
    ];
    for (var i = 0; i < clientes.length; i++) {
      _pedidos.add(
        PedidoRecibido(
          codigo: '#PED-0012${4 - i}',
          cliente: clientes[i],
          idCliente: i + 1,
          fecha: now.subtract(Duration(days: i * 4)),
          estado: estados[i],
          direccion: i.isEven ? 'Barrio Centro, Jinotepe' : 'Diriamba, Carazo',
          nota: i == 0 ? 'Casa de portón verde, frente al parque.' : '',
          envio: 40,
          productos: List.unmodifiable([
            for (final p in _productos.take(2))
              LineaPedido(
                productoId: p.id,
                nombre: p.nombre,
                unidad: p.unidad,
                cantidad: p.id == 1 ? 4 : 2,
                precio: p.precio,
                imagenUrl: p.imagenUrl,
                preparado:
                    estados[i] == EstadoPedido.listo || (i == 1 && p.id == 1),
              ),
          ]),
        ),
      );
    }
  }
}
