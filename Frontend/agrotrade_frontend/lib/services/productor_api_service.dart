import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/productor_models.dart';
import '../services/productor_store.dart';
import 'api_client.dart';
import 'api_session.dart';

/// Servicio de API para el Productor.
/// Estrategia: intenta siempre el API real. Si falla por red u otro error,
/// hace fallback al ProductorStore (en memoria / mock).
class ProductorApiService {
  static final ProductorApiService _instance = ProductorApiService._internal();
  static ProductorApiService get instance => _instance;
  ProductorApiService._internal();

  final Duration _timeout = const Duration(seconds: 15);

  int get _idProveedor {
    final String? userId = ApiSession.instance.userId;
    return userId != null && userId.isNotEmpty ? (int.tryParse(userId) ?? 13) : 13;
  }

  // ─────────────────────────────────────────────
  //  GET /api/Inventarios
  //  inventarioProductor.dart → carga la lista
  // ─────────────────────────────────────────────
  Future<List<Producto>> getInventario() async {
    print('DEBUG: [ProductorApiService] ══ GET /api/Inventarios ══');
    print('DEBUG: [ProductorApiService] idProveedor activo: $_idProveedor');
    try {
      final response = await ApiClient.instance
          .get('/api/Inventarios', authorized: true)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] GET Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.jsonBody?['data'];
        List<dynamic> jsonList = [];
        if (data is List) {
          jsonList = data;
        } else if (data is Map && data.containsKey('items')) {
          jsonList = data['items'] as List;
        }

        print('DEBUG: [ProductorApiService] Total registros en API: ${jsonList.length}');

        // Filtrar por idProveedor del JWT (el backend devuelve todos los disponibles)
        final myId = _idProveedor;
        final myItems = jsonList.where((item) => item['idProveedor'] == myId).toList();
        print('DEBUG: [ProductorApiService] Registros del proveedor $myId: ${myItems.length}');

        final productos = myItems.map((json) {
          final stock = (json['stockActual'] as num?)?.toDouble() ?? 0.0;
          final p = Producto(
            id: json['idInventario'] as int? ?? 0,
            nombre: json['nombreProducto'] ?? json['productoNombre'] ?? 'Producto Desconocido',
            cantidad: stock,
            unidad: json['unidadMedida'] ?? 'kg',
            precio: (json['precioVenta'] as num?)?.toDouble() ?? 0.0,
            costoProduccion: (json['costoProduccion'] as num?)?.toDouble() ?? 0.0,
            estado: stock <= 0
                ? EstadoProducto.agotado
                : (stock <= 15 ? EstadoProducto.pocoInventario : EstadoProducto.disponible),
            imagenUrl: json['fotoUrl'] ?? '',
            fechaCosecha: json['fechaCosecha'] != null
                ? DateTime.tryParse(json['fechaCosecha'])
                : null,
          );
          print('DEBUG: [Inventario Item] id=${p.id} nombre="${p.nombre}" stock=${p.cantidad} precio=${p.precio} foto="${p.imagenUrl}"');
          return p;
        }).toList();

        // Sincronizar al store local (para modo offline posterior)
        ProductorStore.instance.cargarDesdeApi(productos);
        print('DEBUG: [ProductorApiService] ✓ Inventario cargado del API y sincronizado al store');
        return productos;
      }

