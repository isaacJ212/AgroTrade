import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import 'repartidor_demo.dart';
import 'repartidor_navigation.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class InicioRepartidor extends StatelessWidget {
  const InicioRepartidor({super.key});

  String get _saludo {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Buenos días';
    if (hora < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final demo = RepartidorDemo.instance;
    final nombre = ApiSession.instance.userName?.trim();
    return AnimatedBuilder(
      animation: demo,
      builder: (context, _) {
        final pendientes = demo.porEstado(EstadoEntregaDemo.pendiente);
        final enCurso = demo.porEstado(EstadoEntregaDemo.enCurso);
        final completadas = demo.porEstado(EstadoEntregaDemo.completada);
        return RepartidorTheme(
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 80,
              backgroundColor: AppColors.White,
              surfaceTintColor: Colors.transparent,
              title: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.navPill,
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
                        Text(_saludo, style: RepartidorTextStyles.SubTitle),
                        const SizedBox(height: 4),
                        Text(
                          nombre == null || nombre.isEmpty
                              ? 'Juan Pérez'
                              : nombre,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: RepartidorTextStyles.Title.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Notificaciones',
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.bodyText,
                  ),
                  onPressed: () => mostrarInfoRepartidor(
                    context,
                    'Tus entregas',
                    'Tienes ${pendientes.length} entregas pendientes y '
                        '${enCurso.length} en curso.',
                  ),
                ),
              ],
            ),
            body: SafeArea(
              top: false,
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Resumen de hoy',
                    style: RepartidorTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  MetricasRepartidor(
                    etiquetas: const ['Pendientes', 'En curso', 'Completadas'],
                    valores: [
                      '${pendientes.length}',
                      '${enCurso.length}',
                      '${completadas.length}',
                    ],
                    iconos: const [
                      Icons.pending_actions_outlined,
                      Icons.local_shipping_outlined,
                      Icons.check_circle_outline,
                    ],
                  ),
                  const SizedBox(height: 16),
                  RepartidorCard(
                    color: AppColors.primarySoftBg,
                    child: DatoRepartidor(
                      icon: Icons.account_balance_wallet_outlined,
                      titulo: 'Ganancias de entregas completadas hoy',
                      valor: dineroRepartidor(demo.ganancias),
                    ),
                  ),
                  if (enCurso.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Continúa tu entrega',
                      style: RepartidorTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 12),
                    EntregaDemoCard(entrega: enCurso.first),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Entregas pendientes',
                    style: RepartidorTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 12),
                  if (pendientes.isEmpty)
                    const RepartidorCard(
                      child: DatoRepartidor(
                        icon: Icons.check_circle_outline,
                        titulo: 'Todo al día',
                        valor: 'No tienes entregas pendientes.',
                      ),
                    ),
                  for (final entrega in pendientes) ...[
                    EntregaDemoCard(entrega: entrega),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            bottomNavigationBar: RepartidorBottomNav(
              currentIndex: 0,
              onTap: (index) => navegarRepartidor(context, 0, index),
            ),
          ),
        );
      },
    );
  }
}
