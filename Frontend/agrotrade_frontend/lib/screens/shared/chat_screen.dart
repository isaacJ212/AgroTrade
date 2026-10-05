import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../services/chat_api_service.dart';
import '../../services/chat_store.dart';
import '../../services/chat_signalr_service.dart';
import '../../services/api_session.dart';

class ChatScreen extends StatefulWidget {
  final int idPedido;
  final int idReceptor;
  final String nombreReceptor;
  final String codigoPedido;

  const ChatScreen({
    super.key,
    required this.idPedido,
    required this.idReceptor,
    required this.nombreReceptor,
    required this.codigoPedido,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  Conversacion? _conversacion;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _iniciarChat();
  }

  int get _myId {
    final String? userId = ApiSession.instance.userId;
    return userId != null && userId.isNotEmpty ? (int.tryParse(userId) ?? 13) : 13;
  }

  Future<void> _iniciarChat() async {
    final api = ChatApiService.instance;
    final conv = await api.iniciarConversacion(widget.idPedido, widget.idReceptor);

    if (conv != null) {
      _conversacion = conv;
      
      final historial = await api.getHistorialMensajes(conv.idConversacion);
      ChatStore.instance.cargarHistorialChat(conv.idConversacion, historial);
      
      final signalR = ChatSignalRService.instance;
      await signalR.conectar();
      await signalR.unirseAConversacion(conv.idConversacion);
      
      signalR.onMensajeRecibido((args) {
        if (args != null && args.isNotEmpty) {
          final data = args[0] as Map<String, dynamic>;
          final nuevoMsg = MensajeChat(
            idMensaje: data['idMensaje'] ?? 0,
            idConversacion: data['idConversacion'] ?? conv.idConversacion,
            idEmisor: data['idUsuarioEmisor'] ?? 0,
            nombreEmisor: data['nombreEmisor'] ?? 'Usuario',
            contenido: data['contenido'] ?? '',
            enviadoEn: data['enviadoEn'] != null ? DateTime.tryParse(data['enviadoEn']) ?? DateTime.now() : DateTime.now(),
            leido: data['leido'] ?? false,
          );
          
          ChatStore.instance.guardarMensajeOffline(conv.idConversacion, nuevoMsg);
          _scrollToBottom();
        }
      });
    }

    if (mounted) {
      setState(() {
        _cargando = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    final signalR = ChatSignalRService.instance;
    signalR.offMensajeRecibido();
    if (_conversacion != null) {
      signalR.salirDeConversacion(_conversacion!.idConversacion);
    }
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _enviarMensaje() async {
    if (_controller.text.trim().isEmpty || _conversacion == null) return;

    final contenido = _controller.text.trim();
    _controller.clear();
    
    final tmpMsg = MensajeChat(
      idMensaje: DateTime.now().millisecondsSinceEpoch,
      idConversacion: _conversacion!.idConversacion,
      idEmisor: _myId,
      nombreEmisor: 'Yo',
      contenido: contenido,
      enviadoEn: DateTime.now(),
      isOffline: true, 
    );
    
    ChatStore.instance.guardarMensajeOffline(_conversacion!.idConversacion, tmpMsg);
    _scrollToBottom();

    await ChatApiService.instance.enviarMensajeHTTP(_conversacion!.idConversacion, contenido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chat con ${widget.nombreReceptor}', style: const TextStyle(fontSize: 16)),
            Text(widget.codigoPedido, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: ChatStore.instance,
                    builder: (context, _) {
                      if (_conversacion == null) return const Center(child: Text('Error al cargar chat'));
                      final mensajes = ChatStore.instance.mensajes(_conversacion!.idConversacion);
                      
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: mensajes.length,
                        itemBuilder: (context, index) {
                          final msg = mensajes[index];
                          final soyYo = msg.idEmisor == _myId;
                          
                          return Align(
                            alignment: soyYo ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: soyYo ? Colors.green[100] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(child: Text(msg.contenido)),
                                  if (soyYo && msg.isOffline)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Icon(Icons.access_time, size: 12, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Escribe un mensaje...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onSubmitted: (_) => _enviarMensaje(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: _enviarMensaje,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
