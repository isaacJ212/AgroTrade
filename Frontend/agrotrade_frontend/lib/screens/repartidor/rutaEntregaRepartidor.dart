import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'detalleEntregaRepartidor.dart';
import '../../ui/widgets/mapaRutaRepartidor.dart';
import 'repartidor_demo.dart';
import 'repartidor_navigation.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class RutaEntregaRepartidor extends StatelessWidget {
  final int? pedidoId;
  const RutaEntregaRepartidor({super.key, this.pedidoId});

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    return AnimatedBuilder(
      animation: demo,
      builder: (context, _) {
        final entrega = pedidoId == null ? demo.activa : demo.buscar(pedidoId);
        return RepartidorScaffold(
          titulo: 'Ruta de entrega',
          tab: 2,
          volver: pedidoId != null,
          fondo: entrega == null
              ? AppColors.scaffoldBg
              : const Color(0xFFE0E0E0),
          body: entrega == null
              ? ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const RepartidorCard(
                      child: DatoRepartidor(
                        icon: Icons.route,
                        titulo: 'Sin ruta activa',
                        valor: 'Acepta una entrega para ver su recorrido.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    RepartidorBoton(
                      label: 'Ver entregas',
                      onPressed: () => navegarRepartidor(context, 2, 1),
                    ),
                  ],
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final resumen = _ResumenRutaRepartidor(entrega: entrega);
                    final mapa = MapaRutaRepartidor(entrega: entrega);
                    final textoGrande =
                        MediaQuery.textScalerOf(context).scale(14) > 16;

                    if (constraints.maxHeight >= 700 && !textoGrande) {
                      return Column(
                        children: [
                          Expanded(child: mapa),
                          resumen,
                        ],
                      );
                    }

                    return ListView(
                      children: [
                        SizedBox(
                          height: (constraints.maxHeight * 0.55)
                              .clamp(340.0, 480.0)
                              .toDouble(),
                          child: mapa,
                        ),
                        resumen,
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ResumenRutaRepartidor extends StatelessWidget {
  final EntregaDemo entrega;

  const _ResumenRutaRepartidor({required this.entrega});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tiempo estimado',
                  style: RepartidorTextStyles.SubTitle,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entrega.minutos} min',
                      style: RepartidorTextStyles.sectionTitle,
                    ),
                    Text(
                      '${entrega.distancia} km',
                      style: RepartidorTextStyles.SubTitle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.cardBorder),
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primarySoftBg,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entrega.cliente,
                      style: RepartidorTextStyles.productoTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(entrega.destino, style: RepartidorTextStyles.SubTitle),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Ver detalle del pedido',
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.primaryColor,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        DetalleEntregaRepartidor(pedidoId: entrega.id),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Recogida: ${entrega.finca}',
            style: RepartidorTextStyles.SubTitle,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(entrega.codigo, style: RepartidorTextStyles.label),
              EstadoEntregaChip(entrega: entrega),
            ],
          ),
          const SizedBox(height: 16),
          RepartidorBoton(
            label: entrega.estado == EstadoEntregaDemo.enCurso
                ? 'Continuar entrega'
                : 'Ver entrega',
            onPressed: () => abrirEntregaDemo(context, entrega),
          ),
        ],
      ),
    );
  }
}
