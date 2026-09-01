import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import 'entregasRepartidor.dart';
import 'homeRepartidor.dart';
import 'entregaEnCursoRepartidor.dart';

class RutaEntregaRepartidor extends StatelessWidget {
  const RutaEntregaRepartidor({super.key});

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
                        'Ruta',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
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
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(_mapUrl, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x33F8F9FA), Color(0xAAF8F9FA)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 64,
                    child: _InstructionBanner(
                      onTap: () => _showSnack(context, 'Siguiente indicación'),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _FloatingControl(
                          icon: Icons.my_location_outlined,
                          onTap: () => _showSnack(context, 'Ubicación actual'),
                        ),
                        const SizedBox(height: 12),
                        _FloatingControl(
                          icon: Icons.layers_outlined,
                          onTap: () => _showSnack(context, 'Capas del mapa'),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: _RouteCard(
                      onStartRoute: () => _go(context, const EntregaEnCursoRepartidor()),
                      onDetails: () => _go(context, const Entregasrepartidor()),
                      onMore: () => _showSnack(context, 'Más opciones'),
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
            _go(context, const Entregasrepartidor());
            return;
          }
          _showSnack(context, 'Perfil disponible pronto');
        },
      ),
    );
  }
}

class _FloatingControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingControl({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBg,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: AppColors.bodyText),
        ),
      ),
    );
  }
}

class _InstructionBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _InstructionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBg,
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6E3FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.turn_right, color: AppColors.accentBlue),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continuá hacia el centro de Jinotepe.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.titleDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'En 200m',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bodyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  final VoidCallback onStartRoute;
  final VoidCallback onDetails;
  final VoidCallback onMore;

  const _RouteCard({
    required this.onStartRoute,
    required this.onDetails,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xF2F8F9FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'ENTREGA #AT-2051',
                      style: AppTextStyles.chip.copyWith(
                        color: AppColors.primarySoft,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Destino: Jinotepe',
                    style: AppTextStyles.label.copyWith(fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '25 min',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 16,
                      color: AppColors.accentBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '12.5 km',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.cardBorder),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onStartRoute,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Iniciar ruta',
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
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentBlue,
                      side: const BorderSide(color: AppColors.accentBlue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ver detalles',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 48,
                height: 48,
                child: Material(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onMore,
                    borderRadius: BorderRadius.circular(12),
                    child: const Icon(Icons.more_vert, color: AppColors.bodyText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
