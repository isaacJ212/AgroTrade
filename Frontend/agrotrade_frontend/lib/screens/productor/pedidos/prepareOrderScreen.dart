import 'package:flutter/material.dart';
import '../../../models/productor_models.dart';
import '../../../services/productor_store.dart';
import '../../../routes/productor_navigation.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';

class PrepareOrderScreen extends StatelessWidget {
  final String? pedidoId;
  const PrepareOrderScreen({super.key, this.pedidoId});
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final p = pedidoId == null ? null : store.pedido(pedidoId!);
        if (p == null)
          return const ProductorPage(
            title: 'Preparar pedido',
            children: [ProductorEmpty('Selecciona un pedido para continuar.')],
          );
        final progreso = p.productos.isEmpty
            ? 0.0
            : p.preparados / p.productos.length;
        return ProductorPage(
          title: 'Preparar pedido',
          children: [
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.codigo, style: AppTextStyles.Title),
                  const SizedBox(height: 12),
                  Text(p.cliente),
                  const SizedBox(height: 12),
                  ProductorStatus(p.estado.label),
                  const SizedBox(height: 20),
                  Text(
                    '${p.preparados} de ${p.productos.length} productos preparados',
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progreso,
                    minHeight: 8,
                    backgroundColor: AppColors.primarySoftBg,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
            const ProductorSection('Productos a preparar'),
            for (var i = 0; i < p.productos.length; i++)
              ProductorCard(
                padding: EdgeInsets.zero,
                child: CheckboxListTile(
                  title: Text(p.productos[i].nombre),
                  subtitle: Text(
                    '${numero(p.productos[i].cantidad)} ${p.productos[i].unidad}',
                  ),
                  value: p.productos[i].preparado,
                  activeColor: AppColors.primaryColor,
                  onChanged: p.estado != EstadoPedido.enPreparacion
                      ? null
                      : (value) {
                          accionProductor(
                            context,
                            () => store.preparar(p.codigo, i, value ?? false),
                          );
                        },
                ),
              ),
            if (p.nota.isNotEmpty)
              ProductorCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProductorSection('Nota del comprador'),
                    Text(p.nota),
                  ],
                ),
              ),
            if (p.estado == EstadoPedido.enPreparacion)
              ProductorButton(
                label: 'Marcar como listo',
                icon: Icons.check_circle_outline,
                onPressed: !p.todoPreparado
                    ? null
                    : () {
                        if (accionProductor(
                          context,
                          () =>
                              store.cambiarEstado(p.codigo, EstadoPedido.listo),
                        )) {
                          mensajeProductor(
                            context,
                            'Pedido listo para la recogida.',
                          );
                          Navigator.pop(context, true);
                        }
                      },
              ),
            if (p.estado == EstadoPedido.pendiente)
              const ProductorEmpty('Confirma el pedido antes de prepararlo.'),
            const SizedBox(height: 12),
            ProductorButton(
              label: 'Enviar mensaje al comprador',
              outlined: true,
              icon: Icons.chat_bubble_outline,
              onPressed: () => ProductorNavigation.chat(context, p.cliente),
            ),
          ],
        );
      },
    );
  }
}
