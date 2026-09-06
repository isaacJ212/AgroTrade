import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'aceptarEntregaRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import 'repartidor_demo.dart';
import 'repartidor_navigation.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class DetalleEntregaRepartidor extends StatelessWidget {
  final int? pedidoId;
  final String? zonaEntrega;
  final double? totalPedido;
  const DetalleEntregaRepartidor({
    super.key, this.pedidoId, this.zonaEntrega, this.totalPedido,
  });

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    return AnimatedBuilder(
      animation: demo,
      builder: (context, _) {
        final entrega = demo.buscar(pedidoId ?? 101);
        return RepartidorScaffold(
          titulo: 'Detalle de la entrega', volver: true,
          body: entrega == null
              ? const Center(child: Text('No se encontró esta entrega.'))
              : ListView(padding: const EdgeInsets.all(16), children: [
                  RepartidorCard(child: Wrap(
                    spacing: 16, runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('Entrega ${entrega.codigo}', style: RepartidorTextStyles.Title),
                      EstadoEntregaChip(entrega: entrega),
                    ],
                  )),
                  const SizedBox(height: 16),
                  RepartidorCard(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DatoRepartidor(icon: Icons.storefront_outlined,
                        titulo: 'Punto de recogida', valor: entrega.finca),
                      DatoRepartidor(icon: Icons.schedule,
                        titulo: 'Hora de recogida', valor: entrega.hora),
                      const Divider(height: 24, color: AppColors.cardBorder),
                      DatoRepartidor(icon: Icons.person_outline,
                        titulo: 'Cliente', valor: entrega.cliente),
                      DatoRepartidor(icon: Icons.location_on_outlined,
                        titulo: 'Destino', valor: zonaEntrega ?? entrega.destino),
                      const SizedBox(height: 8),
                      RepartidorCard(color: AppColors.surfaceAlt,
                        child: Text(entrega.indicaciones, style: RepartidorTextStyles.SubTitle)),
                      const SizedBox(height: 12),
                      RepartidorBoton(
                        label: 'Ver ruta', secundario: true,
                        onPressed: () => Navigator.push(context,
                          MaterialPageRoute<void>(builder: (_) =>
                            RutaEntregaRepartidor(pedidoId: entrega.id))),
                      ),
                    ],
                  )),
                  const SizedBox(height: 16),
                  RepartidorCard(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Productos del pedido · ${entrega.productos.length}',
                        style: RepartidorTextStyles.productoTitle),
                      const SizedBox(height: 8),
                      for (final producto in entrega.productos)
                        ProductoRepartidorRow(producto: producto),
                      const Divider(height: 24, color: AppColors.cardBorder),
                      DatoRepartidor(icon: Icons.receipt_long_outlined,
                        titulo: 'Total de productos',
                        valor: dineroRepartidor(totalPedido ?? entrega.total)),
                      DatoRepartidor(icon: Icons.account_balance_wallet_outlined,
                        titulo: 'Tu pago por la entrega',
                        valor: dineroRepartidor(entrega.pago)),
                    ],
                  )),
                  if (entrega.nota.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    RepartidorCard(child: DatoRepartidor(icon: Icons.notes,
                      titulo: 'Nota de entrega', valor: entrega.nota)),
                  ],
                  const SizedBox(height: 20),
                  if (entrega.estado == EstadoEntregaDemo.pendiente)
                    RepartidorBoton(
                      label: 'Aceptar entrega',
                      onPressed: () => Navigator.push(context,
                        MaterialPageRoute<void>(builder: (_) =>
                          AceptarEntregaRepartidor(pedidoId: entrega.id))),
                    )
                  else if (entrega.estado == EstadoEntregaDemo.enCurso)
                    RepartidorBoton(label: 'Continuar entrega',
                      onPressed: () => abrirEntregaDemo(context, entrega)),
                  const SizedBox(height: 12),
                  RepartidorBoton(
                    label: 'Información de contacto', secundario: true,
                    onPressed: () => mostrarInfoRepartidor(context, 'Contacto',
                      'Finca: ${entrega.finca}\nCliente: ${entrega.cliente}\n\n'
                      'Mensajes y llamadas no disponibles.'),
                  ),
                ]),
        );
      },
    );
  }
}
