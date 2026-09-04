import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'homeRepartidor.dart';
import 'repartidor_demo.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class ConfirmarEntregaRepartidor extends StatefulWidget {
  final int? pedidoId;
  const ConfirmarEntregaRepartidor({super.key, this.pedidoId});

  @override
  State<ConfirmarEntregaRepartidor> createState() => _ConfirmarEntregaRepartidorState();
}

class _ConfirmarEntregaRepartidorState extends State<ConfirmarEntregaRepartidor> {
  bool _confirmado = false;
  final _nota = TextEditingController();

  @override
  void dispose() {
    _nota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    final entrega = widget.pedidoId == null ? demo.activa : demo.buscar(widget.pedidoId);
    return RepartidorScaffold(
      titulo: 'Confirmar entrega', volver: true,
      body: entrega == null
          ? const Center(child: Text('No hay una entrega para confirmar.'))
          : ListView(padding: const EdgeInsets.all(16), children: [
              RepartidorCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Entrega ${entrega.codigo}', style: RepartidorTextStyles.Title),
                  const SizedBox(height: 12),
                  DatoRepartidor(icon: Icons.person_outline,
                    titulo: 'Recibido por', valor: entrega.cliente),
                  DatoRepartidor(icon: Icons.location_on_outlined,
                    titulo: 'Destino', valor: entrega.destino),
                  DatoRepartidor(icon: Icons.account_balance_wallet_outlined,
                    titulo: 'Pago de esta entrega', valor: dineroRepartidor(entrega.pago)),
                ],
              )),
              const SizedBox(height: 16),
              RepartidorCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: AppColors.primaryColor,
                    value: _confirmado,
                    onChanged: (value) => setState(() => _confirmado = value ?? false),
                    title: const Text('Confirmo que entregué todos los productos al cliente.'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Nota de entrega (opcional)', style: RepartidorTextStyles.label),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nota,
                    minLines: 3, maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Observaciones sobre la entrega.',
                      filled: true, fillColor: AppColors.scaffoldBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 20),
              RepartidorBoton(
                label: 'Confirmar entrega',
                onPressed: !_confirmado || !entrega.recogido ||
                    entrega.estado != EstadoEntregaDemo.enCurso ? null : () {
                  demo.completar(entrega.id, _nota.text);
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute<void>(builder: (_) => const InicioRepartidor()),
                    (_) => false);
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Al confirmar, se actualizarán tus entregas y ganancias.',
                textAlign: TextAlign.center, style: RepartidorTextStyles.SubTitle),
            ]),
    );
  }
}
