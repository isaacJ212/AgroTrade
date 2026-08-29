import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'inicioComprador.dart';

class SeguimientoPedidoScreen extends StatelessWidget {
  const SeguimientoPedidoScreen({super.key});

  static const List<_PasoEnvio> _pasos = [
    _PasoEnvio(
      label: 'Confirmado',
      descripcion: 'El vendedor ha aceptado el pedido.',
      estado: _EstadoPaso.completado,
    ),
    _PasoEnvio(
      label: 'En preparación',
      descripcion: 'Tus productos están siendo cosechados y empacados.',
      estado: _EstadoPaso.activo,
    ),
    _PasoEnvio(
      label: 'Listo para entregar',
      descripcion: null,
      estado: _EstadoPaso.pendiente,
    ),
    _PasoEnvio(
      label: 'En camino',
      descripcion: null,
      estado: _EstadoPaso.pendiente,
    ),
    _PasoEnvio(
      label: 'Entregado',
      descripcion: null,
      estado: _EstadoPaso.pendiente,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const InicioComprador()),
              );
            }
          },
        ),
        title: const Text(
          'Seguimiento',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCabecera(),
            const SizedBox(height: 20),

            _buildSeccion(
              titulo: 'Progreso del Envío',
              child: _buildTimeline(),
            ),
            const SizedBox(height: 16),

            _buildSeccion(
              titulo: 'Estado por Productor',
              child: _buildProductores(),
            ),
            const SizedBox(height: 16),

            _buildSeccion(titulo: 'Entrega', child: _buildEntrega(context)),
            const SizedBox(height: 16),

            _buildSeccion(
              titulo: '¿Necesitas ayuda?',
              child: _buildAyuda(context),
            ),
            const SizedBox(height: 16),

            _buildPagoProtegido(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecera() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pedido #AT-2051',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    text: 'Estado actual: ',
                    style: TextStyle(fontSize: 14, color: AppColors.TextSoft),
                    children: [
                      TextSpan(
                        text: 'En\npreparación',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.sync_rounded, size: 13, color: Color(0xFF3B82F6)),
                SizedBox(width: 5),
                Text(
                  'Actualizando',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: List.generate(_pasos.length, (i) {
        final paso = _pasos[i];
        final isLast = i == _pasos.length - 1;
        return _PasoTile(paso: paso, isLast: isLast);
      }),
    );
  }

  Widget _buildProductores() {
    return Column(
      children: const [
        _ProductorTile(
          nombre: 'Finca La Esperanza',
          estado: 'Preparando tu pedido',
          estadoColor: AppColors.primaryColor,
          icon: Icons.agriculture_outlined,
          estadoIcon: Icons.check_circle_rounded,
        ),
        SizedBox(height: 8),
        _ProductorTile(
          nombre: 'Cooperativa Los Andes',
          estado: 'Pedido confirmado',
          estadoColor: AppColors.TextSoft,
          icon: Icons.storefront_outlined,
          estadoIcon: Icons.inventory_2_outlined,
        ),
      ],
    );
  }

  Widget _buildEntrega(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(
              Icons.location_on_outlined,
              size: 16,
              color: AppColors.primaryColor,
            ),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dirección de Entrega',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.TextSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Jinotepe, Carazo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 130,
            color: const Color(0xFFD1FAE5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 130),
                  painter: _MapGridPainter(),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/comprador/pedido/ruta-mapa'),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text(
              'Ver ruta',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.titleDark,
              side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAyuda(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text(
              'Enviar mensaje',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/comprador/pedido/reportar'),
            icon: const Icon(Icons.warning_amber_rounded, size: 18),
            label: const Text(
              'Reportar un problema',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.titleDark,
              side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPagoProtegido() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pago protegido',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'El pago se gestionará de acuerdo con la confirmación de entrega.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primarySoft,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccion({required String titulo, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

enum _EstadoPaso { completado, activo, pendiente }

class _PasoEnvio {
  final String label;
  final String? descripcion;
  final _EstadoPaso estado;

  const _PasoEnvio({
    required this.label,
    required this.descripcion,
    required this.estado,
  });
}

class _PasoTile extends StatelessWidget {
  final _PasoEnvio paso;
  final bool isLast;

  const _PasoTile({required this.paso, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final bool done = paso.estado == _EstadoPaso.completado;
    final bool active = paso.estado == _EstadoPaso.activo;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [

            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? AppColors.primaryColor
                    : active
                    ? Colors.white
                    : AppColors.tileBg,
                border: active
                    ? Border.all(color: AppColors.primaryColor, width: 2)
                    : null,
              ),
              child: done
                  ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: Colors.white,
                    )
                  : active
                  ? const Icon(
                      Icons.radio_button_checked_rounded,
                      size: 16,
                      color: AppColors.primaryColor,
                    )
                  : const Icon(
                      Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: AppColors.chipGrey,
                    ),
            ),

            if (!isLast)
              Container(
                width: 2,
                height: paso.descripcion != null ? 48 : 32,
                color: done ? AppColors.primaryColor : AppColors.cardBorder,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paso.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active || done
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: active || done
                        ? AppColors.titleDark
                        : AppColors.chipGrey,
                  ),
                ),
                if (paso.descripcion != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    paso.descripcion!,
                    style: TextStyle(
                      fontSize: 12,
                      color: active ? AppColors.TextSoft : AppColors.chipGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductorTile extends StatelessWidget {
  final String nombre;
  final String estado;
  final Color estadoColor;
  final IconData icon;
  final IconData estadoIcon;

  const _ProductorTile({
    required this.nombre,
    required this.estado,
    required this.estadoColor,
    required this.icon,
    required this.estadoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(estadoIcon, size: 13, color: estadoColor),
                    const SizedBox(width: 4),
                    Text(
                      estado,
                      style: TextStyle(
                        fontSize: 12,
                        color: estadoColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA7F3D0).withOpacity(0.6)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final streetPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      streetPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.45, 0),
      Offset(size.width * 0.45, size.height),
      streetPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
