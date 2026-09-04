import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../screens/repartidor/repartidor_demo.dart';
import 'repartidor_widgets.dart';

class MapaRutaRepartidor extends StatelessWidget {
  final EntregaDemo entrega;

  const MapaRutaRepartidor({super.key, required this.entrega});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ruta de ${entrega.finca} a ${entrega.destino}.',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final puntos = _PuntosRuta(constraints.biggest);
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _RecorridoRepartidorPainter()),
              _marcador(
                puntos.recogida,
                icono: Icons.storefront,
                etiqueta: 'Recogida',
                detalle: entrega.finca,
                color: AppColors.TextSoft,
              ),
              if (entrega.estado == EstadoEntregaDemo.enCurso)
                _marcador(
                  puntos.enCamino,
                  icono: Icons.delivery_dining,
                  etiqueta: entrega.recogido ? 'En camino' : 'Por recoger',
                  detalle: entrega.estadoTexto,
                  color: AppColors.primaryColor,
                ),
              _marcador(
                puntos.destino,
                icono: Icons.home,
                etiqueta: entrega.estado == EstadoEntregaDemo.completada
                    ? 'Entregado'
                    : 'Cliente',
                detalle: '${entrega.cliente} · ${entrega.destino}',
                color: AppColors.accentBlue,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _marcador(
    Offset punto, {
    required IconData icono,
    required String etiqueta,
    required String detalle,
    required Color color,
  }) {
    return Positioned(
      left: punto.dx - 48,
      top: punto.dy - 22,
      width: 96,
      child: Tooltip(
        message: detalle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.White, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: Icon(icono, color: AppColors.White, size: 24),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Text(
                etiqueta,
                textAlign: TextAlign.center,
                style: RepartidorTextStyles.chip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VistaPreviaRutaRepartidor extends StatelessWidget {
  final VoidCallback onTap;

  const VistaPreviaRutaRepartidor({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Ver ruta de entrega',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: const Color(0xFFD1FAE5),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(painter: _CuadriculaRepartidorPainter()),
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.White,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PuntosRuta {
  final Size size;

  const _PuntosRuta(this.size);

  Offset get recogida => Offset(size.width * 0.24, size.height * 0.20);
  Offset get enCamino => Offset(size.width * 0.67, size.height * 0.47);
  Offset get destino => Offset(size.width * 0.42, size.height * 0.77);
}

class _RecorridoRepartidorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE0E0E0),
    );
    final puntos = _PuntosRuta(size);
    final recorrido = Paint()
      ..color = AppColors.White
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final ruta = Path()
      ..moveTo(puntos.recogida.dx, puntos.recogida.dy)
      ..lineTo(puntos.enCamino.dx, puntos.enCamino.dy)
      ..lineTo(puntos.destino.dx, puntos.destino.dy);
    canvas.drawPath(ruta, recorrido);

    final calle = Paint()
      ..color = Colors.white54
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.83, size.height * 0.08),
      Offset(size.width * 0.93, size.height * 0.69),
      calle,
    );
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.60),
      Offset(size.width * 0.22, size.height * 0.97),
      calle,
    );
  }

  @override
  bool shouldRepaint(covariant _RecorridoRepartidorPainter oldDelegate) =>
      false;
}

class _CuadriculaRepartidorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cuadricula = Paint()
      ..color = const Color(0xFFB9F1D9)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), cuadricula);
    }
    for (double y = 0; y <= size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), cuadricula);
    }
    final calle = Paint()
      ..color = Colors.white70
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(size.width * 0.45, 0),
      Offset(size.width * 0.45, size.height),
      calle,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      calle,
    );
  }

  @override
  bool shouldRepaint(covariant _CuadriculaRepartidorPainter oldDelegate) =>
      false;
}
