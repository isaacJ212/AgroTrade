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
  }

  Future<List<AgrobotConversation>> getConversations() async {
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
  }

  Future<List<AgrobotHistoryMessage>> getConversation(String chatId) async {
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
