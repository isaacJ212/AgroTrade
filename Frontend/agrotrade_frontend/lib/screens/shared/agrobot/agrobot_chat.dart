import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/agrobot_api_service.dart';
import '../../../services/api_client.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

class _AgrobotMessage {
  final String text;
  final bool isUser;
  final String time;

  const _AgrobotMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class AgrobotChat extends StatefulWidget {
  final String? chatId;

  const AgrobotChat({super.key, this.chatId});

  @override
  State<AgrobotChat> createState() => _AgrobotChatState();
}

class _AgrobotChatState extends State<AgrobotChat> {
  final ScrollController _scrollController = ScrollController();
  String? _chatId;
  bool _isLoading = false;
  String? _errorMessage;

  final List<_AgrobotMessage> _messages = [
    _AgrobotMessage(
      text:
          '¡Hola! Soy AgroBot, tu asistente experto en el mercado. '
          '¿En qué te puedo ayudar hoy?',
      isUser: false,
      time: 'Hoy, 10:45 AM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;
    if (_chatId != null && _chatId!.isNotEmpty) _loadConversation(_chatId!);
  }

  Future<void> _loadConversation(String chatId) async {
    setState(() => _isLoading = true);
    try {
      final history = await AgrobotApiService.instance.getConversation(chatId);
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(
            history.map(
              (message) => _AgrobotMessage(
                text: message.content,
                isUser: message.role.toLowerCase() == 'user',
                time: 'Historial',
              ),
            ),
          );
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = _AgrobotMessage(text: text, isUser: true, time: 'Ahora');

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final result = await AgrobotApiService.instance.sendMessage(
        chatId: _chatId ?? '',
        message: text,
      );
      if (!mounted) return;
      setState(() {
        _chatId = result.chatId;
        _messages.add(
          _AgrobotMessage(text: result.response, isUser: false, time: 'Ahora'),
        );
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
      _scrollToBottom();
    }

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.White,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const Icon(
              Icons.smart_toy_outlined,
              color: Color(0xFF064E3B),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'AgroBot',
              style: AppTextStyles.Title.copyWith(
                fontSize: 20,
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.w700,
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
              size: 20,
              color: Color(0xFF4B5563),
            ),
            label: Text(
              'Historial',
              style: AppTextStyles.SubTitle.copyWith(
                color: const Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            MaterialBanner(
              content: Text(_errorMessage!),
              actions: [
                TextButton(
                  onPressed: () => setState(() => _errorMessage = null),
                  child: const Text('Cerrar'),
                ),
              ],
            ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F6F4),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipOval(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              'lib/assets/images/Agrobot/AgrobotCompleto.png',
                              fit: BoxFit.contain,
                              width: 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'AgroBot',
                        style: AppTextStyles.Title.copyWith(
                          fontSize: 24,
                          color: const Color(0xFF1F2937),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Asistente virtual 24/7',
                        style: AppTextStyles.SubTitle.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 24),
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

          if (_isLoading) const LinearProgressIndicator(minHeight: 2),
          _AgrobotInputField(onSend: _sendMessage),
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
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF064E3B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(bottom: 2),
            child: Image.asset(
              'lib/assets/images/Agrobot/assets-removebg-preview.png',
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
                    vertical: 12,
                    horizontal: 16,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF72A9FE),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    msg.text,
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 14,
                      color: const Color(0xFF1F2937),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        border: const Border(top: BorderSide(color: AppColors.cardBorder)),
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
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
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
                      color: const Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF064E3B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
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
