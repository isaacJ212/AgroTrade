import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/widgets/repartidor_bottom_nav.dart';
import 'confirmarEntregaRepartidor.dart';
import 'homeRepartidor.dart';
import 'rutaEntregaRepartidor.dart';

class EntregaEnCursoRepartidor extends StatelessWidget {
  const EntregaEnCursoRepartidor({super.key});

  static const String _mapUrl =
      'https://www.figma.com/api/mcp/asset/596594d3-4cf9-47e3-b0a3-951b4f1512a4.png';

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: AppColors.surfaceAlt,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Entrega en curso',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showSnack(context, 'Notificaciones'),
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.bodyText),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  SizedBox(
                    height: 256,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(_mapUrl, fit: BoxFit.cover),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.schedule_outlined,
                                  color: AppColors.primarySoft,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '25 min restantes',
                                  style: AppTextStyles.label.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      children: [
                        _DeliveryInfoCard(
                          onTapRoute: () => _go(context, const RutaEntregaRepartidor()),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _go(context, const ConfirmarEntregaRepartidor()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Llegué al destino',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showSnack(context, 'Mensaje enviado'),
                                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                  label: const Text(
                                    'Mensaje',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.titleDark,
                                    side: const BorderSide(color: AppColors.bodyText),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showSnack(context, 'Llamando...'),
                                  icon: const Icon(Icons.call_outlined, size: 18),
                                  label: const Text(
                                    'Llamar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.titleDark,
                                    side: const BorderSide(color: AppColors.bodyText),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () => _showSnack(context, 'Incidencia reportada'),
                          icon: const Icon(Icons.warning_amber_outlined, color: AppColors.inputErrorColor),
                          label: const Text(
                            'Reportar problema',
                            style: TextStyle(
                              color: AppColors.inputErrorColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RepartidorBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          if (index == 0) {
            _go(context, const InicioRepartidor());
            return;
          }
          if (index == 1) {
            _go(context, const RutaEntregaRepartidor());
            return;
          }
          _showSnack(context, 'Perfil disponible pronto');
        },
      ),
    );
  }
}

class _DeliveryInfoCard extends StatelessWidget {
  final VoidCallback onTapRoute;

  const _DeliveryInfoCard({required this.onTapRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrega #AT-2051',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Recipiente: María López',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                    ),
                    Text(
                      'Destino: Jinotepe',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, color: AppColors.primarySoft, size: 8),
                    const SizedBox(width: 8),
                    Text(
                      'En camino',
                      style: AppTextStyles.label.copyWith(fontSize: 12, color: AppColors.primarySoft),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.cardBorder),
          const SizedBox(height: 12),
          const _TimelineMini(),
          const SizedBox(height: 12),
          const Divider(color: AppColors.cardBorder),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: AppColors.primarySoft),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Indicaciones de entrega\n"Casa de portón verde, frente al parque."',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
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

class _TimelineMini extends StatelessWidget {
  const _TimelineMini();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineRow(
          title: 'Pedido recogido',
          completed: true,
          crossedOut: true,
          icon: Icons.check,
        ),
        _TimelineRow(
          title: 'En camino',
          completed: true,
          active: true,
          icon: Icons.local_shipping_outlined,
        ),
        _TimelineRow(
          title: 'Llegada al destino',
          icon: Icons.location_on_outlined,
        ),
        _TimelineRow(
          title: 'Entregado',
          icon: Icons.home_outlined,
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String title;
  final bool completed;
  final bool active;
  final bool crossedOut;
  final IconData icon;

  const _TimelineRow({
    required this.title,
    required this.icon,
    this.completed = false,
    this.active = false,
    this.crossedOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = completed || active;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone ? AppColors.primarySoft : AppColors.cardBorder,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? AppColors.primaryColor : Colors.white,
                width: active ? 3 : 0,
              ),
            ),
            child: Icon(
              icon,
              size: 14,
              color: isDone ? Colors.white : AppColors.bodyText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: AppColors.bodyText,
                decoration: crossedOut ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
