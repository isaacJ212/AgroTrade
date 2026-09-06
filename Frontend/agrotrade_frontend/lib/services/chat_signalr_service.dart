import 'package:signalr_netcore/signalr_client.dart';
import 'package:flutter/foundation.dart';
import 'api_session.dart';
import 'api_client.dart';

class ChatSignalRService {
  static final ChatSignalRService instance = ChatSignalRService._internal();
  ChatSignalRService._internal();

  HubConnection? _hubConnection;
  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  Future<void> conectar() async {
    if (isConnected) return;

    final token = ApiSession.instance.token;
    if (token == null) {
      print('DEBUG: [SignalR] ✗ No hay token para conectar.');
      return;
    }

    // Usar la URL base configurada en ApiClient
    final serverUrl = '${ApiClient.instance.baseUrl}/chathub';

    _hubConnection = HubConnectionBuilder()
        .withUrl(serverUrl, options: HttpConnectionOptions(
          accessTokenFactory: () async => token,
        ))
        .withAutomaticReconnect()
        .build();

    _hubConnection?.onclose(({error}) {
      print('DEBUG: [SignalR] Conexión cerrada: $error');
    });

    try {
      await _hubConnection?.start();
      print('DEBUG: [SignalR] ✓ Conectado exitosamente');
    } catch (e) {
      print('DEBUG: [SignalR] ✗ Error al conectar: $e');
    }
  }

  Future<void> unirseAConversacion(int idConversacion) async {
    if (!isConnected) await conectar();
    
    if (isConnected) {
      try {
        await _hubConnection?.invoke('JoinConversation', args: [idConversacion]);
        print('DEBUG: [SignalR] ✓ Unido al grupo $idConversacion');
      } catch (e) {
        print('DEBUG: [SignalR] ✗ Error uniendo al grupo: $e');
      }
    }
  }

  Future<void> salirDeConversacion(int idConversacion) async {
    if (isConnected) {
      try {
        await _hubConnection?.invoke('LeaveConversation', args: [idConversacion]);
        print('DEBUG: [SignalR] ✓ Salió del grupo $idConversacion');
      } catch (e) {
        print('DEBUG: [SignalR] ✗ Error saliendo del grupo: $e');
      }
    }
  }

  void onMensajeRecibido(void Function(List<Object?>? args) callback) {
    _hubConnection?.on('ReceiveMessage', callback);
  }
  
  void offMensajeRecibido() {
    _hubConnection?.off('ReceiveMessage');
  }

  void desconectar() {
    _hubConnection?.stop();
  }
}
