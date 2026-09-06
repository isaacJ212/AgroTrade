import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'repartidor_demo.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class Entregasrepartidor extends StatelessWidget {
  const Entregasrepartidor({super.key});

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    return AnimatedBuilder(
      animation: demo,
      builder: (context, _) => DefaultTabController(
        length: 4,
        child: RepartidorScaffold(
          titulo: 'Mis entregas',
          tab: 1,
          body: Column(
            children: [
              const TabBar(
                isScrollable: true,
                labelColor: AppColors.primaryColor,
                indicatorColor: AppColors.primaryColor,
                unselectedLabelColor: AppColors.TextSoft,
                tabs: [
                  Tab(text: 'Todas'),
                  Tab(text: 'Pendientes'),
                  Tab(text: 'En curso'),
                  Tab(text: 'Completadas'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _Lista(entregas: demo.entregas),
                    _Lista(
                      entregas: demo.porEstado(EstadoEntregaDemo.pendiente),
                    ),
                    _Lista(entregas: demo.porEstado(EstadoEntregaDemo.enCurso)),
                    _Lista(
                      entregas: demo.porEstado(EstadoEntregaDemo.completada),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lista extends StatelessWidget {
  final List<EntregaDemo> entregas;
  const _Lista({required this.entregas});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      if (entregas.isEmpty)
        const RepartidorCard(
          child: DatoRepartidor(
            icon: Icons.local_shipping_outlined,
            titulo: 'Sin entregas',
            valor: 'No hay pedidos en este estado.',
          ),
        ),
      for (final entrega in entregas) ...[
        EntregaDemoCard(entrega: entrega),
        const SizedBox(height: 12),
      ],
    ],
  );
}
