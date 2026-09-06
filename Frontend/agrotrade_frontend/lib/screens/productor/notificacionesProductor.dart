import 'package:flutter/material.dart';
import '../../services/productor_store.dart';
import '../../routes/app_routes.dart';
import '../../ui/widgets/productor_widgets.dart';

class NotificacionesProductor extends StatelessWidget {
  const NotificacionesProductor({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => ProductorPage(
        title: 'Notificaciones',
        children: [
          if (!store.notificaciones)
            const ProductorEmpty(
              'Las notificaciones están desactivadas en Configuración.',
            )
          else if (store.pedidos.isEmpty)
            const ProductorEmpty('No tienes avisos de pedidos.')
          else
            for (final p in store.pedidos)
              ProductorCard(
                padding: EdgeInsets.zero,
                child: ProductorMenuItem(
                  label: '${p.codigo} · ${p.estado.label}',
                  subtitle: p.cliente,
                  icon: Icons.notifications_outlined,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.orderDetail,
                    arguments: p.codigo,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
