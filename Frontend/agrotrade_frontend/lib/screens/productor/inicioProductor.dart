import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../routes/app_routes.dart';
import '../../routes/productor_navigation.dart';
import '../../services/api_session.dart';
import '../../services/productor_store.dart';
import '../../ui/widgets/productor_widgets.dart';
import '../../ui/app_theme.dart';
import 'productorShell.dart';
import 'precio_justo/calculadoraPrecioJusto.dart';

class InicioProductor extends StatelessWidget {
  final bool embedded;
  const InicioProductor({super.key, this.embedded = false});
  Future<void> _calcularPrecio(BuildContext context) async {
    final store = ProductorStore.instance;
    if (store.productos.isEmpty) {
      mensajeProductor(context, 'Agrega un producto para calcular su precio.');
      return;
    }
    final producto = await showModalBottomSheet<Producto>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Selecciona el producto', style: AppTextStyles.Title),
            ),
            for (final p in store.productos)
              ListTile(
                title: Text(p.nombre),
                subtitle: Text(p.unidad),
                onTap: () => Navigator.pop(sheet, p),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted || producto == null) return;
    final cantidad = producto.cantidad > 0 ? producto.cantidad : 1.0;
    final precio = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => CalculadoraPrecioJusto(
          nombreProducto: producto.nombre,
          unidadInicial: producto.unidad,
          costoInicial: producto.costoProduccion * cantidad,
          cantidadInicial: cantidad,
          devolverPrecio: true,
        ),
      ),
    );
    if (context.mounted &&
        precio != null &&
        accionProductor(
          context,
          () => store.aplicarPrecio(producto.id, precio),
        )) {
      mensajeProductor(context, 'Precio actualizado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!embedded) return const ProductorShell();
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final now = DateTime.now();
        final pendientes = store.pedidos
            .where((p) => p.estado == EstadoPedido.pendiente)
            .length;
        final ventas = store.pedidos
            .where(
              (p) =>
                  p.estado == EstadoPedido.listo &&
                  p.fecha.year == now.year &&
                  p.fecha.month == now.month,
            )
            .fold<double>(0, (sum, p) => sum + p.subtotal);
        final alertas = store.productos
            .where((p) => p.estado != EstadoProducto.disponible)
            .length;
        final hora = now.hour;
        final saludo = hora < 12
            ? 'Buenos días'
            : hora < 19
            ? 'Buenas tardes'
            : 'Buenas noches';
        return ProductorPage(
          title: 'Inicio',
          rootIndex: 0,
          actions: [
            IconButton(
              tooltip: 'Notificaciones',
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () =>
                  Navigator.pushNamed(context, '/productor/notificaciones'),
            ),
          ],
          children: [
            Row(
              children: [
                const CircleAvatar(
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
                      Text(saludo, style: AppTextStyles.SubTitle),
                      Text(
                        ApiSession.instance.userName ?? store.persona.nombre,
                        style: AppTextStyles.Title,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ProductorSection('Resumen de hoy'),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 12,
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: ProductorStat(
                      label: 'Ventas del mes',
                      value: dinero(ventas),
                      icon: Icons.payments_outlined,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.ventas),
                    ),
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: ProductorStat(
                      label: 'Pedidos pendientes',
                      value: '$pendientes',
                      icon: Icons.shopping_bag_outlined,
                      onTap: () => ProductorNavigation.cambiarTab(context, 2),
                    ),
                  ),
                  SizedBox(
                    width: (constraints.maxWidth - 12) / 2,
                    child: ProductorStat(
                      label: 'Alertas de inventario',
                      value: '$alertas',
                      icon: Icons.inventory_2_outlined,
                      onTap: () => ProductorNavigation.cambiarTab(context, 1),
                    ),
                  ),
                ],
              ),
            ),
            const ProductorSection('Gestiona tu finca'),
            ProductorCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ProductorMenuItem(
                    label: 'Agregar producto',
                    icon: Icons.add_box_outlined,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.agregarProducto),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Ofertas de excedentes',
                    icon: Icons.local_offer_outlined,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.crearOferta),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Mapa de demanda',
                    icon: Icons.map_outlined,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.mapaCalorDemanda,
                    ),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Mi impacto',
                    icon: Icons.eco_outlined,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.tableroImpacto),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Calcular precio justo',
                    icon: Icons.calculate_outlined,
                    onTap: () => _calcularPrecio(context),
                  ),
                ],
              ),
            ),
            const ProductorSection('Pedidos recientes'),
            if (store.pedidos.isEmpty)
              const ProductorEmpty('Todavía no tienes pedidos.'),
            for (final pedido in store.pedidos.take(3))
              ProductorOrderTile(
                pedido: pedido,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.orderDetail,
                  arguments: pedido.codigo,
                ),
              ),
          ],
        );
      },
    );
  }
}
