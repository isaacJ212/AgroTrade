import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../services/productor_store.dart';
import '../../routes/app_routes.dart';
import '../../routes/productor_navigation.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/productor_widgets.dart';
import 'productorShell.dart';

class PerfilFinca extends StatelessWidget {
  final bool embedded;
  const PerfilFinca({super.key, this.embedded = false});
  @override
  Widget build(BuildContext context) {
    if (!embedded) return const ProductorShell(initialIndex: 3);
    final store = ProductorStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final f = store.finca;
        final persona = store.persona;
        final publicados = store.productos
            .where((p) => p.publicado && p.cantidad > 0)
            .length;
        return ProductorPage(
          title: 'Mi perfil',
          rootIndex: 3,
          children: [
            ProductorCard(
              child: Column(
                children: [
                  ClipOval(
                    child: ProductorImage(
                      bytes: persona.foto,
                      width: 80,
                      height: 80,
                      icon: Icons.person,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(persona.nombre, style: AppTextStyles.Title),
                  const SizedBox(height: 10),
                  const ProductorStatus(
                    'Productor verificado',
                    icon: Icons.verified_outlined,
                  ),
                  const SizedBox(height: 14),
                  Text(f.nombre, style: AppTextStyles.productoTitle),
                  const SizedBox(height: 6),
                  Text(
                    f.ubicacion,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.SubTitle,
                  ),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.star, color: AppColors.amber, size: 18),
                      Text('4.8 · 32 valoraciones'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ProductorButton(
                    label: 'Editar perfil',
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/productor/datos-personales',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProductorButton(
                    label: 'Ver perfil público',
                    outlined: true,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      '/productor/perfil-publico',
                    ),
                  ),
                ],
              ),
            ),
            ProductorCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductorSection('Sobre la finca'),
                  Text(f.descripcion, style: AppTextStyles.SubTitle),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 20,
                    runSpacing: 14,
                    children: [
                      Text('Teléfono: ${persona.telefono}'),
                      Text('Productos: $publicados publicados'),
                      Text('Tamaño: ${numero(f.hectareas)} hectáreas'),
                      Text('Cultivo: ${f.cultivo}'),
                    ],
                  ),
                ],
              ),
            ),
            ProductorCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ProductorMenuItem(
                    label: 'Datos personales',
                    icon: Icons.person_outline,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/productor/datos-personales',
                    ),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Información de la finca',
                    icon: Icons.agriculture_outlined,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.editarFinca),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Configuración',
                    icon: Icons.settings_outlined,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/productor/configuracion',
                    ),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Cambiar contraseña',
                    icon: Icons.lock_outline,
                    onTap: () =>
                        Navigator.pushNamed(context, '/productor/contrasena'),
                  ),
                  const Divider(height: 1),
                  ProductorMenuItem(
                    label: 'Centro de ayuda',
                    icon: Icons.help_outline,
                    onTap: () =>
                        Navigator.pushNamed(context, '/productor/ayuda'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ProductorButton(
              label: 'Cerrar sesión',
              outlined: true,
              danger: true,
              icon: Icons.logout,
              onPressed: () => ProductorNavigation.cerrarSesion(context),
            ),
          ],
        );
      },
    );
  }
}
