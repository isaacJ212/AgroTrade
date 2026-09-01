import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../productor/ofertas/crearOferta.dart';

class MapaCalorDemanda extends StatefulWidget {
  const MapaCalorDemanda({super.key});

  @override
  State<MapaCalorDemanda> createState() => _MapaCalorDemandaState();
}

class _MapaCalorDemandaState extends State<MapaCalorDemanda>
    with SingleTickerProviderStateMixin {
  int _tabActual = 1; 

  String? _productoSeleccionado = 'Tomate';
  String? _periodoSeleccionado = 'Últimos 30 días';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _productos = [
    'Tomate', 'Maíz', 'Frijol', 'Café', 'Aguacate',
  ];
  final List<String> _periodos = [
    'Últimos 7 días', 'Últimos 30 días', 'Últimos 3 meses',
  ];

  static const List<NavElemento> _navItems = [
    NavElemento(label: 'Inicio',     icon: Icons.home_outlined,       activeIcon: Icons.home),
    NavElemento(label: 'Inventario', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2),
    NavElemento(label: 'Pedidos',    icon: Icons.shopping_cart_outlined,activeIcon: Icons.shopping_cart),
    NavElemento(label: 'Perfil',     icon: Icons.person_outline,       activeIcon: Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _cambiarTab(int index) {
    setState(() => _tabActual = index);
    if (index != 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Esta sección estará disponible pronto 🌱'),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  void _publicarOferta() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CrearOferta()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mapa de Calor',
          style: AppTextStyles.wordmark.copyWith(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.titleDark),
            onPressed: () => _mostrarOpciones(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.cardBorder, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Text('Demanda por zona', style: AppTextStyles.headline),
          const SizedBox(height: 4),
          Text(
            'Identificá las zonas con mayor interés en tus productos.',
            style: AppTextStyles.SubTitle.copyWith(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),

          _FiltroDropdown<String>(
            prefixIcon: Icons.grass_outlined,
            value: _productoSeleccionado,
            items: _productos,
            itemLabel: (e) => e,
            onChanged: (val) => setState(() => _productoSeleccionado = val),
          ),
          const SizedBox(height: 10),
          _FiltroDropdown<String>(
            prefixIcon: Icons.calendar_today_outlined,
            value: _periodoSeleccionado,
            items: _periodos,
            itemLabel: (e) => e,
            onChanged: (val) => setState(() => _periodoSeleccionado = val),
          ),
          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 230,
              color: const Color(0xFF5A8F7B),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapaPainter(
                        pulso: _pulseAnimation,
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return Positioned(
                        left: 65,
                        top: 105,
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withValues(alpha: 0.35),
                              border: Border.all(
                                color: Colors.red.shade700,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 55,
                    top: 40,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),

                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Intensidad',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.titleDark,
                            ),
                          ),
                          SizedBox(height: 5),
                          _LeyendaItem(color: Color(0xFFE0E0E0), label: 'Baja'),
                          SizedBox(height: 3),
                          _LeyendaItem(color: Colors.orange,    label: 'Media'),
                          SizedBox(height: 3),
                          _LeyendaItem(color: Colors.red,       label: 'Alta'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),


          Text(
            'RESULTADOS CLAVE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.bodyText,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),

          _ResultadoCard(
            iconBg: AppColors.primarySoftBg,
            icon: Icons.location_on_outlined,
            iconColor: AppColors.primaryColor,
            etiqueta: 'Zona con mayor demanda',
            titulo: 'Jinotepe',
            subtitulo: '↗  32 búsquedas',
            subtituloColor: AppColors.primaryColor,
          ),
          const SizedBox(height: 10),

          _ResultadoCard(
            iconBg: AppColors.amberSoft,
            icon: Icons.star_outline_rounded,
            iconColor: AppColors.amber,
            etiqueta: 'Producto más consultado',
            titulo: _productoSeleccionado ?? 'Tomate',
            subtitulo: 'Variedad Roma lidera consultas',
            subtituloColor: AppColors.bodyText,
          ),
          const SizedBox(height: 24),

          PrimaryButton(
            label: 'Publicar Oferta para Jinotepe',
            icon: Icons.add_circle_outline,
            radius: 25,
            onPressed: _publicarOferta,
          ),
        ],
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: _navItems,
        currentIndex: _tabActual,
        onTap: _cambiarTab,
      ),
    );
  }

  void _mostrarOpciones(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.file_download_outlined, color: AppColors.primaryColor),
                title: const Text('Exportar reporte (PDF)', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reporte exportado')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: AppColors.primaryColor),
                title: const Text('Compartir mapa', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: AppColors.primaryColor),
                title: const Text('Configuración avanzada', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _FiltroDropdown<T> extends StatelessWidget {
  final IconData prefixIcon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  const _FiltroDropdown({
    required this.prefixIcon,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.White,
        border: Border.all(color: AppColors.inputBorderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: AppColors.bodyText, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.bodyText,
                ),
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.titleDark,
                ),
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabel(item)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultadoCard extends StatelessWidget {
  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String etiqueta;
  final String titulo;
  final String subtitulo;
  final Color subtituloColor;

  const _ResultadoCard({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.etiqueta,
    required this.titulo,
    required this.subtitulo,
    required this.subtituloColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 12,
                    color: subtituloColor,
                    fontWeight: FontWeight.w600,
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

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LeyendaItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black12, width: 0.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(fontSize: 11, color: AppColors.bodyText)),
      ],
    );
  }
}

class _MapaPainter extends CustomPainter {
  final Animation<double> pulso;

  const _MapaPainter({required this.pulso}) : super(repaint: pulso);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF6BAE94),
          const Color(0xFF4A8D78),
          const Color(0xFF3A7564),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);
    final siluetaPaint = Paint()
      ..color = const Color(0xFF5A9E85)
      ..style = PaintingStyle.fill;

    final siluetaPath = Path();
    
    siluetaPath.moveTo(w * 0.12, h * 0.30);
    siluetaPath.quadraticBezierTo(w * 0.08, h * 0.20, w * 0.20, h * 0.10);
    siluetaPath.quadraticBezierTo(w * 0.38, h * 0.05, w * 0.55, h * 0.08);
    siluetaPath.quadraticBezierTo(w * 0.72, h * 0.10, w * 0.80, h * 0.18);
    siluetaPath.quadraticBezierTo(w * 0.90, h * 0.28, w * 0.88, h * 0.45);
    siluetaPath.quadraticBezierTo(w * 0.85, h * 0.62, w * 0.75, h * 0.72);
    siluetaPath.quadraticBezierTo(w * 0.62, h * 0.82, w * 0.48, h * 0.80);
    siluetaPath.quadraticBezierTo(w * 0.35, h * 0.88, w * 0.25, h * 0.82);
    siluetaPath.quadraticBezierTo(w * 0.10, h * 0.72, w * 0.08, h * 0.58);
    siluetaPath.quadraticBezierTo(w * 0.05, h * 0.45, w * 0.12, h * 0.30);
    siluetaPath.close();
    canvas.drawPath(siluetaPath, siluetaPaint);


    final contornoPaint = Paint()
      ..color = const Color(0xFF3A7060).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(siluetaPath, contornoPaint);


    _drawHeatBlob(
      canvas: canvas,
      center: Offset(w * 0.24, h * 0.56),
      radius: w * 0.24,
      innerColor: Colors.red.withValues(alpha: 0.75),
      outerColor: Colors.orange.withValues(alpha: 0.0),
    );

    _drawHeatBlob(
      canvas: canvas,
      center: Offset(w * 0.38, h * 0.42),
      radius: w * 0.18,
      innerColor: Colors.orange.withValues(alpha: 0.55),
      outerColor: Colors.orange.withValues(alpha: 0.0),
    );

    final dotPaint = Paint()
      ..color = Colors.red.shade700
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.24, h * 0.56), 7, dotPaint);
    final dotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset(w * 0.24, h * 0.56), 7, dotBorder);

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 0.8;
    for (int i = 1; i < 6; i++) {
      canvas.drawLine(
          Offset(w * i / 6, 0), Offset(w * i / 6, h), gridPaint);
    }
    for (int i = 1; i < 5; i++) {
      canvas.drawLine(
          Offset(0, h * i / 5), Offset(w, h * i / 5), gridPaint);
    }
  }

  void _drawHeatBlob({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color innerColor,
    required Color outerColor,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [innerColor, outerColor],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_MapaPainter old) => false;
}
