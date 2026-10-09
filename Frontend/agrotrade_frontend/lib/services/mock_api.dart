import 'dart:convert';
import 'package:http/http.dart' as http;

class MockApi {
  static String _mockRole = 'Cliente';
  static int _nextProductId = 100;
  static int _nextInventarioId = 100;

  // Estado estático para que las adiciones y modificaciones persistan durante la demo
  static final List<Map<String, dynamic>> _mockInventarios = [
    {
      'idInventario': 1,
      'idProducto': 1,
      'productorId': 1,
      'idProveedor': 1,
      'nombreProducto': 'Tomate Roma Finca',
      'stockActual': 150.0,
      'precioVenta': 15.0,
      'costoProduccion': 8.0,
      'unidadMedida': 'kg',
      'idUnidadMedida': 1,
      'fotoUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=800&q=80',
      'fechaCosecha': DateTime.now().toIso8601String()
    },
    {
      'idInventario': 2,
      'idProducto': 2,
      'productorId': 1,
      'idProveedor': 1,
      'nombreProducto': 'Cebolla Blanca Orgánica',
      'stockActual': 80.0,
      'precioVenta': 12.0,
      'costoProduccion': 5.0,
      'unidadMedida': 'kg',
      'idUnidadMedida': 1,
      'fotoUrl': 'https://images.unsplash.com/photo-1620574387735-3624d75b2dbc?auto=format&fit=crop&w=800&q=80',
      'fechaCosecha': DateTime.now().toIso8601String()
    },
    {
      'idInventario': 3,
      'idProducto': 3,
      'productorId': 2,
      'idProveedor': 2,
      'nombreProducto': 'Aguacate Hass',
      'stockActual': 50.0,
      'precioVenta': 45.0,
      'costoProduccion': 20.0,
      'unidadMedida': 'docena',
      'idUnidadMedida': 4,
      'fotoUrl': 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=800&q=80',
      'fechaCosecha': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
    },
    {
      'idInventario': 4,
      'idProducto': 4,
      'productorId': 2,
      'idProveedor': 2,
      'nombreProducto': 'Mango Tommy',
      'stockActual': 200.0,
      'precioVenta': 18.0,
      'costoProduccion': 10.0,
      'unidadMedida': 'docena',
      'idUnidadMedida': 4,
      'fotoUrl': 'https://images.unsplash.com/photo-1553279768-865429fd3039?auto=format&fit=crop&w=800&q=80',
      'fechaCosecha': DateTime.now().toIso8601String()
    }
  ];

  static final List<Map<String, dynamic>> _mockPedidos = [
    {
      'idPedido': 1001,
      'nombreCliente': 'Juan Cliente',
      'idUsuarioCliente': 2,
      'estadoEnvio': 'Pendiente',
      'fechaPedido': DateTime.now().toIso8601String(),
      'detalles': [
        {'idProducto': 1, 'producto': 'Tomate Finca', 'unidadMedida': 'kg', 'cantidad': 3, 'precioUnitario': 15.0, 'totalLinea': 45.0}
      ]
    },
    {
      'idPedido': 1002,
      'nombreCliente': 'Maria Compradora',
      'idUsuarioCliente': 3,
      'estadoEnvio': 'Preparando',
      'fechaPedido': DateTime.now().toIso8601String(),
      'detalles': [
        {'idProducto': 2, 'producto': 'Cebolla Blanca', 'unidadMedida': 'kg', 'cantidad': 10, 'precioUnitario': 12.0, 'totalLinea': 120.0}
      ]
    }
  ];

