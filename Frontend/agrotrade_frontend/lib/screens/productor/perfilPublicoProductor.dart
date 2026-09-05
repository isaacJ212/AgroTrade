import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/productor_widgets.dart';
import '../../models/Consumidor/consumidor_models.dart' show ProductorDestacado;
import '../cliente/perfilProductor.dart';

class PerfilPublicoProductor extends StatelessWidget {
  const PerfilPublicoProductor({super.key});
  @override
  Widget build(BuildContext context) {
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final f = store.finca;
        final productos = store.productos
            .where((p) => p.publicado && p.cantidad > 0)
            .toList();
        return PerfilProductorScreen(
          soloLectura: true,
          portadaBytes: f.foto,
          productor: ProductorDestacado(
            nombre: f.nombre,
            ubicacion: f.ubicacion,
            descripcion: f.descripcion,
            avatarUrl: f.portadaUrl,
            portadaUrl: f.portadaUrl,
            rating: 4.8,
            ventas: store.pedidos
                .where((p) => p.estado == EstadoPedido.listo)
                .length,
            verificado: true,
          ),
          productosContenido: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProductorSection('Productos disponibles'),
                if (productos.isEmpty)
                  const ProductorEmpty('Todavía no hay productos disponibles.'),
                for (final p in productos)
                  ProductorCard(
                    child: InkWell(
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (sheet) => SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductorImage(
                                  url: p.imagenUrl,
                                  bytes: p.fotos.isEmpty ? null : p.fotos.first,
                                ),
                                const SizedBox(height: 16),
                                Text(p.nombre, style: AppTextStyles.Title),
                                const SizedBox(height: 10),
                                Text(
                                  '${dinero(store.precioActual(p))} / ${p.unidad}',
                                  style: AppTextStyles.statValue,
                                ),
                                const SizedBox(height: 12),
                                Text(p.descripcion ?? ''),
                                const SizedBox(height: 16),
                                ProductorButton(
                                  label: 'Volver',
                                  outlined: true,
                                  onPressed: () => Navigator.pop(sheet),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductorImage(
                            url: p.imagenUrl,
                            bytes: p.fotos.isEmpty ? null : p.fotos.first,
                          ),
                          const SizedBox(height: 12),
                          Text(p.nombre, style: AppTextStyles.productoTitle),
                          const SizedBox(height: 8),
                          Text(
                            '${dinero(store.precioActual(p))} / ${p.unidad}',
                            style: AppTextStyles.statValue,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
