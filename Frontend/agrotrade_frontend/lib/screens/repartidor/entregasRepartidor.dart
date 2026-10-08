import 'package:flutter/material.dart';
import '../../services/delivery_api_service.dart';
import '../../models/api/delivery_models.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import 'detalleEntregaRepartidor.dart';

class Entregasrepartidor extends StatefulWidget {
  const Entregasrepartidor({super.key});

  @override
  State<Entregasrepartidor> createState() => _EntregasrepartidorState();
}

class _EntregasrepartidorState extends State<Entregasrepartidor> {
  late final Future<List<PendingDeliveryNotificationDto>> _pendingFuture;

  @override
  void initState() {
    super.initState();
    _pendingFuture = DeliveryApiService.instance
        .getPendingDeliveries()
        .catchError((_) => <PendingDeliveryNotificationDto>[]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Mis entregas', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: FutureBuilder<List<PendingDeliveryNotificationDto>>(
        future: _pendingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (snapshot.hasError) {
            return _EmptyState(
              icon: Icons.error_outline,
              title: 'Error al cargar entregas',
              actionLabel: 'Reintentar',
              onAction: () => setState(() {
                _pendingFuture = DeliveryApiService.instance
                    .getPendingDeliveries()
                    .catchError((_) => <PendingDeliveryNotificationDto>[]);
              }),
            );
          }

          final pendingDeliveries = snapshot.data ?? <PendingDeliveryNotificationDto>[];

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: AppColors.primaryColor,
                  indicatorColor: AppColors.primaryColor,
                  unselectedLabelColor: AppColors.TextSoft,
                  tabs: [
                    Tab(text: 'Todas'),
                    Tab(text: 'Pendientes'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _Lista(entregas: pendingDeliveries),
                      _Lista(entregas: pendingDeliveries),
                    ],
                  ),
                ),
              ],
            ));
        },
      ),
      bottomNavigationBar: RepartidorBottomNav(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final List<PendingDeliveryNotificationDto> entregas;
  const _Lista({required this.entregas});

  @override
  Widget build(BuildContext context) {
    if (entregas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_outlined, size: 64, color: AppColors.TextSoft),
            const SizedBox(height: 16),
            Text(
              'Sin entregas',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 8),
            Text(
              'No hay pedidos pendientes en este momento.',
              style: AppTextStyles.SubTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entregas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entrega = entregas[index];
        return _EntregaCard(
          pedidoId: entrega.pedidoId,
          zonaEntrega: entrega.zonaEntrega,
          totalPedido: entrega.totalPedido,
          fechaCreacion: entrega.fechaCreacion,
        );
      },
    );
  }
}

class _EntregaCard extends StatelessWidget {
  final int pedidoId;
  final String zonaEntrega;
  final double totalPedido;
  final DateTime? fechaCreacion;

  const _EntregaCard({
    required this.pedidoId,
    required this.zonaEntrega,
    required this.totalPedido,
    this.fechaCreacion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleEntregaRepartidor(
              pedidoId: pedidoId,
              zonaEntrega: zonaEntrega,
              totalPedido: totalPedido,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entrega #AT-$pedidoId',
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.TextSoft,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Destino: $zonaEntrega',
                              style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
                const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${totalPedido.toStringAsFixed(2)}',
                        style: AppTextStyles.label.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Creada',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fechaCreacion != null
                            ? '${fechaCreacion!.day}/${fechaCreacion!.month}/${fechaCreacion!.year}'
                            : '—',
                        style: AppTextStyles.label.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.TextSoft),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.White,
              ),
              onPressed: onAction,
              icon: const Icon(Icons.refresh),
              label: Text(actionLabel),
            ),
          ],
        ),
      );
  }
}