  static http.Response handle(String method, Uri uri, [String? payload]) {
    print('MockApi Intercepting: $method ${uri.path}');
    
    // --- AUTHENTICATION ---
    if (uri.path.contains('/api/Auth/login')) {
      List<String> roles = ['Cliente'];
      String userName = 'Cliente Mock';
      if (payload != null) {
        if (payload.contains('productor@')) {
          roles = ['Productor/Proveedor', 'Productor'];
          userName = 'Productor Mock';
          _mockRole = 'Productor';
        } else if (payload.contains('repartidor@')) {
          roles = ['Repartidor'];
          userName = 'Repartidor Mock';
          _mockRole = 'Repartidor';
        } else {
          _mockRole = 'Cliente';
        }
      }

      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'token': 'mock-token',
          'refreshToken': 'mock-refresh',
          'userId': 1,
          'roles': roles,
          'userName': userName
        }
      }), 200);
    }
    
    if (uri.path.contains('/api/Users/perfil') || uri.path.contains('/api/Auth/perfil')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'id': 1,
          'nombreCompleto': 'Usuario Mock',
          'email': 'mock@agrotrade.com',
          'roles': [_mockRole],
          'identidadVerificada': true,
          'telefono': '8888-8888',
          'direccionBase': 'Managua'
        }
      }), 200);
    }

    // --- CONSUMER PRODUCTOS ---
    if (method == 'GET' && uri.path.contains('/api/productos')) {
      final itemsMap = _mockInventarios.map((inv) => {
        'idProducto': inv['idProducto'],
        'nombre': inv['nombreProducto'],
        'descripcion': 'Producto fresco de alta calidad recolectado recientemente.',
        'precio': inv['precioVenta'],
        'unidadMedida': inv['unidadMedida'],
        'cantidadDisponible': inv['stockActual'],
        'categoriaId': 1,
        'categoriaNombre': 'General',
        'productorId': inv['productorId'] ?? 1,
        'fotoUrl': inv['fotoUrl'],
        'disponible': true
      }).toList();

      if (uri.path.contains('cercanos') || uri.path.contains('ofertas')) {
        // En estos casos, el frontend asume que `data` es la List directamente
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': itemsMap
        }), 200);
      } else {
        // Paginado
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': {
            'items': itemsMap,
            'totalItems': _mockInventarios.length,
            'totalPages': 1,
            'currentPage': 1
          }
        }), 200);
      }
    }

    if (method == 'GET' && uri.path.contains('/api/proveedores/destacados')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': [
          {
            'id': 1,
            'nombre': 'Finca La Esperanza',
            'calificacion': 4.8,
            'fotoUrl': 'https://images.unsplash.com/photo-1500595046743-cd271d694d30?auto=format&fit=crop&w=800&q=80',
            'ubicacion': 'Jinotepe, Carazo'
          },
          {
            'id': 2,
            'nombre': 'Cooperativa San Juan',
            'calificacion': 4.9,
            'fotoUrl': 'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?auto=format&fit=crop&w=800&q=80',
            'ubicacion': 'Masatepe, Masaya'
          }
        ]
      }), 200);
    }

    // --- PRODUCTOR PRODUCTOS (POST) ---
    if (method == 'POST' && uri.path.contains('/api/Productos')) {
      _nextProductId++;
      return http.Response(jsonEncode({
        'statusCode': 201,
        'isSuccess': true,
        'data': _nextProductId // El frontend espera extraer el ID de aquí
      }), 201);
    }

    // --- PRODUCTOR INVENTARIOS (CRUD) ---
    if (uri.path.contains('/api/Inventarios')) {
      final segments = uri.pathSegments;
      final idStr = segments.isNotEmpty ? segments.last : null;
      final id = int.tryParse(idStr ?? '');

      if (method == 'GET' && id == null) {
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': _mockInventarios
        }), 200);
      }
      
      if (method == 'GET' && id != null) {
        final inv = _mockInventarios.firstWhere((e) => e['idInventario'] == id, orElse: () => {});
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': inv.isNotEmpty ? inv : null
        }), 200);
      }

      if (method == 'POST') {
        // En ProductorApiService envía por Multipart o body. Asumimos éxito por ahora.
        _nextInventarioId++;
        
        // Dado que usamos Multipart no siempre viene el payload en json directo en MockApi, 
        // pero podemos crear un item generico o extraer de query params si pudieramos.
        // Haremos que simplemente devuelva éxito, y el fallback lo guarda en el store, 
        // o podemos leer el 'nombreProducto' del URL si lo enviara.
        // Para que se agregue a la demo:
        _mockInventarios.add({
          'idInventario': _nextInventarioId,
          'idProducto': _nextProductId,
          'productorId': 1,
          'idProveedor': 1,
          'nombreProducto': 'Nuevo Producto Añadido',
          'stockActual': 50.0,
          'precioVenta': 25.0,
          'costoProduccion': 15.0,
          'unidadMedida': 'kg',
          'idUnidadMedida': 1,
          'fotoUrl': 'https://via.placeholder.com/300?text=Nuevo+Producto',
          'fechaCosecha': DateTime.now().toIso8601String()
        });

        return http.Response(jsonEncode({'statusCode': 201, 'isSuccess': true, 'data': _nextInventarioId}), 201);
      }

      if (method == 'PATCH' && id != null) {
        final index = _mockInventarios.indexWhere((e) => e['idInventario'] == id);
        if (index != -1 && payload != null) {
          try {
            final Map<String, dynamic> body = jsonDecode(payload);
            if (body.containsKey('stockActual')) _mockInventarios[index]['stockActual'] = body['stockActual'];
            if (body.containsKey('precioVenta')) _mockInventarios[index]['precioVenta'] = body['precioVenta'];
            if (body.containsKey('fechaCosecha')) _mockInventarios[index]['fechaCosecha'] = body['fechaCosecha'];
          } catch (_) {}
        }
        return http.Response(jsonEncode({'statusCode': 200, 'isSuccess': true, 'data': true}), 200);
      }

      if (method == 'DELETE' && id != null) {
        _mockInventarios.removeWhere((e) => e['idInventario'] == id);
        return http.Response(jsonEncode({'statusCode': 200, 'isSuccess': true, 'data': true}), 200);
      }
    }

    // --- PRODUCTOR & CONSUMER PEDIDOS (CRUD) ---
    if (uri.path.contains('/api/Pedidos')) {
      final segments = uri.pathSegments;
      
      if (method == 'GET' && (uri.path.contains('/proveedor') || uri.path.contains('/pendientes') || uri.path.contains('/historial'))) {
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': _mockPedidos
        }), 200);
      }

      // /api/Pedidos/1001 (Detalle de un pedido en particular para cliente)
      final idStr = segments.isNotEmpty ? segments.last : null;
      final idDetalle = int.tryParse(idStr ?? '');
      if (method == 'GET' && idDetalle != null && !uri.path.contains('estado')) {
        final pedido = _mockPedidos.firstWhere((p) => p['idPedido'] == idDetalle, orElse: () => {});
        return http.Response(jsonEncode({
          'statusCode': 200,
          'isSuccess': true,
          'data': pedido.isNotEmpty ? pedido : null
        }), 200);
      }
      
      if (method == 'PATCH' && uri.path.contains('/estado')) {
        // format: /api/Pedidos/1001/estado
        final idStr = segments.length >= 3 ? segments[segments.length - 2] : null;
        final id = int.tryParse(idStr ?? '');
        
        if (id != null && payload != null) {
          final index = _mockPedidos.indexWhere((e) => e['idPedido'] == id);
          if (index != -1) {
            try {
              final Map<String, dynamic> body = jsonDecode(payload);
              if (body.containsKey('nuevoEstado')) {
                _mockPedidos[index]['estadoEnvio'] = body['nuevoEstado'];
              }
            } catch (_) {}
          }
        }
        return http.Response(jsonEncode({'statusCode': 200, 'isSuccess': true, 'data': true}), 200);
      }
    }

    // --- MISCELANEO (Categorías, Unidades, Impacto, Entregas) ---
    if (uri.path.contains('/api/Categorias') || uri.path.contains('/api/categorias')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'items': [
            {'idCategoria': 1, 'nombre': 'Frutas'},
            {'idCategoria': 2, 'nombre': 'Verduras'},
            {'idCategoria': 3, 'nombre': 'Granos'}
          ],
          'totalRegisters': 3
        }
      }), 200);
    }

    if (uri.path.contains('/api/unidadesdemedida')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': [
          {'idUnidadMedida': 1, 'nombre': 'kg', 'descripcion': 'Kilogramo'},
          {'idUnidadMedida': 2, 'nombre': 'lb', 'descripcion': 'Libra'},
          {'idUnidadMedida': 3, 'nombre': 'unidad', 'descripcion': 'Unidad'}
        ]
      }), 200);
    }

    if (uri.path.contains('/api/Repartidor/entregas') || uri.path.contains('/pendientes') || uri.path.contains('deliver')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': _mockPedidos.where((p) => p['estadoEnvio'] == 'Listo' || p['estadoEnvio'] == 'Preparando').map((p) => {
          'pedidoId': p['idPedido'],
          'zonaEntrega': 'Zona Simulada',
          'totalPedido': p['detalles'][0]['totalLinea'],
          'fechaCreacion': DateTime.now().toIso8601String()
        }).toList()
      }), 200);
    }

    if (uri.path.contains('/api/Productor/impacto')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'ventasTotales': 1500.0,
          'CO2Ahorrado': 45.5,
          'pedidosCompletados': 25,
          'calificacionPromedio': 4.8
        }
      }), 200);
    }

    return http.Response(jsonEncode({'statusCode': 200, 'isSuccess': true, 'data': {}}), 200);
  }
}
