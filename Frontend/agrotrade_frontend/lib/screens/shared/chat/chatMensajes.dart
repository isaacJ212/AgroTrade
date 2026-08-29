import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';

class ChatMensajes extends StatefulWidget {
  final String contactName;
  final String contactRole;
  final String contactAvatar;

  const ChatMensajes({
    super.key,
    required this.contactName,
    required this.contactRole,
    this.contactAvatar = 'https://i.pravatar.cc/150', // placeholder
  });

  @override
  State<ChatMensajes> createState() => _ChatMensajesState();
}

class _ChatMensajesState extends State<ChatMensajes> {

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

  void _sendMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'time': 'Ahora',
        'isMe': true,
      });
    });
  }

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
              backgroundImage: NetworkImage(widget.contactAvatar),
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
        actions: [
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
          ChatInputField(onSend: _sendMessage),
        ],
      ),
    );
  }
}
