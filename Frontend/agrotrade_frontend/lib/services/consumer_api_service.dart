import 'dart:convert';
import '../models/Consumidor/consumidor_models.dart';
import 'api_client.dart';

class ConsumerApiService {
  static final ConsumerApiService _instance = ConsumerApiService._internal();
  static ConsumerApiService get instance => _instance;
  ConsumerApiService._internal();

  final Duration _timeout = const Duration(seconds: 15);
  
  // Mock Data
  static const List<ProductoMercado> _mockProductos = [
    ProductoMercado(
      id: 1,
      nombre: 'Tomate',
      finca: 'Coop. Los Andes',
      precio: 25.00,
      unidad: 'lb',
      distancia: '4.2 km',
      categoria: 'Verduras',
      imagenUrl: 'https://solofruver.com/wp-content/uploads/2020/06/tomate-chonto-e1662500217171.jpg',
      descripcion: 'Tomate fresco de producción local, disponible para entrega o retiro en finca.',
      calificacion: 4.8,
      valoraciones: 32,
      cosechadoHoy: true,
    ),
    ProductoMercado(
      id: 2,
      nombre: 'Naranja',
      finca: 'Coop. Los Andes',
      precio: 18.00,
      unidad: 'doc',
      distancia: '6.1 km',
      categoria: 'Cítricos',
      imagenUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=800&q=60',
    ),
    ProductoMercado(
      id: 3,
      nombre: 'Limón',
      finca: 'Finca La Esperanza',
      precio: 20.00,
      unidad: 'lb',
      distancia: '3.8 km',
      categoria: 'Cítricos',
      pocoInventario: true,
      imagenUrl: 'https://www.cincoazul.com/cdn/shop/products/limon_organico_organic_lemon_delivery_domicilio_762f4fcb-9e94-41e2-8bb4-1a23ff3686c8.jpg?v=1756240411',
    ),
    ProductoMercado(
      id: 4,
      nombre: 'Manzana Roja',
      finca: 'Finca La Esperanza',
      precio: 32.00,
      unidad: 'lb',
      distancia: '7.5 km',
      categoria: 'Frutas',
      imagenUrl: 'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=800&q=60',
    ),
  ];

  static const List<ProductoCercano> _mockCercanos = [
    ProductoCercano(
      nombre: 'Tomate Chonto Fresco',
      finca: 'Finca La Esperanza',
      precio: 25.00,
      unidad: 'lb',
      distancia: '4.2 km',
      imagenUrl: 'https://solofruver.com/wp-content/uploads/2020/06/tomate-chonto-e1662500217171.jpg',
    ),
    ProductoCercano(
      nombre: 'Naranja Valencia',
      finca: 'Coop. Los Andes',
      precio: 18.00,
      unidad: 'doc',
      distancia: '6.8 km',
      imagenUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=600&q=60',
    ),
  ];

  static const OfertaExcedente _mockOferta = OfertaExcedente(
    nombre: 'Tomate (Granel)',
    precio: 21.25,
    precioOriginal: 25.00,
    descuento: 15,
    vigencia: 'Disponible hasta hoy',
    imagenUrl: 'https://walmartsv.vtexassets.com/arquivos/ids/622011/52574_01.jpg?v=638690322156700000',
  );

  final List<PedidoConsumidor> _mockPedidos = [
    const PedidoConsumidor(
      id: 'PED-001',
      fecha: '2023-10-25',
      estado: 'Entregado',
      total: 125.50,
      itemsCount: 3,
    ),
  ];

  Future<PaginatedResponse<ProductoMercado>> getProductos({int page = 1, int limit = 20, String? search}) async {
    try {
      String path = '/api/productos?page=$page&limit=$limit';
      if (search != null && search.isNotEmpty) {
        path += '&search=${Uri.encodeComponent(search)}';
      }
      
      final response = await ApiClient.instance.get(path)
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.rawBody);
        
        // Support both old backend format (List) and new backend format (Map)
        final data = decoded['data'];
        
        List<dynamic> jsonList = [];
        int totalItems = 0;
        int totalPages = 1;
        int currentPage = 1;

        if (data is Map<String, dynamic>) {
          jsonList = data['items'] ?? [];
          totalItems = data['totalItems'] ?? 0;
          totalPages = data['totalPages'] ?? 1;
          currentPage = data['currentPage'] ?? 1;
        } else if (data is List) {
          jsonList = data;
          totalItems = jsonList.length;
        }

        final items = jsonList.map((json) => ProductoMercado(
          id: json['idProducto'] ?? 0,
          nombre: json['nombre'] ?? '',
          finca: 'Productor', // Placeholder mapping
          precio: json['precio']?.toDouble() ?? 0.0,
          unidad: json['unidadMedida'] ?? 'unidad',
          distancia: 'Calculando...',
          categoria: json['categoriaNombre'] ?? 'General',
          imagenUrl: json['fotoUrl'] ?? 'https://via.placeholder.com/150',
        )).toList();

        return PaginatedResponse<ProductoMercado>(
          totalItems: totalItems,
          totalPages: totalPages,
          currentPage: currentPage,
          items: items,
        );
      }
      return PaginatedResponse<ProductoMercado>(
        totalItems: _mockProductos.length,
        totalPages: 1,
        currentPage: 1,
        items: _mockProductos,
      );
    } catch (e) {
      print('Error al obtener productos: $e');
      return PaginatedResponse<ProductoMercado>(
        totalItems: _mockProductos.length,
        totalPages: 1,
        currentPage: 1,
        items: _mockProductos,
      );
    }
  }

  Future<List<ProductoCercano>> getProductosCercanos() async {
    // Para simplificar, utilizamos la misma estrategia de fallback
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCercanos;
  }

  Future<OfertaExcedente> getOfertaDia() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOferta;
  }

  Future<bool> checkout(double total, int itemsCount) async {
    try {
      // Simular intento de post
      final response = await ApiClient.instance.post('/api/pedidos/checkout', body: {
        'total': total,
        'itemsCount': itemsCount,
      }).timeout(_timeout);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {
      // Fallback: guardar pedido de forma local (mock)
      _mockPedidos.add(PedidoConsumidor(
        id: 'PED-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        fecha: DateTime.now().toString().split(' ')[0],
        estado: 'Procesando',
        total: total,
        itemsCount: itemsCount,
      ));
      return true; // Éxito simulado
    }
    return false;
  }

  Future<List<PedidoConsumidor>> getMisPedidos() async {
    try {
      final response = await ApiClient.instance.get('/api/pedidos/mis-pedidos')
          .timeout(_timeout);
      
      if (response.statusCode == 200) {
        // ... mapping logic
        return _mockPedidos; // Fallback for simplicity if not fully mapped
      }
      return _mockPedidos;
    } catch (_) {
      return _mockPedidos;
    }
  }
}
