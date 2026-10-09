import 'dart:async';
import '../models/productor_models.dart'; 
import 'api_client.dart';
import 'api_session.dart';

/// Servicio de API agnóstico para la Mensajería (Chat)
/// Permite iniciar conversaciones y enviar mensajes desde cualquier rol.
class ChatApiService {
  static final ChatApiService _instance = ChatApiService._internal();
  static ChatApiService get instance => _instance;
  ChatApiService._internal();

  final Duration _timeout = const Duration(seconds: 15);

  int get _myId {
    final String? userId = ApiSession.instance.userId;
    return userId != null && userId.isNotEmpty ? (int.tryParse(userId) ?? 13) : 13; // default 13
  }

  Future<Conversacion?> iniciarConversacion(int idPedido, int idReceptor) async {
    final myId = _myId;

    print('DEBUG: [ChatApiService] ══ POST /api/Conversaciones ══');
    try {
      final response = await ApiClient.instance.post(
        '/api/Conversaciones',
        authorized: true,
        body: {
          'idPedido': idPedido,
          'idUsuarioCliente': myId, 
          'idUsuarioReceptor': idReceptor,
        },
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.jsonBody?['data'];
        if (data != null) {
           return Conversacion(
             idConversacion: data['idConversacion'] ?? 0,
             idPedido: data['idPedido'] ?? idPedido,
             idCliente: data['idCliente'] ?? myId,
             idProductor: data['idProductor'] ?? idReceptor,
             creadaEn: DateTime.now(),
           );
        }
      }
    } catch (e) {
      print('DEBUG: [ChatApiService] ✗ Error iniciarConversacion: $e');
    }
    return null;
  }

  Future<List<MensajeChat>> getHistorialMensajes(int idConversacion) async {
    print('DEBUG: [ChatApiService] ══ GET /api/Conversaciones/$idConversacion/mensajes ══');
    try {
      final response = await ApiClient.instance
          .get('/api/Conversaciones/$idConversacion/mensajes?pageIndex=1&pageSize=50', authorized: true)
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final data = response.jsonBody?['data']?['items'];
        if (data is List) {
          return data.map((m) => MensajeChat(
            idMensaje: m['idMensaje'] ?? 0,
            idConversacion: m['idConversacion'] ?? idConversacion,
            idEmisor: m['idUsuarioEmisor'] ?? 0,
            nombreEmisor: m['nombreEmisor'] ?? 'Usuario',
            contenido: m['contenido'] ?? '',
            enviadoEn: m['enviadoEn'] != null ? DateTime.tryParse(m['enviadoEn']) ?? DateTime.now() : DateTime.now(),
            leido: m['leido'] ?? false,
          )).toList();
        }
      }
    } catch (e) {
      print('DEBUG: [ChatApiService] ✗ Error getHistorialMensajes: $e');
    }
    return [];
  }

  Future<bool> enviarMensajeHTTP(int idConversacion, String contenido) async {
    final myId = _myId;
    
    print('DEBUG: [ChatApiService] ══ POST /api/Conversaciones/$idConversacion/mensajes ══');
    try {
      final response = await ApiClient.instance.post(
        '/api/Conversaciones/$idConversacion/mensajes',
        authorized: true,
        body: {
          'idConversacion': idConversacion,
          'idUsuarioEmisor': myId,
          'contenido': contenido,
        },
      ).timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('DEBUG: [ChatApiService] ✗ Error enviarMensajeHTTP: $e');
    }
    return false;
  }
}
