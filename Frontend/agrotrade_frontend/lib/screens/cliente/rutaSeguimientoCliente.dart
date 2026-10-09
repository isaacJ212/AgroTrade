import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import '../../ui/app_theme.dart';

import '../../services/consumer_api_service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

class RutaSeguimientoClienteScreen extends StatefulWidget {
  const RutaSeguimientoClienteScreen({super.key});

  @override
  State<RutaSeguimientoClienteScreen> createState() => _RutaSeguimientoClienteScreenState();
}

class _RutaSeguimientoClienteScreenState extends State<RutaSeguimientoClienteScreen> {
  double _repartidorLat = 11.8499;
  double _repartidorLng = -86.1990;
  bool _cargando = true;

  // Coordenadas simuladas de la ruta
  final double _productorLat = 11.8580;
  final double _productorLng = -86.2386;
  final double _clienteLat = 11.8499;
  final double _clienteLng = -86.1990;

  mapbox.MapboxMap? mapboxMap;

  @override
  void initState() {
    super.initState();
    _cargarUbicacion();
  }

  _onMapCreated(mapbox.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    // Set camera to center on the route
    mapboxMap.setCamera(mapbox.CameraOptions(
      center: mapbox.Point(coordinates: mapbox.Position(-86.2188, 11.8540)),
      zoom: 12.0,
    ));

    // Draw Route Polyline
    mapboxMap.annotations.createPolylineAnnotationManager().then((polylineAnnotationManager) async {
      final polylineOptions = <mapbox.PolylineAnnotationOptions>[
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: [
            mapbox.Position(_productorLng, _productorLat),
            mapbox.Position(_repartidorLng, _repartidorLat), // Posición intermedia simulada
            mapbox.Position(_clienteLng, _clienteLat)
          ]),
          lineColor: 0xFF3B82F6, // primaryColor
          lineWidth: 5.0,
          lineJoin: mapbox.LineJoin.ROUND,
        )
      ];
      polylineAnnotationManager.createMulti(polylineOptions);
    });

    // Draw Pins
    mapboxMap.annotations.createPointAnnotationManager().then((pointAnnotationManager) async {
      final options = <mapbox.PointAnnotationOptions>[
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(_productorLng, _productorLat)),
          // Se puede añadir image si tienen el asset, pero para rápido se dibuja nativamente o usa un icono
          iconSize: 1.5,
        ),
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(_clienteLng, _clienteLat)),
          iconSize: 1.5,
        ),
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(_repartidorLng, _repartidorLat)),
          iconSize: 1.5,
        )
      ];
      // Si no tienen las imagenes cargadas, el mapa mostrará las opciones de fallback o nada.
      // Así que mantendremos los widgets posicionados de Flutter encima del mapa.
    });
  }

  Future<void> _cargarUbicacion() async {
    // ID simulado para el pedido actual
    final idPedidoSimulado = 1045;
    final ubi = await ConsumerApiService.instance.getUbicacionRepartidor(idPedidoSimulado);
    
    if (mounted && ubi.isNotEmpty) {
      setState(() {
        _repartidorLat = ubi['lat'] ?? 11.8540;
        _repartidorLng = ubi['lng'] ?? -86.2188;
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
          // Mapa Mapbox (con protección de plataforma para Desktop)
          Positioned.fill(
            child: (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS))
                ? Container(
                    color: const Color(0xFFE2E8F0),
                    child: const Center(
                      child: Text(
                        'Mapbox no es compatible con Linux Desktop.\nPor favor, ejecuta en Android/iOS o Web para ver el mapa real.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : mapbox.MapWidget(
                    onMapCreated: _onMapCreated,
                    styleUri: mapbox.MapboxStyles.MAPBOX_STREETS,
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

          // Puntos del mapa (Productor y Cliente - Superpuestos encima del mapa para que se vean geniales)
          Align(
            alignment: const Alignment(-0.6, -0.4),
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
            Align(
              alignment: const Alignment(0.0, -0.1),
              child: const _MapPin(icon: Icons.delivery_dining, label: 'En camino', color: AppColors.primaryColor),
            ),

          Align(
            alignment: const Alignment(0.6, 0.2),
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