      print('DEBUG: [ProductorApiService] ⚠ Status no esperado: ${response.statusCode} → fallback a store');
    } on SocketException catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión (SocketException): $e');
      print('DEBUG: [ProductorApiService] → Modo OFFLINE: usando store en memoria');
    } on TimeoutException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Timeout → Modo OFFLINE: usando store en memoria');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error API: $e → Modo OFFLINE');
    }

    // FALLBACK: devolver lo que hay en el store local
    final storeProductos = ProductorStore.instance.productos;
    print('DEBUG: [ProductorApiService] Fallback store → ${storeProductos.length} productos en memoria');
    return List<Producto>.from(storeProductos);
  }

  // ─────────────────────────────────────────────
  //  GET /api/Inventarios/{id}
  //  detalleProducto.dart → carga detalle de uno
  // ─────────────────────────────────────────────
  Future<Producto?> getInventarioById(int idInventario) async {
    print('DEBUG: [ProductorApiService] ══ GET /api/Inventarios/$idInventario ══');
    try {
      final response = await ApiClient.instance
          .get('/api/Inventarios/$idInventario', authorized: true)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] GET ById Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = response.jsonBody?['data'];
        if (json == null) return null;
        final stock = (json['stockActual'] as num?)?.toDouble() ?? 0.0;
        final p = Producto(
          id: json['idInventario'] as int? ?? 0,
          nombre: json['nombreProducto'] ?? 'Producto Desconocido',
          cantidad: stock,
          unidad: json['unidadMedida'] ?? 'kg',
          precio: (json['precioVenta'] as num?)?.toDouble() ?? 0.0,
          costoProduccion: (json['costoProduccion'] as num?)?.toDouble() ?? 0.0,
          estado: stock <= 0
              ? EstadoProducto.agotado
              : (stock <= 15 ? EstadoProducto.pocoInventario : EstadoProducto.disponible),
          imagenUrl: json['fotoUrl'] ?? '',
          fechaCosecha: json['fechaCosecha'] != null
              ? DateTime.tryParse(json['fechaCosecha'])
              : null,
        );
        print('DEBUG: [ProductorApiService] ✓ Detalle cargado: ${p.nombre}');
        return p;
      }
    } on SocketException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión → Modo OFFLINE: buscando en store');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error getById: $e → buscando en store');
    }

    // FALLBACK: buscar en store local
    final p = ProductorStore.instance.producto(idInventario);
    print('DEBUG: [ProductorApiService] Fallback store → ${p != null ? "encontrado: ${p.nombre}" : "no encontrado"}');
    return p;
  }

  // ─────────────────────────────────────────────
  //  PATCH /api/Inventarios/{id}
  //  registroCosecha.dart → actualiza stock/precio
  // ─────────────────────────────────────────────
  Future<bool> actualizarInventario(
      int idInventario, double nuevoStock, double nuevoPrecio, DateTime? nuevaFechaCosecha) async {
    print('DEBUG: [ProductorApiService] ══ PATCH /api/Inventarios/$idInventario ══');
    print('DEBUG: [ProductorApiService] Payload: stock=$nuevoStock precio=$nuevoPrecio fecha=${nuevaFechaCosecha?.toIso8601String()}');

    final payload = {
      'stockActual': nuevoStock,
      'precioVenta': nuevoPrecio,
      if (nuevaFechaCosecha != null) 'fechaCosecha': nuevaFechaCosecha.toUtc().toIso8601String(),
    };

    try {
      final response = await ApiClient.instance
          .patch('/api/Inventarios/$idInventario', authorized: true, body: payload)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] PATCH Status: ${response.statusCode}');
      print('DEBUG: [ProductorApiService] PATCH Body: ${response.rawBody}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('DEBUG: [ProductorApiService] ✓ Actualizado en API. Sincronizando store...');
        _actualizarEnStore(idInventario, nuevoStock, nuevoPrecio, nuevaFechaCosecha);
        return true;
      }
      print('DEBUG: [ProductorApiService] ⚠ PATCH fallido status=${response.statusCode} → fallback a store');
    } on SocketException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión → Modo OFFLINE: actualizando solo en store');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error PATCH: $e → Modo OFFLINE');
    }

    // FALLBACK: actualizar en store local
    _actualizarEnStore(idInventario, nuevoStock, nuevoPrecio, nuevaFechaCosecha);
    print('DEBUG: [ProductorApiService] ✓ Actualizado en store (offline)');
    return true; // Retorna true para que la UI muestre éxito local
  }

  void _actualizarEnStore(int id, double stock, double precio, DateTime? fecha) {
    final p = ProductorStore.instance.producto(id);
    if (p != null) {
      ProductorStore.instance.guardarProducto(
        p.copyWith(cantidad: stock, precio: precio, fechaCosecha: fecha),
      );
    }
  }

  // ─────────────────────────────────────────────
  //  POST /api/Productos + POST /api/Inventarios
  //  agregarProducto.dart → crea producto nuevo
  // ─────────────────────────────────────────────
  Future<bool> crearInventario(Producto p) async {
    print('DEBUG: [ProductorApiService] ══ INICIANDO POST DUAL ══');
    print('DEBUG: [ProductorApiService] Producto: "${p.nombre}" | stock=${p.cantidad} | precio=${p.precio} | unidad=${p.unidad}');

    final idProveedorStr = ApiSession.instance.userId;
    if (idProveedorStr == null) {
      print('DEBUG: [ProductorApiService] ✗ Sin userId en sesión');
      return false;
    }
    final idProveedor = int.tryParse(idProveedorStr);
    if (idProveedor == null) {
      print('DEBUG: [ProductorApiService] ✗ userId no es int válido: $idProveedorStr');
      return false;
    }

    // Mapear categoría a ID
    int categoriaId = 1;
    if (p.categoria == 'Verduras') categoriaId = 2;
    if (p.categoria == 'Granos') categoriaId = 3;
    if (p.categoria == 'Tubérculos') categoriaId = 4;

    final productoPayload = {
      'idCategoria': categoriaId,
      'idProveedor': idProveedor,
      'nombre': p.nombre,
      'descripcion': p.descripcion ?? '',
      'unidadMedida': p.unidad,
    };

    try {
      // PASO 1: Crear Producto
      print('DEBUG: [ProductorApiService] POST /api/Productos Payload: $productoPayload');
      final resProducto = await ApiClient.instance
          .post('/api/Productos', authorized: true, body: productoPayload)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] POST /api/Productos Status: ${resProducto.statusCode}');
      print('DEBUG: [ProductorApiService] POST /api/Productos Body: ${resProducto.rawBody}');

      if (resProducto.statusCode != 200 && resProducto.statusCode != 201) {
        print('DEBUG: [ProductorApiService] ✗ Falló creación de Producto → fallback offline');
        return _crearEnStore(p);
      }

      // Extraer idProducto del body
      int idProducto = 0;
      if (resProducto.jsonBody != null && resProducto.jsonBody!.containsKey('value')) {
        final val = resProducto.jsonBody!['value'];
        if (val is int) idProducto = val;
      } else if (resProducto.jsonBody != null && resProducto.jsonBody!.containsKey('data')) {
        final val = resProducto.jsonBody!['data'];
        if (val is int) idProducto = val;
      }

      print('DEBUG: [ProductorApiService] idProducto obtenido: $idProducto');
      if (idProducto == 0) {
        print('DEBUG: [ProductorApiService] ✗ No se pudo extraer idProducto del body');
        return _crearEnStore(p);
      }

      // PASO 2: Crear Inventario (multipart con foto)
      print('DEBUG: [ProductorApiService] POST /api/Inventarios para idProducto=$idProducto');
      final uri = Uri.parse('${ApiClient.instance.baseUrl}/api/Inventarios');
      final request = http.MultipartRequest('POST', uri);
      final token = ApiSession.instance.token;
      if (token != null) request.headers['Authorization'] = 'Bearer $token';

      request.fields['IdProveedor'] = idProveedor.toString();
      request.fields['IdProducto'] = idProducto.toString();
      request.fields['StockActual'] = p.cantidad.toString();
      request.fields['CostoProduccion'] = p.costoProduccion.toString();
      request.fields['PrecioVenta'] = p.precio.toString();
      if (p.fechaCosecha != null) {
        request.fields['FechaCosecha'] = p.fechaCosecha!.toUtc().toIso8601String();
      }
      print('DEBUG: [ProductorApiService] Campos multipart: ${request.fields}');

      if (p.imagenUrl.isNotEmpty) {
        try {
          request.files.add(await http.MultipartFile.fromPath('foto', p.imagenUrl));
          print('DEBUG: [ProductorApiService] Foto adjuntada: ${p.imagenUrl}');
        } catch (e) {
          print('DEBUG: [ProductorApiService] ⚠ No se pudo adjuntar foto: $e');
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      print('DEBUG: [ProductorApiService] POST /api/Inventarios Status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        print('DEBUG: [ProductorApiService] ✓ Producto e Inventario creados en API');
        return true;
      }

      print('DEBUG: [ProductorApiService] ✗ Inventario API falló → guardando en store');
      return _crearEnStore(p);
    } on SocketException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión → Modo OFFLINE: guardando en store');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error crearInventario: $e → Modo OFFLINE');
    }

    return _crearEnStore(p);
  }

  bool _crearEnStore(Producto p) {
    try {
      ProductorStore.instance.guardarProducto(p);
      print('DEBUG: [ProductorApiService] ✓ Producto guardado en store (offline) id=${p.id}');
      return true;
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error al guardar en store: $e');
      return false;
    }
  }

  // ─────────────────────────────────────────────
  //  DELETE /api/Inventarios/{id}
  //  (para uso futuro desde detalleProducto)
  // ─────────────────────────────────────────────
  Future<bool> eliminarInventario(int idInventario) async {
    print('DEBUG: [ProductorApiService] ══ DELETE /api/Inventarios/$idInventario ══');
    try {
      final response = await ApiClient.instance
          .delete('/api/Inventarios/$idInventario', authorized: true)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] DELETE Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        ProductorStore.instance.eliminarProducto(idInventario);
        print('DEBUG: [ProductorApiService] ✓ Eliminado en API y store');
        return true;
      }
    } on SocketException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión → eliminando solo en store');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error DELETE: $e → eliminando en store');
    }

    // FALLBACK offline
    ProductorStore.instance.eliminarProducto(idInventario);
    print('DEBUG: [ProductorApiService] ✓ Eliminado en store (offline)');
    return true;
  }

  // ─────────────────────────────────────────────
  //  GET /api/Pedidos/proveedor/{idProveedor}
  //  pedidosRecibidos.dart / sales.dart → lista pedidos del productor
  // ─────────────────────────────────────────────
  Future<List<PedidoRecibido>> getPedidosProveedor() async {
    final myId = _idProveedor;
    print('DEBUG: [ProductorApiService] ══ GET /api/Pedidos/proveedor/$myId ══');
    try {
      final response = await ApiClient.instance
          .get('/api/Pedidos/proveedor/$myId', authorized: true)
          .timeout(_timeout);

      print('DEBUG: [ProductorApiService] GET Pedidos Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.jsonBody?['data'];
        final jsonList = data is List ? data : [];
        print('DEBUG: [ProductorApiService] Pedidos del proveedor $myId: ${jsonList.length}');

        final pedidos = (jsonList as List).map((json) {
          final idPedido = json['idPedido'] as int? ?? 0;
          final estadoEnvio = (json['estadoEnvio'] ?? 'Pendiente') as String;
          final detalles = (json['detalles'] as List? ?? []);

          final lineas = detalles.map((d) => LineaPedido(
            productoId: d['id'] as int? ?? 0,
            nombre: d['producto'] ?? 'Producto',
            unidad: 'u',
            cantidad: (d['cantidad'] as num?)?.toDouble() ?? 0,
            precio: (d['totalLinea'] as num?)?.toDouble() ?? 0,
          )).toList();

            final p = PedidoRecibido(
              codigo: '#PED-$idPedido',
              cliente: json['nombreCliente'] ?? 'Cliente',
              idCliente: json['idUsuarioCliente'] as int? ?? 0,
              fecha: json['fechaPedido'] != null
                  ? DateTime.tryParse(json['fechaPedido']) ?? DateTime.now()
                  : DateTime.now(),
            estado: _parseEstado(estadoEnvio),
            direccion: '',
            nota: '',
            envio: 0,
            productos: List.unmodifiable(lineas),
          );
          print('DEBUG: [Pedido] id=$idPedido cliente="${p.cliente}" estado="${p.estado.label}" lineas=${lineas.length}');
          return p;
        }).toList();

        // Sincronizar al store local
        ProductorStore.instance.cargarPedidosDesdeApi(pedidos);
        print('DEBUG: [ProductorApiService] ✓ Pedidos sincronizados al store');
        return pedidos;
      }
      print('DEBUG: [ProductorApiService] ⚠ GET Pedidos status=${response.statusCode} → fallback store');
    } on SocketException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Sin conexión → Modo OFFLINE: pedidos del store');
    } on TimeoutException catch (_) {
      print('DEBUG: [ProductorApiService] ✗ Timeout → Modo OFFLINE: pedidos del store');
    } catch (e) {
      print('DEBUG: [ProductorApiService] ✗ Error getPedidos: $e → Modo OFFLINE');
    }

    final storePedidos = List<PedidoRecibido>.from(ProductorStore.instance.pedidos);
    print('DEBUG: [ProductorApiService] Fallback store → ${storePedidos.length} pedidos en memoria');
    return storePedidos;
  }

  // ─────────────────────────────────────────────
  //  PATCH /api/Pedidos/{id}/estado
  //  prepareOrderScreen / orderDetailScreen → cambia estado
  // ─────────────────────────────────────────────
  Future<bool> actualizarEstadoPedido(String codigoPedido, EstadoPedido nuevoEstado) async {
    // Extraer ID numérico del código '#PED-123' → 123
    final idStr = codigoPedido.replaceAll(RegExp(r'[^0-9]'), '');
    final id = int.tryParse(idStr) ?? 0;
    final estadoBackend = _estadoToBackend(nuevoEstado);

    print('DEBUG: [ProductorApiService] ══ PATCH /api/Pedidos/$id/estado ══');
    print('DEBUG: [ProductorApiService] codigo=$codigoPedido → id=$id estado="$estadoBackend"');

    if (id > 0) {
      try {
        final response = await ApiClient.instance
            .patch('/api/Pedidos/$id/estado', authorized: true, body: {'nuevoEstado': estadoBackend})
            .timeout(_timeout);

        print('DEBUG: [ProductorApiService] PATCH Estado Status: ${response.statusCode}');
        print('DEBUG: [ProductorApiService] PATCH Estado Body: ${response.rawBody}');

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('DEBUG: [ProductorApiService] ✓ Estado actualizado en API');
          return true;
        }
        print('DEBUG: [ProductorApiService] ⚠ PATCH Estado fallido → actualizando solo en store');
      } on SocketException catch (_) {
        print('DEBUG: [ProductorApiService] ✗ Sin conexión → actualizando solo en store');
      } catch (e) {
        print('DEBUG: [ProductorApiService] ✗ Error PATCH estado: $e → Modo OFFLINE');
      }
    }

    // FALLBACK: el store.cambiarEstado() lo llama la pantalla directamente
    print('DEBUG: [ProductorApiService] → Store manejará el cambio de estado local');
    return true;
  }

  EstadoPedido _parseEstado(String estadoEnvio) {
    switch (estadoEnvio.toLowerCase()) {
      case 'preparando': return EstadoPedido.enPreparacion;
      case 'listo': return EstadoPedido.listo;
      case 'entregado': return EstadoPedido.listo;
      case 'cancelado': return EstadoPedido.rechazado;
      case 'rechazado': return EstadoPedido.rechazado;
      default: return EstadoPedido.pendiente;
    }
  }

  String _estadoToBackend(EstadoPedido estado) {
    switch (estado) {
      case EstadoPedido.enPreparacion: return 'Preparando';
      case EstadoPedido.listo: return 'Listo';
      case EstadoPedido.rechazado: return 'Cancelado';
      default: return 'Pendiente';
    }
  }


}
