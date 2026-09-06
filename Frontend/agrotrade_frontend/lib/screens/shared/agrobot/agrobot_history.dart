import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../models/api/agrobot_models.dart';
import '../../../services/agrobot_api_service.dart';
import '../../../services/api_client.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

/// Pantalla de hstorial de AgroBot.
class AgrobotHistory extends StatefulWidget {
  const AgrobotHistory({super.key});

  @override
  State<AgrobotHistory> createState() => _AgrobotHistoryState();
}

class _AgrobotHistoryState extends State<AgrobotHistory> {
  late Future<List<AgrobotConversation>> _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _conversationsFuture = AgrobotApiService.instance.getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.White,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F6F4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.only(top: 4),
              child: ClipOval(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                    fit: BoxFit.contain,
                    width: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AgroBot',
              style: AppTextStyles.Title.copyWith(
                fontSize: 18,
                color: AppColors.titleDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
            Text(
              'Historial de AgroBot',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Revisá tus consultas anteriores.',
              style: AppTextStyles.SubTitle.copyWith(
                fontSize: 14,
                color: AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 24),

            FutureBuilder<List<AgrobotConversation>>(
              future: _conversationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  final message = snapshot.error is ApiException
                      ? (snapshot.error as ApiException).message
                      : 'No se pudo cargar el historial.';
                  return Center(child: Text(message));
                }
                final conversations = snapshot.data ?? const [];
                if (conversations.isEmpty) return _EmptyHistorial();
                return Column(
                  children: conversations.map((conversation) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _HistorialCard(
                        title: conversation.title,
                        onContinuar: () => Navigator.pushNamed(
                          context,
                          AppRoutes.agrobotChat,
                          arguments: {'chatId': conversation.chatId},
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AgrobotBottomNav(),
    );
  }
}

// Tarjeta de conversación del historial.
class _HistorialCard extends StatelessWidget {
  final String title;
  final VoidCallback onContinuar;

  const _HistorialCard({required this.title, required this.onContinuar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tarjeta
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'Chat',
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // botón Continuar
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onContinuar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF064E3B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Continuar',
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF064E3B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado vacío cuando no hay historial.
class _EmptyHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin historial aún',
            style: AppTextStyles.headline.copyWith(
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus conversaciones con AgroBot\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
