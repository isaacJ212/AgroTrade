import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final bool showAttachment;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.showAttachment = true,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.White,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 13 is roughly 0.05 opacity
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.showAttachment)
                      IconButton(
                        icon: const Icon(
                          Icons.attach_file,
                          color: AppColors.TextSoft,
                        ),
                        onPressed: () {},
                      ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          hintStyle: TextStyle(color: AppColors.TextSoft),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            top: 14,
                            bottom: 14,
                            right: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: AppColors.White, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
