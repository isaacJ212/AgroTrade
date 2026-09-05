import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_session.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';


class AgrobotWelcome extends StatefulWidget {
  const AgrobotWelcome({super.key});

  @override
  State<AgrobotWelcome> createState() => _AgrobotWelcomeState();
}

class _AgrobotWelcomeState extends State<AgrobotWelcome> {

  static const List<_FaqItem> _faqItems = [
    _FaqItem(
      icon: Icons.inventory_2_outlined,
      label: 'Productos e inventario',
      content:
          'Podés agregar, editar y eliminar productos de tu inventario. '
          'También podés registrar cosechas y ver el historial de stock.',
      iconColor: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
    _FaqItem(
      icon: Icons.balance_outlined,
      label: 'Precio Justo',
      content:
          'Usá la calculadora de Precio Justo para determinar el precio '
          'sugerido de tus productos con base en tus costos y margen de ganancia.',
      iconColor: Color(0xFFD97706),
      bgColor: Color(0xFFFEF3C7),
    ),
    _FaqItem(
      icon: Icons.receipt_long_outlined,
      label: 'Pedidos',
      content:
          'Desde la sección de Pedidos podés ver todos los pedidos recibidos, '
          'prepararlos y marcarlos como listos para entrega.',
      iconColor: Color(0xFF2563EB),
      bgColor: Color(0xFFDBEAFE),
    ),
    _FaqItem(
      icon: Icons.local_shipping_outlined,
      label: 'Entregas',
      content:
          'Podés hacer seguimiento de tus entregas en tiempo real y comunicarte '
          'con el repartidor asignado.',
      iconColor: Color(0xFF4B5563),
      bgColor: Color(0xFFF3F4F6),
    ),
    _FaqItem(
      icon: Icons.person_outline,
      label: 'Cuenta',
      content:
          'Editá tu perfil, cambiá tu contraseña y gestioná la información '
          'de tu finca o cuenta de comprador.',
      iconColor: Color(0xFF059669),
      bgColor: Color(0xFFECFDF5),
    ),
  ];



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
              style: AppTextStyles.Title.copyWith(
                fontSize: 18,
                color: AppColors.titleDark,
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
              size: 18,
              color: AppColors.bodyText,
            ),
            label: Text(
              'Historial',
              style: AppTextStyles.SubTitle.copyWith(
                color: AppColors.bodyText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          children: [
            const SizedBox(height: 40),

            // Ilustración + saludo 
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F6F4), 
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.only(top: 15), 
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'lib/assets/images/Agrobot/AgrobotCompleto.png',
                      fit: BoxFit.contain,
                      width: 110,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hola, soy AgroBot',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 24,
                color: const Color(0xFF064E3B), 
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu asistente en AgroTrade',
              textAlign: TextAlign.center,
              style: AppTextStyles.headline.copyWith(
                fontSize: 18,
                color: const Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Estoy acá para ayudarte a usar\nAgroTrade de forma fácil y rápida.',
                textAlign: TextAlign.center,
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 15,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── FAQ
            Text(
              '¿En qué puedo ayudarte?',
              style: AppTextStyles.label.copyWith(
                fontSize: 14,
                color: const Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),


            ...List.generate(_faqItems.length, (index) {
              final item = _faqItems[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: AppColors.White,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: item.bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            size: 20,
                            color: item.iconColor,
                          ),
                        ),
                        title: Text(
                          item.label,
                          style: AppTextStyles.label.copyWith(
                            fontSize: 15,
                            color: const Color(0xFF1F2937),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        iconColor: const Color(0xFF9CA3AF),
                        collapsedIconColor: const Color(0xFF9CA3AF),
                        children: [
                          Text(
                            item.content,
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              );
            }),

            const SizedBox(height: 24),

            
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD1FAE5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      size: 28,
                      color: Color(0xFF064E3B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¿No encontraste lo que buscabas?',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 15,
                      color: const Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF064E3B), 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.agrobotChat),
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                      label: const Text(
                        'Preguntarle a AgroBot',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
  final Color iconColor;
  final Color bgColor;

  const _FaqItem({
    required this.icon,
    required this.label,
    required this.content,
    required this.iconColor,
    required this.bgColor,
  });
}
