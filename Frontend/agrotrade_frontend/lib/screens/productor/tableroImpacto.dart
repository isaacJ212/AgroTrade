import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class TableroImpacto extends StatefulWidget {
  const TableroImpacto({super.key});

  @override
  State<TableroImpacto> createState() => _TableroImpactoState();
}

class _TableroImpactoState extends State<TableroImpacto>
    with SingleTickerProviderStateMixin {
  int _tabActual = 0;
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  static const double _metaLograda = 0.87;

  static const List<NavElemento> _navItems = [
    NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
    NavElemento(label: 'Inventario', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
    NavElemento(label: 'Pedidos', icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart),
    NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(begin: 0, end: _metaLograda).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _cambiarTab(int index) {
    setState(() => _tabActual = index);
    if (index != 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Esta sección estará disponible pronto 🌱'),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AgroTrade',
                  style: AppTextStyles.wordmark.copyWith(fontSize: 28),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text('Mi impacto', style: AppTextStyles.headline),
            const SizedBox(height: 4),
            Text(
              'Conocé el impacto generado por tus ventas en AgroTrade.',
              style: AppTextStyles.SubTitle.copyWith(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _ImpactoCard(
                    icon: Icons.eco_outlined,
                    iconColor: AppColors.primaryColor,
                    iconBg: AppColors.primarySoftBg,
                    title: 'Productos\nsalvados',
                    value: '128 libras',
                    valueColor: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ImpactoCard(
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.accentBlue,
                    iconBg: AppColors.blueSoft,
                    title: 'Ingreso\nadicional',
                    value: 'C\$ 4,850.00',
                    valueColor: AppColors.accentBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ImpactoCard(
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.bodyText,
                    iconBg: AppColors.tileBg,
                    title: 'Pedidos\ncompletados',
                    value: '24',
                    valueColor: AppColors.titleDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ImpactoCard(
                    icon: Icons.storefront_outlined,
                    iconColor: AppColors.bodyText,
                    iconBg: AppColors.tileBg,
                    title: 'Ventas\ndirectas',
                    value: '87%',
                    valueColor: AppColors.titleDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Impacto del mes', style: AppTextStyles.sectionTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 24),

                  Center(
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, _) {
                        return SizedBox(
                          width: 160,
                          height: 160,
                          child: CustomPaint(
                            painter: _CircularProgressPainter(
                              progress: _progressAnimation.value,
                              trackColor: AppColors.chipGrey.withValues(alpha: 0.4),
                              progressColor: AppColors.primaryColor,
                              strokeWidth: 14,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    'Meta lograda',
                                    style: AppTextStyles.SubTitle.copyWith(
                                      fontSize: 12,
                                      color: AppColors.bodyText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LeyendaDot(color: AppColors.primaryColor, label: 'Venta directa'),
                      const SizedBox(width: 20),
                      _LeyendaDot(color: AppColors.chipGrey, label: 'Intermediarios'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.eco_rounded,
                      color: AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cada producto vendido directamente ayuda a reducir pérdidas y fortalecer tu producción.',
                      style: AppTextStyles.SubTitle.copyWith(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.bodyText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: _navItems,
        currentIndex: _tabActual,
        onTap: _cambiarTab,
      ),
    );
  }
}

class _ImpactoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final Color valueColor;

  const _ImpactoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.SubTitle.copyWith(fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeyendaDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LeyendaDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    const startAngle = -math.pi / 2;


    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);


    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) =>
      old.progress != progress;
}
