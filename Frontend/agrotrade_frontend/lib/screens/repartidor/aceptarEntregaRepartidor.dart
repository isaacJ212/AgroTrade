import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'recogerPedidoRepartidor.dart';
import 'repartidor_demo.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class AceptarEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  const AceptarEntregaRepartidor({super.key, this.pedidoId});

  @override
  State<AceptarEntregaRepartidor> createState() => _AceptarEntregaRepartidorState();
}

class _AceptarEntregaRepartidorState extends State<AceptarEntregaRepartidor> {
  bool _confirmado = false;

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    final entrega = demo.buscar(widget.pedidoId ?? 101);
    return RepartidorScaffold(
      titulo: 'Aceptar entrega', volver: true,
      body: entrega == null
          ? const Center(child: Text('No se encontró esta entrega.'))
          : ListView(padding: const EdgeInsets.all(16), children: [
              RepartidorCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Entrega ${entrega.codigo}', style: RepartidorTextStyles.Title),
                  const SizedBox(height: 16),
                  DatoRepartidor(icon: Icons.storefront_outlined,
                    titulo: 'Recoger en', valor: entrega.finca),
                  DatoRepartidor(icon: Icons.location_on_outlined,
                    titulo: 'Entregar en', valor: entrega.destino),
                  DatoRepartidor(icon: Icons.schedule,
                    titulo: 'Hora de recogida', valor: entrega.hora),
                  DatoRepartidor(icon: Icons.account_balance_wallet_outlined,
                    titulo: 'Pago por la entrega', valor: dineroRepartidor(entrega.pago)),
                ],
              )),
              const SizedBox(height: 16),
              RepartidorCard(color: AppColors.primarySoftBg,
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primaryColor,
                  value: _confirmado,
                  onChanged: (value) => setState(() => _confirmado = value ?? false),
                  title: const Text('Estoy listo para realizar esta entrega'),
                  subtitle: const Text('Confirma que puedes recoger los productos.'),
                )),
              const SizedBox(height: 12),
              if (!demo.disponible)
                const Text(
                  'Activa tu disponibilidad en Perfil para aceptar entregas.',
                  style: RepartidorTextStyles.SubTitle,
                ),
              const SizedBox(height: 20),
              RepartidorBoton(
                label: 'Aceptar y verificar recogida',
                onPressed: !_confirmado || !demo.disponible ||
                    entrega.estado != EstadoEntregaDemo.pendiente ? null : () {
                  demo.aceptar(entrega.id);
                  Navigator.pushReplacement(context,
                    MaterialPageRoute<void>(builder: (_) =>
                      RecogerPedidoRepartidor(pedidoId: entrega.id)));
                },
              ),
              const SizedBox(height: 12),
              RepartidorBoton(label: 'Volver', secundario: true,
                onPressed: () => Navigator.pop(context)),
            ]),
    );
  }
}
