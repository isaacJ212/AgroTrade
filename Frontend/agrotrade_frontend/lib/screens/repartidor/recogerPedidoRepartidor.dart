import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'entregaEnCursoRepartidor.dart';
import 'repartidor_demo.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class RecogerPedidoRepartidor extends StatefulWidget {
  final int? pedidoId;
  const RecogerPedidoRepartidor({super.key, this.pedidoId});

  @override
  State<RecogerPedidoRepartidor> createState() => _RecogerPedidoRepartidorState();
}

class _RecogerPedidoRepartidorState extends State<RecogerPedidoRepartidor> {
  final Set<int> _revisados = {};

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    final entrega = demo.buscar(widget.pedidoId ?? 101);
    final listo = entrega != null && entrega.productos.isNotEmpty &&
        _revisados.length == entrega.productos.length &&
        entrega.estado == EstadoEntregaDemo.enCurso;
    return RepartidorScaffold(
      titulo: 'Recoger pedido', volver: true,
      body: entrega == null
          ? const Center(child: Text('No se encontró esta entrega.'))
          : ListView(padding: const EdgeInsets.all(16), children: [
              RepartidorCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Pedido ${entrega.codigo}', style: RepartidorTextStyles.Title),
                  const SizedBox(height: 12),
                  DatoRepartidor(icon: Icons.storefront_outlined,
                    titulo: 'Finca de recogida', valor: entrega.finca),
                  DatoRepartidor(icon: Icons.schedule,
                    titulo: 'Hora prevista', valor: entrega.hora),
                ],
              )),
              const SizedBox(height: 16),
              RepartidorCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Verifica los productos', style: RepartidorTextStyles.productoTitle),
                  const SizedBox(height: 8),
                  Text('${_revisados.length} de ${entrega.productos.length} revisados',
                    style: RepartidorTextStyles.SubTitle),
                  const SizedBox(height: 12),
                  ClipRRect(borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: entrega.productos.isEmpty ? 0 :
                          _revisados.length / entrega.productos.length,
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.navPill,
                    )),
                  const SizedBox(height: 12),
                  for (var i = 0; i < entrega.productos.length; i++)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primaryColor,
                      value: _revisados.contains(i),
                      onChanged: (value) => setState(() {
                        if (value == true) {
                          _revisados.add(i);
                        } else {
                          _revisados.remove(i);
                        }
                      }),
                      title: Text(entrega.productos[i].nombre),
                      subtitle: Text(
                        '${entrega.productos[i].cantidad} ${entrega.productos[i].unidad}'),
                    ),
                ],
              )),
              const SizedBox(height: 20),
              RepartidorBoton(
                label: 'Confirmar recogida',
                onPressed: !listo ? null : () {
                  demo.recoger(entrega.id);
                  Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(builder: (_) =>
                      EntregaEnCursoRepartidor(pedidoId: entrega.id)));
                },
              ),
              const SizedBox(height: 12),
              const Text('Revisa todos los productos antes de continuar.',
                textAlign: TextAlign.center, style: RepartidorTextStyles.SubTitle),
            ]),
    );
  }
}
