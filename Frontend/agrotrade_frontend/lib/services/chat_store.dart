import 'package:flutter/foundation.dart';
import '../models/productor_models.dart'; // MensajeChat model

class ChatStore extends ChangeNotifier {
  static final ChatStore _instance = ChatStore._internal();
  static ChatStore get instance => _instance;
  ChatStore._internal();

  final Map<int, List<MensajeChat>> _historialChats = {};

  List<MensajeChat> mensajes(int idConversacion) {
    return _historialChats[idConversacion] ?? [];
  }

  void cargarHistorialChat(int idConversacion, List<MensajeChat> historialAPI) {
    _historialChats[idConversacion] = historialAPI;
    notifyListeners();
  }

  void guardarMensajeOffline(int idConversacion, MensajeChat msg) {
    if (!_historialChats.containsKey(idConversacion)) {
      _historialChats[idConversacion] = [];
    }
    // Evitar duplicados por idMensaje
    final existe = _historialChats[idConversacion]!.any((m) => m.idMensaje == msg.idMensaje);
    if (!existe) {
      _historialChats[idConversacion]!.add(msg);
      // Ordenar cronológicamente
      _historialChats[idConversacion]!.sort((a, b) => a.enviadoEn.compareTo(b.enviadoEn));
      notifyListeners();
    }
  }

  void clear() {
    _historialChats.clear();
    notifyListeners();
  }
}
