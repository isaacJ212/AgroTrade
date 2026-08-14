import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';
import '../models/entrega.dart'; // ajusta si tu modelo vive en otro archivo

class InicioRepartidor extends StatefulWidget {
  const InicioRepartidor({super.key});

  @override
  State<InicioRepartidor> createState() => _InicioRepartidorState();
}

class _InicioRepartidorState extends State<InicioRepartidor> {
  int _tabActual = 0;

  // Simula el JSON del backend .NET
  static const List<Map<String, dynamic>> _respuestaBackend = [
    {
      'pedidoId': 4829,
      'zonaEntrega': 'El Rosario Carazo',
      'totalPedido': 1250.50,
      'fechaCreacion': '2026-08-13T14:30:00Z',
    },
    {
      'pedidoId': 4830,
      'zonaEntrega': 'Jinotepe',
      'totalPedido': 890.00,
      'fechaCreacion': '2026-08-13T15:10:00Z',
    },
  ];

  // JSON → modelos (el badge y el stat de pendientes usan esto)
  final List<NotificacionEntrega> _pendientes = _respuestaBackend
      .map((json) => NotificacionEntrega.fromJson(json))
      .toList();

  String get _saludo {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  void _mostrarSnack(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color ?? AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cambiarTab(int index) {
    setState(() => _tabActual = index);
    if (index != 0) _mostrarSnack('Esta sección estará disponible pronto 🚚');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(84),
        child: AppBar(
          backgroundColor: AppColors.primarySoftBg,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: 72,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primarySoftBg,
              child: Icon(Icons.person, color: AppColors.primaryColor),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¡$_saludo, José!',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                'Revisa tus entregas de hoy',
                style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => _mostrarSnack(
                      '${_pendientes.length} entregas pendientes 🔔',
                    ),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.accentBlue,
                    ),
                  ),
                  if (_pendientes.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.inputErrorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const SizedBox(height: 8),
            const SizedBox(height: 24),

            Text('Entregas de hoy', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            _statsHoy(),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Próxima entrega', style: AppTextStyles.sectionTitle),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoftBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'En curso',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _tarjetaProximaEntrega(),
            const SizedBox(height: 24),

            Text('Ruta del día', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            _tarjetaRuta(),
          ],
        ),
      ),
      bottomNavigationBar: RepartidorBottomNav(
        currentIndex: _tabActual,
        onTap: _cambiarTab,
      ),
    );
  }

  /// Grid 2x2: Pendientes + En curso / Completadas + celda vacía
  Widget _statsHoy() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatEntregas(
                titulo: 'Pendientes',
                valor: '${_pendientes.length}', // ← vive desde el modelo
                icono: Icons.pending_actions,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: _StatEntregas(
                titulo: 'En curso',
                valor: '1',
                icono: Icons.local_shipping,
                destacado: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              child: _StatEntregas(
                titulo: 'Completadas',
                valor: '2',
                icono: Icons.check_circle_outline,
              ),
            ),
            const SizedBox(width: 12),
            // Truco: celda vacía del mismo ancho para mantener la mitad
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  /// Tarjeta grande: mapa mock + detalles + acciones
  Widget _tarjetaProximaEntrega() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          // ---- Mapa MOCK (en mes 2: google_maps) ----
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.route,
                    size: 48,
                    color: AppColors.primaryGlow,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _marcadorMapa(
                    'Inicio del Repartidor',
                    Icons.person_pin,
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: _marcadorMapa('Finca La Esperanza', Icons.store),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Finca La Esperanza', style: AppTextStyles.cardTitle),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.bodyText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Destino, Jinotepe',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 14),

                // Contenido / Recogida en dos columnas
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contenido',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '3 productos',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recogida',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '9:30 a. m.',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Chip de estado + botón
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.inputErrorColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Pendiente de recogida',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.inputErrorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () => _mostrarSnack('Abriendo entrega...'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.White,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Ver entrega',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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

  /// Marcador flotante sobre el mapa mock
  Widget _marcadorMapa(String texto, IconData icono) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.titleDark,
            ),
          ),
        ],
      ),
    );
  }

  /// Tarjeta verde de resumen de ruta
  Widget _tarjetaRuta() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.route,
                  color: AppColors.White,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen',
                      style: AppTextStyles.label.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '3 paradas pendientes',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _mostrarSnack('Mostrando ruta del día 🗺️'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
                side: const BorderSide(color: AppColors.accentBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ver ruta',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta pequeña de estadística (icono + número + label)
class _StatEntregas extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;
  final bool destacado;

  const _StatEntregas({
    required this.titulo,
    required this.valor,
    required this.icono,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: destacado ? AppColors.primaryColor : AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: destacado ? AppColors.primaryColor : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: destacado
                      ? AppColors.White.withOpacity(0.15)
                      : AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icono,
                  size: 18,
                  color: destacado ? AppColors.White : AppColors.primaryColor,
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: destacado ? AppColors.White : AppColors.titleDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            titulo,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 13,
              color: destacado
                  ? AppColors.White.withOpacity(0.85)
                  : AppColors.bodyText,
            ),
          ),
        ],
      ),
    );
  }
}
