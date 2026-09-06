import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';

import '../../services/consumer_api_service.dart';

class RutaSeguimientoClienteScreen extends StatefulWidget {
  const RutaSeguimientoClienteScreen({super.key});

  @override
  State<RutaSeguimientoClienteScreen> createState() => _RutaSeguimientoClienteScreenState();
}

class _RutaSeguimientoClienteScreenState extends State<RutaSeguimientoClienteScreen> {
  double _repartidorLat = 0.5;
  double _repartidorLng = 0.6;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUbicacion();
  }

  Future<void> _cargarUbicacion() async {
    // ID simulado para el pedido actual
    final idPedidoSimulado = 1045;
    final ubi = await ConsumerApiService.instance.getUbicacionRepartidor(idPedidoSimulado);
    
    if (mounted && ubi.isNotEmpty) {
      setState(() {
        _repartidorLat = ubi['lat'] ?? 0.5;
        _repartidorLng = ubi['lng'] ?? 0.6;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Mapa simulado (fondo)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFE0E0E0),
              child: CustomPaint(
                painter: _MapGridPainter(),
              ),
            ),
          ),
          
          // AppBar transparente
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Puntos del mapa (Productor y Cliente)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.2,
            child: const _MapPin(icon: Icons.storefront, label: 'Productor', color: AppColors.TextSoft),
          ),
          
          if (_cargando)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: const CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            )
          else
            Positioned(
              top: MediaQuery.of(context).size.height * _repartidorLat,
              left: MediaQuery.of(context).size.width * _repartidorLng,
              child: const _MapPin(icon: Icons.delivery_dining, label: 'En camino', color: AppColors.primaryColor),
            ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.7,
            left: MediaQuery.of(context).size.width * 0.4,
            child: const _MapPin(icon: Icons.home, label: 'Tu casa', color: AppColors.accentBlue),
          ),

          // Bottom Sheet informativo
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tiempo estimado', style: TextStyle(color: AppColors.TextSoft)),
                      Text('15 - 20 min', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.titleDark)),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Carlos M.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Repartidor', style: TextStyle(color: AppColors.TextSoft, fontSize: 13)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: AppColors.primaryColor),
                        onPressed: () {},
                        style: IconButton.styleFrom(backgroundColor: AppColors.primarySoftBg),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble, color: AppColors.primaryColor),
                        onPressed: () => Navigator.pushNamed(
                          context, 
                          '/chat',
                          arguments: {
                            'idPedido': 1, // Reemplazar con ID real si se tiene
                            'idReceptor': 14, // Repartidor mock
                            'nombreReceptor': 'Repartidor',
                            'codigoPedido': '#PED-000',
                          },
                        ),
                        style: IconButton.styleFrom(backgroundColor: AppColors.primarySoftBg),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MapPin({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
      
    canvas.drawLine(Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.6, size.height * 0.5), paint);
    canvas.drawLine(Offset(size.width * 0.6, size.height * 0.5), Offset(size.width * 0.4, size.height * 0.7), paint);
    
    // Rutas alternativas
    paint.color = Colors.white54;
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(size.width * 0.8, size.height * 0.2), Offset(size.width * 0.9, size.height * 0.6), paint);
    canvas.drawLine(Offset(size.width * 0.1, size.height * 0.6), Offset(size.width * 0.3, size.height * 0.9), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
