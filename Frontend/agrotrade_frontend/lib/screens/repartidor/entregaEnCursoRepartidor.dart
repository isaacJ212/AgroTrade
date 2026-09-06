import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'confirmarEntregaRepartidor.dart';
import '../../ui/widgets/mapaRutaRepartidor.dart';
import 'recogerPedidoRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import 'repartidor_demo.dart';
import 'repartidor_navigation.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class EntregaEnCursoRepartidor extends StatelessWidget {
  final int? pedidoId;
  const EntregaEnCursoRepartidor({super.key, this.pedidoId});

  void _verRuta(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => RutaEntregaRepartidor(pedidoId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    return AnimatedBuilder(
      animation: demo,
      builder: (context, _) {
        final entrega = pedidoId == null ? demo.activa : demo.buscar(pedidoId);
        return RepartidorScaffold(
          titulo: 'Entrega en curso', tab: 2, volver: true,
          body: entrega == null
              ? const Center(child: Text('No hay una entrega en curso.'))
              : ListView(padding: const EdgeInsets.all(16), children: [
                  RepartidorCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ruta de entrega',
                          style: RepartidorTextStyles.productoTitle),
                        const SizedBox(height: 12),
                        DatoRepartidor(
                          icon: Icons.location_on_outlined,
                          titulo: 'Destino',
                          valor: entrega.destino,
                        ),
                        const SizedBox(height: 12),
                        VistaPreviaRutaRepartidor(
                          onTap: () => _verRuta(context, entrega.id),
                        ),
                        const SizedBox(height: 12),
                        RepartidorBoton(
                          label: 'Ver ruta',
                          secundario: true,
                          onPressed: () => _verRuta(context, entrega.id),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RepartidorCard(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Wrap(spacing: 12, runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text('Entrega ${entrega.codigo}', style: RepartidorTextStyles.Title),
                          EstadoEntregaChip(entrega: entrega),
                        ]),
                      const SizedBox(height: 12),
                      DatoRepartidor(icon: Icons.person_outline,
                        titulo: 'Destinatario', valor: entrega.cliente),
                      DatoRepartidor(icon: Icons.location_on_outlined,
                        titulo: 'Destino', valor: entrega.destino),
                      const Divider(height: 24, color: AppColors.cardBorder),
                      _Paso(titulo: 'Entrega aceptada',
                        completo: entrega.estado != EstadoEntregaDemo.pendiente),
                      _Paso(titulo: 'Pedido recogido', completo: entrega.recogido),
                      _Paso(titulo: 'En camino',
                        completo: entrega.estado == EstadoEntregaDemo.completada,
                        activo: entrega.recogido && entrega.estado == EstadoEntregaDemo.enCurso),
                      _Paso(titulo: 'Entregado',
                        completo: entrega.estado == EstadoEntregaDemo.completada),
                      const SizedBox(height: 12),
                      RepartidorCard(color: AppColors.surfaceAlt,
                        child: DatoRepartidor(icon: Icons.info_outline,
                          titulo: 'Indicaciones', valor: entrega.indicaciones)),
                    ],
                  )),
                  const SizedBox(height: 20),
                  if (entrega.estado == EstadoEntregaDemo.enCurso)
                    RepartidorBoton(
                      label: entrega.recogido ? 'Llegué al destino' : 'Verificar recogida',
                      onPressed: () => Navigator.push(context,
                        MaterialPageRoute<void>(builder: (_) => entrega.recogido
                          ? ConfirmarEntregaRepartidor(pedidoId: entrega.id)
                          : RecogerPedidoRepartidor(pedidoId: entrega.id))),
                    )
                  else
                    RepartidorBoton(label: 'Ver mis entregas',
                      onPressed: () => navegarRepartidor(context, 2, 1)),
                  const SizedBox(height: 12),
                  RepartidorBoton(label: 'Contacto del cliente', secundario: true,
                    onPressed: () => mostrarInfoRepartidor(context, 'Cliente',
                      '${entrega.cliente}\n${entrega.destino}\n\n'
                      'Llamadas y mensajes no disponibles.')),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => mostrarInfoRepartidor(context, 'Reportar un problema',
                      'No se ha enviado ningún reporte.\n\n'
                      'La opción de reportes aún no está disponible.'),
                    icon: const Icon(Icons.report_problem_outlined),
                    label: const Text('Reportar problema'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
                  ),
                ]),
        );
      },
    );
  }
}

class _Paso extends StatelessWidget {
  final String titulo;
  final bool completo;
  final bool activo;
  const _Paso({required this.titulo, this.completo = false, this.activo = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      CircleAvatar(radius: 14,
        backgroundColor: completo || activo ? AppColors.navPill : AppColors.surfaceAlt,
        child: Icon(completo ? Icons.check : activo ? Icons.local_shipping : Icons.circle_outlined,
          size: 17, color: completo || activo ? AppColors.primaryColor : AppColors.TextSoft)),
      const SizedBox(width: 12),
      Expanded(child: Text(titulo, style: RepartidorTextStyles.label.copyWith(
        color: activo ? AppColors.primaryColor : AppColors.TextMain))),
    ]),
  );
}
