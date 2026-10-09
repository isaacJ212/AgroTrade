import '../models/api/agrobot_models.dart';
import '../models/api/backend_result.dart';
import 'api_client.dart';

class AgrobotApiService {
  AgrobotApiService._();

  static final AgrobotApiService instance = AgrobotApiService._();

  Future<AgrobotResponse> sendMessage({
    required String chatId,
    required String message,
    String module = 'pedidos_compras',
  }) async {
    try {
      final response = await ApiClient.instance.post(
        '/api/AgroBot/push-request',
        authorized: true,
        body: {'chatId': chatId, 'message': message, 'module': module},
      );
      final result = BackendResult<AgrobotResponse>.fromJson(
        response.jsonBody ?? const {},
        dataParser: AgrobotResponse.fromJson,
      );
      _throwIfFailed(response, result, 'No se pudo enviar el mensaje.');
      return result.data ?? const AgrobotResponse(chatId: '', response: '');
    } catch (_) {
      // Mock local con palabras clave para la demo
      await Future.delayed(const Duration(seconds: 1)); // Simular "pensando"
      String reply = 'Lo siento, no comprendo. Puedes preguntarme sobre tus **pedidos**, **pagos**, **entregas** o **productos**.';
      final text = message.toLowerCase();
      
      if (text.contains('pedido') || text.contains('estado')) {
        reply = 'Tu último pedido (PED-1054) se encuentra actualmente **En Preparación**. Se estima que estará listo para recoger hoy por la tarde.|ROUTE|/comprador/mis-pedidos';
      } else if (text.contains('pago') || text.contains('tarjeta')) {
        reply = 'Aceptamos transferencias bancarias y tarjetas Visa o MasterCard. Todos tus pagos están protegidos de extremo a extremo.|ROUTE|/planes-suscripcion';
      } else if (text.contains('hola') || text.contains('buen') || text.contains('saludo')) {
        reply = '¡Hola! Qué gusto saludarte de nuevo. Soy AgroBot, ¿en qué te puedo ayudar el día de hoy? Si quieres explorar, ve al inicio:|ROUTE|/comprador/inicio';
      } else if (text.contains('entrega') || text.contains('ruta') || text.contains('repartidor')) {
        reply = 'Las entregas se asignan automáticamente al repartidor más cercano. Recibirás una notificación en cuanto el repartidor recoja tus productos en la finca.|ROUTE|/comprador/pedido/seguimiento';
      } else if (text.contains('precio') || text.contains('producto') && !text.contains('agregar')) {
        reply = 'Los precios varían según la oferta del productor. Te recomiendo visitar la sección del catálogo para ver los precios actualizados en tiempo real.|ROUTE|/comprador/explorar';
      } else if (text.contains('agregar') && (text.contains('producto') || text.contains('inventario'))) {
        reply = 'Para agregar un producto a tu inventario, dirígete a la sección de Inventario y presiona el botón "Agregar Producto". También puedes usar este acceso directo:|ROUTE|/productor/inventario/agregar';
      } else if (text.contains('inventario')) {
        reply = 'Puedes gestionar tus existencias, registrar nuevas cosechas y actualizar tus precios en la sección de Inventario.|ROUTE|/productor/inventario';
      } else if (text.contains('perfil') || text.contains('datos')) {
        reply = 'Para actualizar tu información personal o los datos de tu finca, por favor dirígete a la sección de Perfil.|ROUTE|/productor/configuracion';
      } else if (text.contains('ayuda') || text.contains('soporte')) {
        reply = 'Si tienes un problema grave con un pedido, puedes contactar al soporte técnico en el Centro de Ayuda.|ROUTE|/productor/ayuda';
      }

      return AgrobotResponse(
        chatId: chatId.isEmpty ? 'mock-chat-123' : chatId, 
        response: reply
      );
    }
  }

  Future<List<AgrobotConversation>> getConversations() async {
    try {
      final response = await ApiClient.instance.get(
        '/api/AgroBot/conversations',
        authorized: true,
      );
      final result = BackendResult<List<AgrobotConversation>>.fromJson(
        response.jsonBody ?? const {},
        dataParser: (data) => data is List
            ? data.map(AgrobotConversation.fromJson).toList()
            : <AgrobotConversation>[],
      );
      _throwIfFailed(response, result, 'No se pudo cargar el historial.');
      return result.data ?? const [];
    } catch (_) {
      // Mock history
      return [];
    }
  }

  Future<List<AgrobotHistoryMessage>> getConversation(String chatId) async {
    try {
      final response = await ApiClient.instance.get(
        '/api/AgroBot/conversations/${Uri.encodeComponent(chatId)}',
        authorized: true,
      );
      final result = BackendResult<List<AgrobotHistoryMessage>>.fromJson(
        response.jsonBody ?? const {},
        dataParser: (data) => data is List
            ? data.map(AgrobotHistoryMessage.fromJson).toList()
            : <AgrobotHistoryMessage>[],
      );
      _throwIfFailed(response, result, 'No se pudo cargar la conversación.');
      return result.data ?? const [];
    } catch (_) {
      // Mock conversation details
      return [];
    }
  }

  void _throwIfFailed(
    ApiResponse response,
    BackendResult<dynamic> result,
    String fallback,
  ) {
    if (!result.isSuccess ||
        response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty ? result.message : fallback,
      );
    }
  }
}
