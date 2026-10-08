import 'package:agrotrade_frontend/screens/repartidor/perfilRepartidor.dart';
import 'package:agrotrade_frontend/screens/repartidor/verificacionRepartidorModal.dart';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import 'detalleEntregaRepartidor.dart';
import 'entregasRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import '../../services/delivery_api_service.dart';
import '../../services/repartidor_api_service.dart';
import '../../services/api_session.dart';
import 'package:agrotrade_frontend/models/api/delivery_models.dart';

class InicioRepartidor extends StatefulWidget {
  const InicioRepartidor({super.key});

  @override
  State<InicioRepartidor> createState() => _InicioRepartidorState();
}

class _InicioRepartidorState extends State<InicioRepartidor> {
  // URLs reales vendrán de la API, no mocks

  final String _avatarUrl =
      'https://frxxlbxlglvbgcvigpxa.supabase.co/storage/v1/object/public/imagenes_meseta_verde/fcb7e0aa-0241-42ef-be2d-734f53dd652a.jpg';

  late final Future<List<PendingDeliveryNotificationDto>> _pendingFuture;

  @override
  void initState() {
    super.initState();
    _pendingFuture = DeliveryApiService.instance
        .getPendingDeliveries()
        .catchError((_) => <PendingDeliveryNotificationDto>[]);
    // _verificarEstadoRepartidor(); // TEMPORAL: omitido para testear flujo
  }

  // Future<void> _verificarEstadoRepartidor() async {
  //   try {
  //     final estado = await RepartidorApiService.instance.getEstadoVerificacion();
  //     if (mounted && !estado.estaVerificado) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (mounted) {
  //           VerificacionRepartidorModal.show(
  //             context: context,
  //             estado: estado,
  //             onCorregirReenviar: () => Navigator.pushNamed(context, AppRoutes.formularioSolicitudRepartidor),
  //             onIrAOnboarding: () => Navigator.pushNamed(context, AppRoutes.onboardingRepartidor),
  //           );
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Error verificando estado repartidor: $e');
  //   }
  // }

  String get _saludo {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PendingDeliveryNotificationDto>>(
      future: _pendingFuture,
      builder: (context, snapshot) {
        final pendingDeliveries =
            snapshot.data ?? const <PendingDeliveryNotificationDto>[];
        final nextDelivery = pendingDeliveries.isNotEmpty
            ? pendingDeliveries.first
            : null;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          floatingActionButton: SupportFab(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.agrobotWelcome),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Container(
                  color: AppColors.surfaceAlt,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const CircleAvatar(
                              backgroundColor: AppColors.primarySoftBg,
                              child: Icon(
                                Icons.person,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$_saludo, ${ApiSession.instance.userName ?? ''}',
                              style: AppTextStyles.label.copyWith(
                                fontSize: 16,
                                color: AppColors.primarySoft,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Revisá tus entregas de hoy',
                              style: AppTextStyles.SubTitle.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () => _showSnack(
                              context,
                              '${pendingDeliveries.length} entregas pendientes',
                            ),
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: AppColors.bodyText,
                            ),
                          ),
                          if (pendingDeliveries.isNotEmpty)
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.inputErrorColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      Text(
                        'Entregas de hoy',
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: 12),
                      _StatsGrid(
                        pendingCount: pendingDeliveries.length,
                        enCursoCount: 0,
                        completadasCount: 0,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Próxima entrega',
                            style: AppTextStyles.sectionTitle,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBorder,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              nextDelivery == null
                                  ? 'Sin entregas'
                                  : '#AT-${nextDelivery.pedidoId}',
                              style: AppTextStyles.chip.copyWith(
                                color: AppColors.chipGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      nextDelivery != null
                          ? _NextDeliveryCard(
                              delivery: nextDelivery,
                              onVerEntrega: () => _navigate(
                                context,
                                DetalleEntregaRepartidor(
                                  pedidoId: nextDelivery.pedidoId,
                                  zonaEntrega: nextDelivery.zonaEntrega,
                                  totalPedido: nextDelivery.totalPedido,
                                ),
                              ),
                            )
                          : _EmptyDeliveryCard(),
                      const SizedBox(height: 24),
                      Text('Ruta del día', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 12),
                      _RouteSummaryCard(
                        onVerRuta: () =>
                            _navigate(context, const RutaEntregaRepartidor()),
                        paradasCount: pendingDeliveries.length,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: RepartidorBottomNav(
            currentIndex: 0,
            onTap: (index) {
              if (index == 0) return;
              if (index == 1) {
                _navigate(context, const Entregasrepartidor());
                return;
              }
              if (index == 2) {
                _navigate(context, const RutaEntregaRepartidor());
                return;
              }
              if (index == 3) {
                _navigate(context, const PerfilRepartidor());
              }
            },
          ),
        );
      },
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final int pendingCount;
  final int enCursoCount;
  final int completadasCount;

  const _StatsGrid({
    required this.pendingCount,
    required this.enCursoCount,
    required this.completadasCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Pendientes',
                value: '$pendingCount',
                icon: Icons.pending_actions,
                background: const Color(0xFFE7E8E9),
                iconColor: AppColors.bodyText,
                valueColor: AppColors.primarySoft,
                titleColor: AppColors.bodyText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'En curso',
                value: '$enCursoCount',
                icon: Icons.local_shipping,
                background: AppColors.primaryColor,
                iconColor: AppColors.fabIcon,
                valueColor: AppColors.fabIcon,
                titleColor: AppColors.fabIcon,
                elevated: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Completadas',
                value: '$completadasCount',
                icon: Icons.check_circle_outline,
                background: Color(0xFFE7E8E9),
                iconColor: AppColors.bodyText,
                valueColor: AppColors.primarySoft,
                titleColor: AppColors.bodyText,
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final Color valueColor;
  final Color titleColor;
  final bool elevated;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.valueColor,
    required this.titleColor,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevated
            ? const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 22),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  height: 1,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextDeliveryCard extends StatelessWidget {
  final PendingDeliveryNotificationDto delivery;
  final VoidCallback onVerEntrega;

  const _NextDeliveryCard({required this.delivery, required this.onVerEntrega});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con info de la entrega (sin mock map)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entrega #AT-${delivery.pedidoId}',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Destino: ${delivery.zonaEntrega}',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: AppColors.cardBorder),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '\$${delivery.totalPedido.toStringAsFixed(2)}',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 14,
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
                            'Fecha',
                            style: AppTextStyles.SubTitle.copyWith(
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                delivery.fechaCreacion != null
                                    ? '${delivery.fechaCreacion!.toLocal().day}/${delivery.fechaCreacion!.toLocal().month}/${delivery.fechaCreacion!.toLocal().year}'
                                    : '—',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 14,
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFD0CB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.pending_actions,
                            size: 14,
                            color: AppColors.inputErrorColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Pendiente de recogida',
                            style: AppTextStyles.chip.copyWith(
                              color: AppColors.inputErrorColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: onVerEntrega,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
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
}

class _EmptyDeliveryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: AppColors.TextSoft),
          const SizedBox(height: 12),
          Text(
            'No hay entregas pendientes',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            'Las entregas aparecerán aquí cuando se asignen',
            style: AppTextStyles.SubTitle.copyWith(
              color: AppColors.TextSoft,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  final VoidCallback onVerRuta;
  final int paradasCount;

  const _RouteSummaryCard({
    required this.onVerRuta,
    required this.paradasCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySoftBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x4D006E2C)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.route, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
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
                      '$paradasCount paradas pendientes',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
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
              onPressed: onVerRuta,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
                side: const BorderSide(color: AppColors.accentBlue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
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
