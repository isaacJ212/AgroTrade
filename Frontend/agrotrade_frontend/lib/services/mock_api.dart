import 'dart:convert';
import 'package:http/http.dart' as http;

class MockApi {
  static http.Response handle(String method, Uri uri) {
    print('MockApi Intercepting: \${method} \${uri.path}');
    
    if (uri.path.contains('/api/Auth/login')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'token': 'mock-token',
          'refreshToken': 'mock-refresh',
          'userId': 1,
          'roles': ['Comprador', 'Productor', 'Repartidor'],
          'userName': 'Usuario Mock'
        }
      }), 200);
    }
    
    if (uri.path.contains('/api/Productos') || uri.path.contains('/api/Products')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'items': [
            {
              'idProducto': 1,
              'nombre': 'Tomate Mock',
              'descripcion': 'Tomate rojo fresco',
              'precio': 15.0,
              'unidadMedida': 'kg',
              'cantidadDisponible': 100,
              'categoriaId': 1,
              'productorId': 1,
              'imagenesUrls': ['https://via.placeholder.com/150'],
              'disponible': true
            },
            {
              'idProducto': 2,
              'nombre': 'Cebolla Mock',
              'descripcion': 'Cebolla blanca',
              'precio': 12.0,
              'unidadMedida': 'kg',
              'cantidadDisponible': 50,
              'categoriaId': 2,
              'productorId': 1,
              'imagenesUrls': ['https://via.placeholder.com/150'],
              'disponible': true
            }
          ],
          'totalRegisters': 2
        }
      }), 200);
    }

    if (uri.path.contains('/api/Categorias')) {
      return http.Response(jsonEncode({
        'statusCode': 200,
        'isSuccess': true,
        'data': {
          'items': [
            {'idCategoria': 1, 'nombre': 'Frutas'},
            {'idCategoria': 2, 'nombre': 'Vegetales'}
          ],
          'totalRegisters': 2
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
          'roles': ['Comprador', 'Productor', 'Repartidor'],
          'identidadVerificada': true,
          'telefono': '8888-8888',
          'direccionBase': 'Managua'
        }
      }), 200);
    }

    return http.Response(jsonEncode({'statusCode': 200, 'isSuccess': true, 'data': {}}), 200);
  }
}
