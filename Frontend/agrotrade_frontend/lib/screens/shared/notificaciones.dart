import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';

class Notificaciones extends StatelessWidget {
  const Notificaciones({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for notifications
    final List<Map<String, dynamic>> _mockNotifications = [
      {
        'icon': Icons.local_shipping,
        'title': 'Pedido en camino',
        'description': 'El repartidor José Pérez ha recogido tu pedido y está en camino.',
        'time': 'Hace 10 min',
        'isUnread': true,
      },
      {
        'icon': Icons.check_circle,
        'title': 'Pedido entregado',
        'description': 'Tu pedido de aguacates ha sido entregado exitosamente.',
        'time': 'Ayer',
        'isUnread': false,
      },
      {
        'icon': Icons.message,
        'title': 'Nuevo mensaje de María',
        'description': 'Hola, ¿qué tal? Te escribo por el pedido...',
        'time': 'Ayer',
        'isUnread': false,
      },
      {
        'icon': Icons.warning_amber,
        'title': 'Actualización de seguridad',
        'description': 'Hemos actualizado nuestros términos de servicio. Por favor revísalos.',
        'time': 'Hace 2 días',
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.TextMain),
        title: const Text(
          'Notificaciones',
          style: AppTextStyles.Title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.primaryColor),
            tooltip: 'Marcar todas como leídas',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las notificaciones marcadas como leídas'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: _mockNotifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 64, color: AppColors.cardBorder),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes notificaciones nuevas',
                    style: AppTextStyles.SubTitle,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _mockNotifications.length,
              itemBuilder: (context, index) {
                final notif = _mockNotifications[index];
                return NotificationTile(
                  icon: notif['icon'],
                  title: notif['title'],
                  description: notif['description'],
                  time: notif['time'],
                  isUnread: notif['isUnread'],
                  onTap: () {
                    // Acción al tocar la notificación
                  },
                );
              },
            ),
    );
  }
}
