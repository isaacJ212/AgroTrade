import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';

class ChatMensajes extends StatefulWidget {
  final String contactName;
  final String contactRole;
  final String contactAvatar;
  final List<Map<String, dynamic>>? initialMessages;
  final ValueChanged<List<Map<String, dynamic>>>? onMessagesChanged;
  final bool producerMode;

  const ChatMensajes({
    super.key,
    required this.contactName,
    required this.contactRole,
    this.contactAvatar = 'https://i.pravatar.cc/150', // placeholder
    this.initialMessages,
    this.onMessagesChanged,
    this.producerMode = false,
  });

  @override
  State<ChatMensajes> createState() => _ChatMensajesState();
}

class _ChatMensajesState extends State<ChatMensajes> {
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hola, ¿qué tal? Te escribo por el pedido de aguacates.',
      'time': '10:30 AM',
      'isMe': false,
    },
    {
      'text': '¡Hola! Todo bien. Sí, los estoy preparando ahora mismo.',
      'time': '10:32 AM',
      'isMe': true,
    },
    {
      'text': 'Perfecto. ¿Crees que lleguen para antes del mediodía?',
      'time': '10:33 AM',
      'isMe': false,
    },
    {
      'text': 'Sí, sin problema. El repartidor ya está en camino hacia la finca.',
      'time': '10:35 AM',
      'isMe': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessages != null) {
      _messages..clear()..addAll(widget.initialMessages!.map((m) => Map<String, dynamic>.from(m)));
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'time': 'Ahora',
        'isMe': true,
      });
    });
    widget.onMessagesChanged?.call(List.of(_messages));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.TextMain),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: widget.producerMode ? null : NetworkImage(widget.contactAvatar),
              child: widget.producerMode ? const Icon(Icons.person_outline) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: AppTextStyles.label.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.contactRole,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: widget.producerMode ? [] : [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // TODO: Implement call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
             
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return MessageBubble(
                  text: msg['text'],
                  time: msg['time'],
                  isMe: msg['isMe'],
                );
              },
            ),
          ),
          ChatInputField(onSend: _sendMessage, showAttachment: !widget.producerMode),
        ],
      ),
    );
  }
}
