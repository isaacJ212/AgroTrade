import 'api_client.dart';
import 'api_session.dart';
import 'consumer_api_service.dart';

class SubscriptionApiService {
  SubscriptionApiService._();

  static final SubscriptionApiService instance = SubscriptionApiService._();

  Future<List<Map<String, dynamic>>> fetchPlanes() async {
    try {
      final response = await ApiClient.instance.get('api/Suscripciones/planes', authorized: true);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.jsonBody != null && response.jsonBody!['data'] is List) {
          return List<Map<String, dynamic>>.from(response.jsonBody!['data']);
        }
      }
    } catch (e) {
      print('Fallback por error de red: Usando datos mock de planes de suscripción');
    }
    
    // Fallback Mock Data
    return [
      {
        'idTipoPlan': 1,
        'nombrePlan': 'Básico',
        'precio': 15.0,
        'descripcion': 'Plan ideal para recibir productos frescos ocasionalmente.',
        'beneficios': 'Soporte estándar,Hasta 5 entregas mensuales',
        'estado': true,
      },
      {
        'idTipoPlan': 2,
        'nombrePlan': 'Premium',
        'precio': 29.99,
        'descripcion': 'La mejor opción para tu despensa.',
        'beneficios': 'Soporte prioritario,Entregas semanales,Productos exclusivos',
        'estado': true,
      },
      {
        'idTipoPlan': 3,
        'nombrePlan': 'Elite',
        'precio': 59.99,
        'descripcion': 'Para grandes consumidores.',
        'beneficios': 'Todo lo de Premium,Estadísticas avanzadas,Asesoría nutricional,Envío gratuito siempre',
        'estado': true,
      }
    ];
  }

  Future<void> createSubscription(String tipoPlan, double tarifaPago, int mesesDuracion) async {
    final userId = ApiSession.instance.userId;
    if (userId == null) {
      throw ApiException(401, 'No user logged in');
    }

    final body = {
      'idUsuario': int.tryParse(userId) ?? 0,
      'tipoPlan': tipoPlan,
      'tarifaPago': tarifaPago,
      'mesesDuracion': mesesDuracion,
    };

    try {
      final response = await ApiClient.instance.post(
        'api/Suscripciones',
        body: body,
        authorized: true,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      
      throw ApiException(response.statusCode, response.jsonBody?['message'] ?? 'Error al crear la suscripción');
    } catch (e) {
      print('Fallback por error de red: Usando datos locales temporales para suscripción');
      ConsumerApiService.instance.crearSuscripcionMock(tipoPlan);
      return;
    }
  }
}
