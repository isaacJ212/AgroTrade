import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_session.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

/// Modelo simple de mensaje de AgroBot.
class _AgrobotMessage {
  final String text;
  final bool isUser;
  final String time;

  /// Ruta de acción contextual (opcional, solo en mensajes del bot).
  final String? actionLabel;
  final String? actionRoute;

  const _AgrobotMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.actionLabel,
    this.actionRoute,
  });
}

/// Pantalla de chat con AgroBot.
/// Accesible para todos los roles.
class AgrobotChat extends StatefulWidget {
  const AgrobotChat({super.key});

  @override
  State<AgrobotChat> createState() => _AgrobotChatState();
}

class _AgrobotChatState extends State<AgrobotChat> {
  final ScrollController _scrollController = ScrollController();

  final List<_AgrobotMessage> _messages = [
    _AgrobotMessage(
      text:
          '¡Hola! Soy AgroBot, tu asistente experto en el mercado. '
          '¿En qué te puedo ayudar hoy?',
      isUser: false,
      time: 'Hoy, 10:45 AM',
    ),
  ];

  // Respuestas demo basadas en palabras clave
  static const Map<String, _AgrobotMessage> _responses = {
    'inventario': _AgrobotMessage(
      text:
          'Es muy fácil. Desde la sección de Inventario, seleccioná el producto '
          'que querés modificar y tocá el botón "Actualizar inventario". '
          'Podés ajustar la cantidad disponible y el precio por cajón.',
      isUser: false,
      time: 'Ahora',
      actionLabel: 'Ir a Mi Inventario →',
      actionRoute: AppRoutes.inventario,
    ),
    'precio': _AgrobotMessage(
      text:
          'La calculadora de Precio Justo te ayuda a definir un precio '
          'basado en tus costos de producción y el margen de ganancia que deseás.',
      isUser: false,
      time: 'Ahora',
      actionLabel: 'Calculadora de Precio Justo →',
      actionRoute: AppRoutes.calculadoraPrecioJusto,
    ),
    'pedido': _AgrobotMessage(
      text:
          'Podés consultar el estado de tus pedidos desde la sección '
          '"Mis Pedidos". Allí verás el historial completo y el seguimiento en tiempo real.',
      isUser: false,
      time: 'Ahora',
      actionLabel: 'Ver Mis Pedidos →',
      actionRoute: AppRoutes.misPedidos,
    ),
    'entrega': _AgrobotMessage(
      text:
          'Para ver tus entregas activas, dirigite a la sección de Entregas. '
          'Podés ver la ruta y comunicarte con el repartidor.',
      isUser: false,
      time: 'Ahora',
    ),
    'perfil': _AgrobotMessage(
      text:
          'Desde tu perfil podés editar tus datos personales, '
          'cambiar tu contraseña y gestionar la información de tu cuenta.',
      isUser: false,
      time: 'Ahora',
      actionLabel: 'Ir a Mi Perfil →',
      actionRoute: AppRoutes.profile,
    ),
  };

  static const _AgrobotMessage _defaultResponse = _AgrobotMessage(
    text:
        'Entendido. Por el momento no tengo información específica sobre eso, '
        'pero podés explorar las secciones de la app o consultar el Centro de Ayuda.',
    isUser: false,
    time: 'Ahora',
    actionLabel: 'Centro de Ayuda →',
    actionRoute: AppRoutes.centroAyuda,
  );

  void _sendMessage(String text) {
    final userMsg = _AgrobotMessage(
      text: text,
      isUser: true,
      time: 'Ahora',
    );

    // Buscar respuesta por palabra clave
    final lower = text.toLowerCase();
    _AgrobotMessage botResponse = _defaultResponse;
    for (final key in _responses.keys) {
      if (lower.contains(key)) {
        botResponse = _responses[key]!;
        break;
      }
    }

    setState(() {
      _messages.add(userMsg);
    });

    // Simular typing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(botResponse);
      });
      _scrollToBottom();
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onNavTap(int index) {
    if (index == 2) return;
    final roles = ApiSession.instance.roles;
    if (index == 0) {
      if (roles.contains('Productor/Proveedor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
      } else if (roles.contains('Repartidor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
      }
    } else if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.explorarProductos);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.profile);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.White,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Image.asset(
                    'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'AgroBot',
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 17,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            Text(
              'Asistente virtual 24/7',
              style: AppTextStyles.SubTitle.copyWith(
                fontSize: 12,
                color: AppColors.bodyText,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.agrobotHistory),
            icon: const Icon(
              Icons.history_rounded,
              size: 18,
              color: AppColors.bodyText,
            ),
            label: Text(
              'Historial',
              style: AppTextStyles.SubTitle.copyWith(
                color: AppColors.bodyText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Lista de mensajes ──────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Primer mensaje: muestra timestamp centrado arriba
                  return Column(
                    children: [
                      _TimestampChip(label: _messages[0].time),
                      const SizedBox(height: 8),
                      _buildBubble(_messages[0]),
                    ],
                  );
                }
                return _buildBubble(_messages[index]);
              },
            ),
          ),

          // ── Input ─────────────────────────────────────────────────────
          _AgrobotInputField(
            onSend: _sendMessage,
          ),
        ],
      ),
      bottomNavigationBar: const AgrobotBottomNav(),
    );
  }

  Widget _buildBubble(_AgrobotMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.White,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    // Burbuja del bot
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar del bot
          SizedBox(
            width: 32,
            height: 32,
            child: Image.asset(
              'lib/assets/images/Agrobot/assets_preview_rev_1.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoftBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 14,
                      color: AppColors.TextMain,
                      height: 1.5,
                    ),
                  ),
                ),
                if (msg.actionLabel != null && msg.actionRoute != null) ...[
                  const SizedBox(height: 8),
                  _ActionChip(
                    label: msg.actionLabel!,
                    onTap: () =>
                        Navigator.pushNamed(context, msg.actionRoute!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip con timestamp centrado en la conversación.
class _TimestampChip extends StatelessWidget {
  final String label;
  const _TimestampChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.tileBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.SubTitle.copyWith(
            fontSize: 12,
            color: AppColors.bodyText,
          ),
        ),
      ),
    );
  }
}

/// Botón de acción contextual dentro de la burbuja del bot.
class _ActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Campo de input adaptado para AgroBot con hint específico.
class _AgrobotInputField extends StatefulWidget {
  final Function(String) onSend;

  const _AgrobotInputField({required this.onSend});

  @override
  State<_AgrobotInputField> createState() => _AgrobotInputFieldState();
}

class _AgrobotInputFieldState extends State<_AgrobotInputField> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.White,
        border: const Border(
          top: BorderSide(color: AppColors.cardBorder),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 110),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _handleSend(),
                  decoration: InputDecoration(
                    hintText: 'Preguntale algo a AgroBot...',
                    hintStyle: AppTextStyles.SubTitle.copyWith(
                      fontSize: 14,
                      color: AppColors.bodyText.withValues(alpha: 0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.White,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
