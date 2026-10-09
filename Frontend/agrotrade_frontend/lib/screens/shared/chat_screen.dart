import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../services/chat_api_service.dart';
import '../../services/chat_store.dart';
import '../../services/chat_signalr_service.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';

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
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLinkEmoji = LayerLink();
  OverlayEntry? _overlayEmoji;

  Conversacion? _conversacion;
  bool _cargando = true;
  bool _estaEscribiendo = false;
  int _fallbackId = 0;
  bool _mostrarEmojiPanel = false;

  static const List<String> _emojis = [
    '😀',
    '😁',
    '😂',
    '🤣',
    '😃',
    '😄',
    '😅',
    '😆',
    '😉',
    '😊',
    '😋',
    '😎',
    '😍',
    '😘',
    '🥰',
    '😗',
    '🙂',
    '🤗',
    '🤩',
    '🤔',
    '😌',
    '😴',
    '😷',
    '🤒',
    '🤕',
    '🤢',
    '🤮',
    '🤯',
    '😤',
    '😠',
    '😡',
    '🥺',
    '😭',
    '😓',
    '😩',
    '😫',
    '🥱',
    '😬',
    '😰',
    '😱',
    '🥳',
    '🥵',
    '🥶',
    '😈',
    '👿',
    '🤡',
    '👹',
    '👺',
    '💀',
    '👻',
    '👽',
    '🤖',
    '💩',
    '👍',
    '👎',
    '👌',
    '✌️',
    '🤞',
    '🤟',
    '🤙',
    '👋',
    '🤝',
    '🙏',
    '💪',
    '❤️',
    '🧡',
    '💛',
    '💚',
    '💙',
    '💜',
    '🖤',
    '🤍',
    '🤎',
    '💔',
    '❣️',
    '💕',
    '💞',
    '💓',
    '💗',
    '💖',
    '🔥',
    '✨',
    '⭐',
    '🌟',
    '💫',
    '💥',
    '💢',
    '💯',
    '🎉',
    '🎊',
    '🎂',
    '🍰',
    '🍅',
    '🌽',
    '🥑',
    '🍎',
    '🍌',
    '🍇',
    '🍓',
    '🍉',
    '☕',
    '🍺',
    '🍷',
    '🥛',
    '📦',
    '🚚',
    '🏡',
    '🌱',
    '🌾',
    '🚜',
    '☀️',
    '🌧️',
    '💬',
    '💭',
    '📞',
    '📷',
    '✅',
    '❌',
    '⚠️',
    'ℹ️',
  ];

  @override
  void initState() {
    super.initState();
    _fallbackId = -(widget.idPedido.abs() + 1);
    print(
      'DEBUG [ChatScreen] initState - idPedido=${widget.idPedido}, idReceptor=${widget.idReceptor}, nombre=${widget.nombreReceptor}, pedido=${widget.codigoPedido}, fallbackId=$_fallbackId',
    );
    _iniciarChat();
  }

  int get _myId {
    final String? userId = ApiSession.instance.userId;
    final parsed = userId != null && userId.isNotEmpty
        ? (int.tryParse(userId) ?? 13)
        : 13;
    print('DEBUG [ChatScreen] get _myId=$parsed (userIdStr=$userId)');
    return parsed;
  }

  int get _idConversacionActiva => _conversacion?.idConversacion ?? _fallbackId;

  Future<void> _iniciarChat() async {
    try {
      print(
        'DEBUG [ChatScreen] _iniciarChat() - Obteniendo/creando conversación...',
      );
      final api = ChatApiService.instance;
      final conv = await api.iniciarConversacion(
        widget.idPedido,
        widget.idReceptor,
      );

      if (conv != null) {
        _conversacion = conv;
        print(
          'DEBUG [ChatScreen] Conversación OK: idConversacion=${conv.idConversacion}',
        );

        print('DEBUG [ChatScreen] Cargando historial de mensajes...');
        final historial = await api.getHistorialMensajes(conv.idConversacion);
        print(
          'DEBUG [ChatScreen] Historial cargado: ${historial.length} mensajes.',
        );
        ChatStore.instance.cargarHistorialChat(conv.idConversacion, historial);

        try {
          print('DEBUG [ChatScreen] Conectando SignalR...');
          final signalR = ChatSignalRService.instance;
          await signalR.conectar();
          print(
            'DEBUG [ChatScreen] SignalR conectado. Uniéndose a grupo conversación ${conv.idConversacion}...',
          );
          await signalR.unirseAConversacion(conv.idConversacion);
          print(
            'DEBUG [ChatScreen] Unirse exitoso. Escuchando mensajes entrantes.',
          );

          signalR.onMensajeRecibido((args) {
            if (args != null && args.isNotEmpty) {
              try {
                final data = args[0] as Map<String, dynamic>;
                final nuevoMsg = MensajeChat(
                  idMensaje: data['idMensaje'] ?? 0,
                  idConversacion: data['idConversacion'] ?? conv.idConversacion,
                  idEmisor: data['idUsuarioEmisor'] ?? 0,
                  nombreEmisor: data['nombreEmisor'] ?? widget.nombreReceptor,
                  contenido: data['contenido'] ?? '',
                  enviadoEn: data['enviadoEn'] != null
                      ? DateTime.tryParse(data['enviadoEn']) ?? DateTime.now()
                      : DateTime.now(),
                  leido: data['leido'] ?? false,
                );
                print(
                  'DEBUG [ChatScreen] 📩 Mensaje RECIBIDO SignalR: idEmisor=${nuevoMsg.idEmisor}, contenido="${nuevoMsg.contenido}"',
                );
                ChatStore.instance.guardarMensajeOffline(
                  conv.idConversacion,
                  nuevoMsg,
                );
                _simularEscribiendoYScroll();
              } catch (e) {
                print('DEBUG [ChatScreen] ERROR parseando mensaje SignalR: $e');
              }
            }
          });
        } catch (signalRErr) {
          print(
            'DEBUG [ChatScreen] ⚠️ ADVERTENCIA: no se pudo conectar SignalR (chat offline solo). Error: $signalRErr',
          );
        }
      } else {
        print(
          'DEBUG [ChatScreen] ⚠️ iniciarConversacion devolvió null -> MODO FALLBACK OFFLINE con idConversacionFalsa=$_fallbackId. NO mostramos error al usuario.',
        );
        ChatStore.instance.cargarHistorialChat(_fallbackId, []);
      }

      if (mounted) {
        setState(() {
          _cargando = false;
        });
        _scrollToBottom();
      }
    } catch (e, stack) {
      print('DEBUG [ChatScreen] ERROR en _iniciarChat: $e');
      print('DEBUG [ChatScreen] StackTrace: $stack');
      print(
        'DEBUG [ChatScreen] Usando fallback offline idConversacion=$_fallbackId sin mostrar error al usuario.',
      );
      ChatStore.instance.cargarHistorialChat(_fallbackId, []);
      if (mounted) {
        setState(() => _cargando = false);
      }
    }
  }

  void _simularEscribiendoYScroll() {
    if (!mounted) return;
    setState(() => _estaEscribiendo = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _estaEscribiendo = false);
        _scrollToBottom();
      }
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    print(
      'DEBUG [ChatScreen] dispose() - Limpiando recursos SignalR/controladores.',
    );
    _cerrarEmojiPanel();
    final signalR = ChatSignalRService.instance;
    signalR.offMensajeRecibido();
    if (_conversacion != null) {
      try {
        signalR.salirDeConversacion(_conversacion!.idConversacion);
      } catch (_) {}
      print(
        'DEBUG [ChatScreen] Salió del grupo SignalR: ${_conversacion!.idConversacion}',
      );
    }
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _cerrarEmojiPanel() {
    _overlayEmoji?.remove();
    _overlayEmoji = null;
    if (_mostrarEmojiPanel) {
      setState(() => _mostrarEmojiPanel = false);
    }
  }

  void _insertarEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = selection.isValid
        ? text.replaceRange(selection.start, selection.end, emoji)
        : text + emoji;
    final newCursor = selection.isValid
        ? selection.start + emoji.length
        : newText.length;
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursor),
    );
    print('DEBUG [ChatScreen] Emoji insertado: $emoji (cursor=$newCursor)');
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  void _abrirEmojiPanel() {
    if (_overlayEmoji != null) {
      _cerrarEmojiPanel();
      return;
    }
    setState(() => _mostrarEmojiPanel = true);
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? MediaQuery.of(context).size;

    _overlayEmoji = OverlayEntry(
      builder: (ctx) {
        final safeBottom = MediaQuery.of(ctx).padding.bottom;
        final h = MediaQuery.of(ctx).size.height;
        final panelHeight = 260.0;
        final bottom =
            MediaQuery.of(ctx).viewInsets.bottom +
            kBottomNavigationBarHeight +
            safeBottom +
            12;
        return Positioned(
          left: 10,
          right: 10,
          bottom: bottom,
          height: panelHeight,
          child: Dismissible(
            key: const ValueKey('emoji_panel_dismiss'),
            direction: DismissDirection.down,
            onDismissed: (_) => _cerrarEmojiPanel(),
            child: Material(
              color: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_emotions_rounded,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Selecciona un emoji',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _cerrarEmojiPanel,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: AppColors.TextSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              childAspectRatio: 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                        itemCount: _emojis.length,
                        itemBuilder: (_, i) {
                          final e = _emojis[i];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => _insertarEmoji(e),
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEmoji!);
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) {
      print('DEBUG [ChatScreen] _enviarMensaje cancelado: texto vacío.');
      return;
    }

    print('DEBUG [ChatScreen] _enviarMensaje: "$texto" (long=${texto.length})');
    _cerrarEmojiPanel();
    final idConv = _idConversacionActiva;
    final myId = _myId;

    final tmpMsg = MensajeChat(
      idMensaje: DateTime.now().millisecondsSinceEpoch,
      idConversacion: idConv,
      idEmisor: myId,
      nombreEmisor: 'Yo',
      contenido: texto,
      enviadoEn: DateTime.now(),
      isOffline: true,
    );

    ChatStore.instance.guardarMensajeOffline(idConv, tmpMsg);
    _controller.clear();
    _scrollToBottom();

    final hubNormal = _conversacion != null;
    if (!hubNormal) {
      print(
        'DEBUG [ChatScreen] ⚠️ Aún no hay conversación con backend. Reintentando iniciarConversacion para asignar id real...',
      );
      try {
        final api = ChatApiService.instance;
        final conv = await api.iniciarConversacion(
          widget.idPedido,
          widget.idReceptor,
        );
        if (conv != null) {
          print(
            'DEBUG [ChatScreen] 🎉 Conseguimos conversación al reintentar: ${conv.idConversacion}. Migrando mensajes locales de $idConv -> ${conv.idConversacion}...',
          );
          final migrados = ChatStore.instance.mensajes(idConv);
          ChatStore.instance.cargarHistorialChat(conv.idConversacion, migrados);
          _conversacion = conv;
          if (mounted) setState(() {});
        } else {
          print(
            'DEBUG [ChatScreen] ⚠️ Aún sin conversación real. Mensaje queda modo Offline (local).',
          );
        }
      } catch (e) {
        print(
          'DEBUG [ChatScreen] Reintento iniciarConversacion falló: $e. Mensaje guardado localmente.',
        );
      }
    }

    if (_conversacion != null) {
      try {
        print(
          'DEBUG [ChatScreen] Enviando por HTTP al backend (conv=${_conversacion!.idConversacion})...',
        );
        await ChatApiService.instance.enviarMensajeHTTP(
          _conversacion!.idConversacion,
          texto,
        );
        print('DEBUG [ChatScreen] Mensaje HTTP enviado EXITOSAMENTE.');
      } catch (e, stack) {
        print('DEBUG [ChatScreen] ERROR enviando mensaje HTTP: $e');
        print('DEBUG [ChatScreen] StackTrace: $stack');
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Sin conexión. El mensaje se reenviará cuando vuelvas a tener red.',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } else {
      print(
        'DEBUG [ChatScreen] Sin conversación todavía. Mensaje guardado 100% local.',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.save_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mensaje guardado localmente. Se enviará cuando se active el chat.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blueGrey.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _formatHora(DateTime dt) {
    String h = dt.hour.toString().padLeft(2, '0');
    String m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: _buildAppBar(),
      body: _cargando
          ? _buildLoading()
          : Column(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: ChatStore.instance,
                    builder: (context, _) {
                      final idConv = _idConversacionActiva;
                      final mensajes = ChatStore.instance.mensajes(idConv);
                      if (mensajes.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                        itemCount: mensajes.length + (_estaEscribiendo ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_estaEscribiendo && index == mensajes.length) {
                            return _buildTypingIndicator();
                          }
                          final msg = mensajes[index];
                          final soyYo = msg.idEmisor == _myId;
                          final bool showAvatar =
                              !soyYo &&
                              (index == 0 ||
                                  mensajes[index - 1].idEmisor != msg.idEmisor);
                          return _buildMessageBubble(msg, soyYo, showAvatar);
                        },
                      );
                    },
                  ),
                ),
                _buildInputBar(),
              ],
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.titleDark,
          size: 20,
        ),
        onPressed: () {
          print('DEBUG [ChatScreen] Back presionado.');
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, Color(0xFF4FA871)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.nombreReceptor.isNotEmpty
                    ? widget.nombreReceptor[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nombreReceptor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        widget.codigoPedido,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.TextSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 14),
          Text(
            'Preparando chat...',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.TextSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(48),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 44,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '¡Sin mensajes aún!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saluda al otro usuario para coordinar la entrega o resolver dudas del pedido.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.TextSoft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                print('DEBUG [ChatScreen] Sugerencia: insertar Hola');
                _controller.text =
                    'Hola! Quería coordinar la entrega del pedido '
                    '${widget.codigoPedido}.';
                _focusNode.requestFocus();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Enviar "Hola"',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.TextMain,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 48, bottom: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(6),
            ),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.5),
                child: _BounceDot(delay: Duration(milliseconds: i * 140)),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MensajeChat msg, bool soyYo, bool showAvatar) {
    final hora = _formatHora(msg.enviadoEn);
    final bgPropio = AppColors.primaryColor;
    final bgAjeno = Colors.white;
    final bordeAjeno = AppColors.cardBorder;

    return Padding(
      padding: EdgeInsets.only(
        left: soyYo ? 40 : (showAvatar ? 4 : 40),
        right: soyYo ? 4 : 40,
        bottom: 6,
        top: 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: soyYo
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!soyYo && showAvatar) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF94A3B8), Color(0xFF64748B)],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  (msg.nombreEmisor.isNotEmpty ? msg.nombreEmisor[0] : '?')
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ] else if (!soyYo && !showAvatar)
            const SizedBox(width: 36),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: soyYo ? bgPropio : bgAjeno,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(soyYo ? 18 : 6),
                  bottomRight: Radius.circular(soyYo ? 6 : 18),
                ),
                border: soyYo ? null : Border.all(color: bordeAjeno),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: soyYo
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!soyYo &&
                      showAvatar &&
                      msg.nombreEmisor.isNotEmpty &&
                      msg.nombreEmisor != 'Usuario') ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        msg.nombreEmisor,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    msg.contenido,
                    style: TextStyle(
                      fontSize: 14.5,
                      color: soyYo ? Colors.white : AppColors.titleDark,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hora,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: soyYo
                              ? Colors.white.withOpacity(0.85)
                              : AppColors.TextSoft,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (soyYo) ...[
                        Icon(
                          msg.isOffline
                              ? Icons.access_time_rounded
                              : Icons.check_circle_rounded,
                          size: 12.5,
                          color: msg.isOffline
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF86EFAC),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 44,
                  maxHeight: 130,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6F4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 6),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          minLines: 1,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.newline,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.titleDark,
                            height: 1.3,
                          ),
                          onTap: _cerrarEmojiPanel,
                          decoration: const InputDecoration(
                            hintText: 'Escribe un mensaje...',
                            hintStyle: TextStyle(
                              color: AppColors.chipGrey,
                              fontSize: 14.5,
                            ),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: _abrirEmojiPanel,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              _mostrarEmojiPanel
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.emoji_emotions_outlined,
                              size: 22,
                              color: _mostrarEmojiPanel
                                  ? AppColors.primaryColor
                                  : AppColors.TextSoft,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(23),
                onTap: _enviarMensaje,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryColor, Color(0xFF4FA871)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BounceDot extends StatefulWidget {
  final Duration delay;
  const _BounceDot({required this.delay});

  @override
  State<_BounceDot> createState() => _BounceDotState();
}

class _BounceDotState extends State<_BounceDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, _anim.value),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
