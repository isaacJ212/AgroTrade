import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import '../../config/env.dart';
import '../../ui/app_theme.dart';
import 'repartidor_widgets.dart';

class MapaRutaRepartidor extends StatefulWidget {
  final String? zonaRecogida;
  final String? zonaDestino;
  final String? estado; // 'pendiente', 'en_curso', 'completada'
  final bool recogido;

  const MapaRutaRepartidor({
    super.key,
    this.zonaRecogida,
    this.zonaDestino,
    this.estado = 'pendiente',
    this.recogido = false,
  });

  @override
  State<MapaRutaRepartidor> createState() => _MapaRutaRepartidorState();
}

class _MapaRutaRepartidorState extends State<MapaRutaRepartidor> {
  mapbox.MapboxMap? mapboxMap;

  _onMapCreated(mapbox.MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;

    // Coordenadas mock para la ruta
    double latRecogida = 11.8499;
    double lngRecogida = -86.1990;
    
    double latDestino = 11.8580;
    double lngDestino = -86.2386;

    mapboxMap.setCamera(mapbox.CameraOptions(
      center: mapbox.Point(coordinates: mapbox.Position(lngRecogida, latRecogida)),
      zoom: 12.0,
    ));

    _agregarMarcadores(lngRecogida, latRecogida, lngDestino, latDestino);
  }

  void _agregarMarcadores(double lngR, double latR, double lngD, double latD) async {
    // 1. Dibujar la ruta (línea) conectando los puntos
    mapboxMap?.annotations.createPolylineAnnotationManager().then((polylineAnnotationManager) async {
      final polylineOptions = <mapbox.PolylineAnnotationOptions>[
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: [
            mapbox.Position(lngR, latR),
            if (widget.estado == 'en_curso')
              mapbox.Position(lngR + (lngD - lngR)/2, latR + (latD - latR)/2),
            mapbox.Position(lngD, latD)
          ]),
          lineColor: Colors.blue.value,
          lineWidth: 5.0,
          lineJoin: mapbox.LineJoin.ROUND,
        )
      ];
      await polylineAnnotationManager.createMulti(polylineOptions);
    });

    // 2. Agregar los marcadores de puntos
    mapboxMap?.annotations.createPointAnnotationManager().then((pointAnnotationManager) async {
      final options = <mapbox.PointAnnotationOptions>[
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(lngR, latR)),
          textField: 'Recogida: ${widget.zonaRecogida ?? "Tienda"}',
          iconImage: 'marker-15',
        ),
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(lngD, latD)),
          textField: 'Destino: ${widget.zonaDestino ?? "Cliente"}',
          iconImage: 'marker-15',
        )
      ];

      if (widget.estado == 'en_curso') {
        options.add(mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: mapbox.Position(lngR + (lngD - lngR)/2, latR + (latD - latR)/2)),
          textField: widget.recogido ? 'En camino' : 'Por recoger',
          iconImage: 'marker-15',
        ));
      }
      await pointAnnotationManager.createMulti(options);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ruta de ${widget.zonaRecogida ?? 'recogida'} a ${widget.zonaDestino ?? 'destino'}. Mapa navegable con gestos.',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: (kIsWeb || Platform.isAndroid || Platform.isIOS)
              ? mapbox.MapWidget(
                  key: const ValueKey("mapWidgetRepartidor"),
                  styleUri: mapbox.MapboxStyles.MAPBOX_STREETS,
                  onMapCreated: _onMapCreated,
                )
              : Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Mapbox no está disponible en esta plataforma (Linux/Windows/macOS). Por favor usa un emulador de Android/iOS o Chrome web.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
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
