import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/productor_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/productor_store.dart';
import '../../../services/productor_api_service.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/widgets/productor_widgets.dart';
import '../precio_justo/calculadoraPrecioJusto.dart';

class DetalleProducto extends StatelessWidget {
  final Producto producto;
  const DetalleProducto({super.key, required this.producto});
  Future<void> _calcular(BuildContext context, Producto p) async {
    final precio = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => CalculadoraPrecioJusto(
          nombreProducto: p.nombre,
          unidadInicial: p.unidad,
          costoInicial: p.costoProduccion * (p.cantidad > 0 ? p.cantidad : 1),
          cantidadInicial: p.cantidad > 0 ? p.cantidad : 1,
          devolverPrecio: true,
        ),
      ),
    );
    if (context.mounted && precio != null) {
      // Update in API
      final success = await ProductorApiService.instance.actualizarInventario(
        p.id, p.cantidad, precio, p.fechaCosecha
      );
      if (success && context.mounted) {
        mensajeProductor(context, 'Precio actualizado en el servidor.');
      } else if (context.mounted) {
        // Local fallback
        ProductorStore.instance.aplicarPrecio(p.id, precio);
        mensajeProductor(context, 'Precio actualizado localmente (API fallback).');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        // Find local, else use passed from API
        final p = store.producto(producto.id) ?? producto;
        if (p == null)
          return const ProductorPage(
            title: 'Detalle del producto',
            children: [
              ProductorEmpty(
                'Este producto no está disponible en el inventario.',
              ),
            ],
          );
        return ProductorPage(
          title: 'Detalle del producto',
          actions: [
            IconButton(
              tooltip: 'Copiar información',
              icon: const Icon(Icons.copy_outlined),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text:
                        '${p.nombre}\n${p.precioTexto}\n${store.finca.nombre}',
                  ),
                );
                if (context.mounted)
                  mensajeProductor(context, 'Información copiada.');
              },
            ),
          ],
          children: [
            ProductorImage(
              url: p.imagenUrl,
              bytes: p.fotos.isEmpty ? null : p.fotos.first,
              height: 220,
            ),
            const SizedBox(height: 20),
            Text(p.nombre, style: AppTextStyles.Title),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ProductorStatus(
                  p.estado.label,
                  warning: p.estado != EstadoProducto.disponible,
                ),
                if (!p.publicado)
                  const ProductorStatus('No publicado', warning: true),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${dinero(store.precioActual(p))} / ${p.unidad}',
              style: AppTextStyles.price,
            ),
            const SizedBox(height: 16),
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventario: ${p.cantidadTexto}'),
                  const SizedBox(height: 12),
                  Text('Categoría: ${p.categoria}'),
                  const SizedBox(height: 12),
                  Text(
                    'Cosecha: ${p.fechaCosecha == null ? p.cosecha ?? 'Sin registrar' : fechaCorta(p.fechaCosecha!)}',
                  ),
                  const SizedBox(height: 12),
                  Text(store.finca.ubicacion),
                  if (p.descripcion?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 16),
                    Text(p.descripcion!),
                  ],
                ],
              ),
            ),
            const ProductorSection('Costos y precio'),
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Costo por ${p.unidad}: ${dinero(p.costoProduccion)}'),
                  const SizedBox(height: 12),
                  Text(
                    'Ganancia por unidad: ${dinero(p.precio - p.costoProduccion)}',
                  ),
                  const SizedBox(height: 16),
                  ProductorButton(
                    label: 'Calcular precio justo',
                    outlined: true,
                    onPressed: () => _calcular(context, p),
                  ),
                ],
              ),
            ),
            ProductorButton(
              label: 'Editar producto',
              icon: Icons.edit_outlined,
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.agregarProducto,
                arguments: p,
              ),
            ),
            const SizedBox(height: 12),
            ProductorButton(
              label: 'Actualizar inventario',
              outlined: true,
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.registroCosecha,
                arguments: p,
              ),
            ),
            const SizedBox(height: 12),
            ProductorButton(
              label: 'Crear oferta',
              outlined: true,
              onPressed: p.cantidad <= 0
                  ? null
                  : () => Navigator.pushNamed(
                      context,
                      AppRoutes.crearOferta,
                      arguments: p,
                    ),
            ),
          ],
        );
      },
    );
  }
}
