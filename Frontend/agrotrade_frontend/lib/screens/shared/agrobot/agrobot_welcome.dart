import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_session.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

/// Pantalla de bienvenida de AgroBot.
/// Accesible para todos los roles: Cliente, Productor y Repartidor.
class AgrobotWelcome extends StatefulWidget {
  const AgrobotWelcome({super.key});

  @override
  State<AgrobotWelcome> createState() => _AgrobotWelcomeState();
}

class _AgrobotWelcomeState extends State<AgrobotWelcome> {
  // Categorías del FAQ
  static const List<_FaqItem> _faqItems = [
    _FaqItem(
      icon: Icons.inventory_2_outlined,
      label: 'Productos e inventario',
      content:
          'Podés agregar, editar y eliminar productos de tu inventario. '
          'También podés registrar cosechas y ver el historial de stock.',
    ),
    _FaqItem(
      icon: Icons.balance_outlined,
      label: 'Precio Justo',
      content:
          'Usá la calculadora de Precio Justo para determinar el precio '
          'sugerido de tus productos con base en tus costos y margen de ganancia.',
    ),
    _FaqItem(
      icon: Icons.receipt_long_outlined,
      label: 'Pedidos',
      content:
          'Desde la sección de Pedidos podés ver todos los pedidos recibidos, '
          'prepararlos y marcarlos como listos para entrega.',
    ),
    _FaqItem(
      icon: Icons.local_shipping_outlined,
      label: 'Entregas',
      content:
          'Podés hacer seguimiento de tus entregas en tiempo real y comunicarte '
          'con el repartidor asignado.',
    ),
    _FaqItem(
      icon: Icons.person_outline,
      label: 'Cuenta',
      content:
          'Editá tu perfil, cambiá tu contraseña y gestioná la información '
          'de tu finca o cuenta de comprador.',
    ),
  ];

  void _onNavTap(int index) {
    if (index == 2) return; // ya estamos en AgroBot
    final session = ApiSession.instance;
    final roles = session.roles;

    if (index == 0) {
      // Inicio → redirige según rol
      if (roles.contains('Productor/Proveedor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
      } else if (roles.contains('Repartidor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
      }
    } else if (index == 1) {
      // Mercado
      Navigator.pushNamed(context, AppRoutes.explorarProductos);
    } else if (index == 3) {
      // Perfil
      Navigator.pushNamed(context, AppRoutes.profile);
    }
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
            SizedBox(
              width: 34,
              height: 34,
              child: Image.asset(
                'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AgroBot',
              style: AppTextStyles.headline.copyWith(
                fontSize: 18,
                color: AppColors.primaryColor,
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
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          children: [
            const SizedBox(height: 32),

            // ── Ilustración + saludo ────────────────────────────────────────────────
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.navPill,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hola, soy AgroBot',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 22,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tu asistente en AgroTrade',
              textAlign: TextAlign.center,
              style: AppTextStyles.headline.copyWith(
                fontSize: 16,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Estoy acá para ayudarte a usar\nAgroTrade de forma fácil y rápida.',
              textAlign: TextAlign.center,
              style: AppTextStyles.SubTitle.copyWith(
                fontSize: 14,
                color: AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 32),

            // ── FAQ ───────────────────────────────────────────────────────
            Text(
              '¿En qué puedo ayudarte?',
              style: AppTextStyles.label.copyWith(
                fontSize: 15,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 12),

            Material(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cardBorder),
                  borderRadius: BorderRadius.circular(14),
                ),
              child: Column(
                children: List.generate(_faqItems.length, (index) {
                  final item = _faqItems[index];
                  final isLast = index == _faqItems.length - 1;
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16, 0, 16, 14,
                          ),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primarySoftBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              item.icon,
                              size: 18,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          title: Text(
                            item.label,
                            style: AppTextStyles.label.copyWith(
                              fontSize: 14,
                              color: AppColors.titleDark,
                            ),
                          ),
                          iconColor: AppColors.bodyText,
                          collapsedIconColor: AppColors.bodyText,
                          children: [
                            Text(
                              item.content,
                              style: AppTextStyles.SubTitle.copyWith(
                                fontSize: 13,
                                color: AppColors.bodyText,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.cardBorder,
                        ),
                    ],
                  );
                }),
              ),
            ),
            ),

            const SizedBox(height: 24),

            // ── CTA ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      size: 28,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¿No encontraste lo que buscabas?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 14,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Preguntarle a AgroBot',
                    radius: 12,
                    icon: Icons.chat_bubble_outline_rounded,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.agrobotChat),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AgrobotBottomNav(),
    );
  }
}

class _FaqItem {
  final IconData icon;
  final String label;
  final String content;

  const _FaqItem({
    required this.icon,
    required this.label,
    required this.content,
  });
}
