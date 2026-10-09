import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import '../../ui/app_theme.dart';
import 'inicioComprador.dart';
import '../../services/consumer_api_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class SeguimientoPedidoScreen extends StatefulWidget {
  final String? idPedido;
  const SeguimientoPedidoScreen({super.key, this.idPedido});

  @override
  State<SeguimientoPedidoScreen> createState() => _SeguimientoPedidoScreenState();
}

class _SeguimientoPedidoScreenState extends State<SeguimientoPedidoScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _pedidoData = {};
  mapbox.MapboxMap? mapboxMap;

  static const List<_PasoEnvio> _pasosBase = [
    _PasoEnvio(label: 'Confirmado', descripcion: 'El vendedor ha aceptado el pedido.', estado: _EstadoPaso.pendiente),
    _PasoEnvio(label: 'En preparación', descripcion: 'Tus productos están siendo cosechados y empacados.', estado: _EstadoPaso.pendiente),
    _PasoEnvio(label: 'Listo para entregar', descripcion: null, estado: _EstadoPaso.pendiente),
    _PasoEnvio(label: 'En camino', descripcion: null, estado: _EstadoPaso.pendiente),
    _PasoEnvio(label: 'Entregado', descripcion: null, estado: _EstadoPaso.pendiente),
  ];

  List<_PasoEnvio> _pasosActualizados = List.from(_pasosBase);
  String _estadoActual = 'PENDIENTE';
  String _idPedidoVisible = 'AT-0000';

  @override
  void initState() {
    super.initState();
    _cargarPedido();
  }

  void _onMapCreated(mapbox.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Set camera to center on the route
    mapboxMap.setCamera(mapbox.CameraOptions(
      center: mapbox.Point(coordinates: mapbox.Position(-86.2188, 11.8540)),
      zoom: 11.5,
    ));

    // Coordenadas simuladas
    final double productorLat = 11.8580;
    final double productorLng = -86.2386;
    final double repartidorLat = 11.8540;
    final double repartidorLng = -86.2188;
    final double clienteLat = 11.8499;
    final double clienteLng = -86.1990;

    // Draw Route Polyline
    mapboxMap.annotations.createPolylineAnnotationManager().then((polylineAnnotationManager) async {
      final polylineOptions = <mapbox.PolylineAnnotationOptions>[
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: [
            mapbox.Position(productorLng, productorLat),
            mapbox.Position(repartidorLng, repartidorLat),
            mapbox.Position(clienteLng, clienteLat)
          ]),
          lineColor: 0xFF3B82F6,
          lineWidth: 4.0,
          lineJoin: mapbox.LineJoin.ROUND,
        )
      ];
      polylineAnnotationManager.createMulti(polylineOptions);
    });

    // Draw Pins
    mapboxMap.annotations.createPointAnnotationManager().then((pointAnnotationManager) async {
      final options = <mapbox.PointAnnotationOptions>[
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(productorLng, productorLat)),
          iconSize: 1.5,
        ),
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(clienteLng, clienteLat)),
          iconSize: 1.5,
        ),
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(repartidorLng, repartidorLat)),
          iconSize: 1.5,
        )
      ];
      pointAnnotationManager.createMulti(options);
    });
  }

  Future<void> _cargarPedido() async {
    try {
      String id = widget.idPedido ?? '';
      if (id.isEmpty) {
        final misPedidos = await ConsumerApiService.instance.getMisPedidos();
        if (misPedidos.isNotEmpty) {
          id = misPedidos.first.id;
        }
      }

      if (id.isNotEmpty) {
        _idPedidoVisible = id;
        final data = await ConsumerApiService.instance.getPedidoDetalle(id);
        if (data.isNotEmpty) {
          _pedidoData = data;
          _estadoActual = data['estadoEnvio'] ?? 'PENDIENTE';
          _actualizarPasos(_estadoActual);
        }
      }
    } catch (e) {
      print('Error cargando seguimiento: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _actualizarPasos(String estadoEnvio) {
    int currentIndex = 0;
    switch (estadoEnvio.toUpperCase()) {
      case 'PENDIENTE': currentIndex = 1; break;
      case 'PREPARANDO': currentIndex = 1; break;   // En preparación
      case 'LISTO': currentIndex = 2; break;        // Listo para entregar
      case 'EN_CAMINO': currentIndex = 3; break;
      case 'ENTREGADO': currentIndex = 4; break;
      case 'CANCELADO':
      case 'RECHAZADO': currentIndex = 0; break;
      default: currentIndex = 1;
    }

    _pasosActualizados = _pasosBase.asMap().entries.map((entry) {
      final index = entry.key;
      final paso = entry.value;
      
      _EstadoPaso nuevoEstado;
      if (index < currentIndex) {
        nuevoEstado = _EstadoPaso.completado;
      } else if (index == currentIndex) {
        nuevoEstado = _EstadoPaso.activo;
      } else {
        nuevoEstado = _EstadoPaso.pendiente;
      }

      return _PasoEnvio(label: paso.label, descripcion: paso.descripcion, estado: nuevoEstado);
    }).toList();
  }

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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
        : SingleChildScrollView(
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
                Text(
                  'Pedido #$_idPedidoVisible',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    text: 'Estado actual: ',
                    style: const TextStyle(fontSize: 14, color: AppColors.TextSoft),
                    children: [
                      TextSpan(
                        text: '\n$_estadoActual',
                        style: const TextStyle(
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
      children: List.generate(_pasosActualizados.length, (i) {
        final paso = _pasosActualizados[i];
        final isLast = i == _pasosActualizados.length - 1;
        return _PasoTile(paso: paso, isLast: isLast);
      }),
    );
  }

  Widget _buildProductores() {
    if (_pedidoData.isEmpty || _pedidoData['detalles'] == null) {
      return Column(
        children: const [
          _ProductorTile(
            nombre: 'Productor Local',
            estado: 'Preparando tu pedido',
            estadoColor: AppColors.primaryColor,
            icon: Icons.agriculture_outlined,
            estadoIcon: Icons.check_circle_rounded,
          ),
        ],
      );
    }

    final detalles = _pedidoData['detalles'] as List<dynamic>;
    return Column(
      children: detalles.map((d) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _ProductorTile(
            nombre: d['producto'] ?? 'Producto',
            estado: 'x${d['cantidad']} - C\$${d['totalLinea']}',
            estadoColor: AppColors.TextSoft,
            icon: Icons.inventory_2_outlined,
            estadoIcon: Icons.shopping_basket_outlined,
          ),
        );
      }).toList(),
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
        (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS))
            ? _buildDemoMap(context)
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  color: const Color(0xFFD1FAE5),
                  child: mapbox.MapWidget(
                    onMapCreated: _onMapCreated,
                    styleUri: mapbox.MapboxStyles.MAPBOX_STREETS,
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
            onPressed: () => Navigator.pushNamed(
              context, 
              '/chat',
              arguments: {
                'idPedido': int.tryParse(_idPedidoVisible.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
                'idReceptor': 13, // Productor por defecto / mock
                'nombreReceptor': 'Productor',
                'codigoPedido': '#$_idPedidoVisible',
              },
            ),
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

  Widget _buildDemoMap(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _MockMapPainter(),
            ),
            
            Positioned(
              left: 24,
              bottom: 20,
              child: _buildMapPin(Icons.storefront_rounded, AppColors.primaryColor),
            ),
            
            Positioned(
              right: 24,
              top: 20,
              child: _buildMapPin(Icons.home_rounded, const Color(0xFFEF4444)),
            ),
            
            Positioned(
              left: MediaQuery.of(context).size.width * 0.45,
              top: 45,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.electric_moped_rounded,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ),
            ),
            
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'En vivo',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin(IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ],
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

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final secondaryStreetPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(-20, 40), Offset(size.width * 0.6, -10), streetPaint);
    canvas.drawLine(Offset(size.width * 0.3, size.height + 20), Offset(size.width * 0.8, 20), streetPaint);
    canvas.drawLine(Offset(10, size.height * 0.8), Offset(size.width * 0.9, size.height * 0.9), secondaryStreetPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.6, size.height), secondaryStreetPaint);

    final path = Path();
    final startX = 24.0 + 18.0;
    final startY = size.height - 20.0 - 18.0;
    
    final endX = size.width - 24.0 - 18.0;
    final endY = 20.0 + 18.0;

    path.moveTo(startX, startY);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.2, endX, endY);

    final bgRoutePaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.3)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
      
    _drawDashedLine(canvas, path, bgRoutePaint, 10, 8);

    final activeRoutePaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final metric = metrics.first;
      final activePath = metric.extractPath(0, metric.length * 0.6);
      canvas.drawPath(activePath, activeRoutePaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (var metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(distance, nextDistance);
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
