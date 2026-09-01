import 'package:flutter/material.dart';
import '../../models/entrega.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../models/entrega.dart';

import 'detalleEntregaRepartidor.dart';
import 'entregaEnCursoRepartidor.dart';

class Entregasrepartidor extends StatefulWidget {
  const Entregasrepartidor({super.key});

  @override
  State<Entregasrepartidor> createState() => _EntregasrepartidorState();
}

class _EntregasrepartidorState extends State<Entregasrepartidor> {
  // Datos de ejemplo; reemplazar por datos reales/API según sea necesario
  final List<NotificacionEntrega> _entregas = [
    NotificacionEntrega(
      pedidoId: 101,
      estado: 'Pendiente',
      zonaEntrega: 'Barrio Centro',
      totalPedido: 1250.5,
      fechaCreacion: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    NotificacionEntrega(
      pedidoId: 102,
      estado: 'En curso',
      zonaEntrega: 'Avenida 9 de Julio',
      totalPedido: 980.0,
      fechaCreacion: DateTime.now().subtract(
        const Duration(hours: 1, minutes: 5),
      ),
    ),
    NotificacionEntrega(
      pedidoId: 103,
      estado: 'Entregado',
      zonaEntrega: 'Zona Rural - Sector A',
      totalPedido: 450.75,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
  ];

  List<NotificacionEntrega> _porEstado(String estado) =>
      _entregas.where((e) => e.estado == estado).toList();

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Entregas",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/notificaciones'),
              icon: const Icon(Icons.notifications_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            const TabBar(
              isScrollable: true,
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: AppColors.bodyText,
              labelStyle: TextStyle(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'Todas'),
                Tab(text: 'Pendientes'),
                Tab(text: 'En curso'),
                Tab(text: 'Entregado'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ListaEntregas(
                    entregas: _entregas,
                    onVerDetalle: (entrega) => _go(
                      context,
                      DetalleEntregaRepartidor(
                        pedidoId: entrega.pedidoId,
                        zonaEntrega: entrega.zonaEntrega,
                        totalPedido: entrega.totalPedido,
                      ),
                    ),
                    onContinuar: (entrega) =>
                        _go(context, const EntregaEnCursoRepartidor()),
                  ),
                  _ListaEntregas(
                    entregas: _porEstado('Pendiente'),
                    onVerDetalle: (entrega) => _go(
                      context,
                      DetalleEntregaRepartidor(
                        pedidoId: entrega.pedidoId,
                        zonaEntrega: entrega.zonaEntrega,
                        totalPedido: entrega.totalPedido,
                      ),
                    ),
                  ),
                  _ListaEntregas(
                    entregas: _porEstado('En curso'),
                    onContinuar: (entrega) =>
                        _go(context, const EntregaEnCursoRepartidor()),
                  ),
                  _ListaEntregas(entregas: _porEstado('Entregado')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaEntregas extends StatelessWidget {
  final List<NotificacionEntrega> entregas;
  final void Function(NotificacionEntrega entrega)? onVerDetalle;
  final void Function(NotificacionEntrega entrega)? onContinuar;

  const _ListaEntregas({
    required this.entregas,
    this.onVerDetalle,
    this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    // Estado vacío: si una pestaña no tiene datos, no dejes la pantalla muda
    if (entregas.isEmpty) {
      return const Center(
        child: Text('Sin entregas aquí 🎉', style: AppTextStyles.SubTitle),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entregas.length,
      // separated pone un widget ENTRE elementos (no al final) → más limpio
      // que meter margin en cada tarjeta
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final entrega = entregas[index];
        return GestureDetector(
          onTap: entrega.estado == 'En curso'
              ? () => onContinuar?.call(entrega)
              : () => onVerDetalle?.call(entrega),
          child: EntregaDetalleCard(
            entrega: entrega,
            onVerDetalle: onVerDetalle == null
                ? null
                : () => onVerDetalle!(entrega),
            onContinuar: onContinuar == null
                ? null
                : () => onContinuar!(entrega),
          ),
        );
      },
    );
  }
}
