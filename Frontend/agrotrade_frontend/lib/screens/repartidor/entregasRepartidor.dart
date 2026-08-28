import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import 'detalleEntregaRepartidor.dart';
import 'entregaEnCursoRepartidor.dart';
import 'homeRepartidor.dart';
import 'rutaEntregaRepartidor.dart';

class Entregasrepartidor extends StatelessWidget {
  const Entregasrepartidor({super.key});

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_EntregaItem>[
      const _EntregaItem(
        pedidoId: '#AT-2051',
        estado: _EntregaEstado.pendiente,
        titulo: 'Finca La Esperanza',
        horaEstimada: '10:30 a. m.',
        recogida: 'Finca La Esperanza',
        destino: 'Jinotepe',
        color: Color(0xFFF9A825),
      ),
      const _EntregaItem(
        pedidoId: '#AT-2052',
        estado: _EntregaEstado.enCurso,
        titulo: 'Cooperativa Los Andes',
        horaEstimada: '10:30 a. m.',
        recogida: 'Cooperativa Los Andes',
        destino: 'Diriamba',
        color: Color(0xFF005DB7),
        recogidaTachada: true,
      ),
      const _EntregaItem(
        pedidoId: '#AT-2047',
        estado: _EntregaEstado.completada,
        titulo: 'María López',
        horaEstimada: '9:15 a. m.',
        recogida: 'Entregada a María López (Firma registrada)',
        destino: '',
        color: Color(0xFF6F7A6D),
      ),
    ];

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceAlt,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const InicioRepartidor()),
            ),
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
          ),
          title: const Text(
            'Entregas',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _showSnack(context, 'Notificaciones'),
              icon: const Icon(
                Icons.notifications_outlined,
                color: AppColors.bodyText,
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: _DeliveryTabs(),
          ),
        ),
        body: TabBarView(
          children: [
            _DeliveryList(
              items: items,
              onTapPending: () => _go(context, const DetalleEntregaRepartidor()),
              onTapActive: () => _go(context, const EntregaEnCursoRepartidor()),
            ),
            _DeliveryList(
              items: items.where((item) => item.estado == _EntregaEstado.pendiente).toList(),
              onTapPending: () => _go(context, const DetalleEntregaRepartidor()),
              onTapActive: () => _go(context, const EntregaEnCursoRepartidor()),
            ),
            _DeliveryList(
              items: items.where((item) => item.estado == _EntregaEstado.enCurso).toList(),
              onTapPending: () => _go(context, const DetalleEntregaRepartidor()),
              onTapActive: () => _go(context, const EntregaEnCursoRepartidor()),
            ),
            _DeliveryList(
              items: items.where((item) => item.estado == _EntregaEstado.completada).toList(),
              onTapPending: () => _go(context, const DetalleEntregaRepartidor()),
              onTapActive: () => _go(context, const EntregaEnCursoRepartidor()),
            ),
          ],
        ),
        bottomNavigationBar: RepartidorBottomNav(
          currentIndex: 1,
          onTap: (index) {
            if (index == 1) return;
            if (index == 0) {
              _go(context, const InicioRepartidor());
              return;
            }
            if (index == 2) {
              _go(context, const RutaEntregaRepartidor());
              return;
            }
            _showSnack(context, 'Perfil disponible pronto');
          },
        ),
      ),
    );
  }
}

class _DeliveryTabs extends StatelessWidget {
  const _DeliveryTabs();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      isScrollable: true,
      indicatorColor: AppColors.primaryColor,
      indicatorWeight: 2.5,
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.bodyText,
      labelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      tabs: [
        Tab(text: 'Todas'),
        Tab(text: 'Pendientes'),
        Tab(text: 'En curso'),
        Tab(text: 'Completadas'),
      ],
    );
  }
}

class _DeliveryList extends StatelessWidget {
  final List<_EntregaItem> items;
  final VoidCallback onTapPending;
  final VoidCallback onTapActive;

  const _DeliveryList({
    required this.items,
    required this.onTapPending,
    required this.onTapActive,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text('Sin entregas aquí 🎉', style: AppTextStyles.SubTitle),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        return _DeliveryCard(
          item: item,
          onTapPending: onTapPending,
          onTapActive: onTapActive,
        );
      },
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final _EntregaItem item;
  final VoidCallback onTapPending;
  final VoidCallback onTapActive;

  const _DeliveryCard({
    required this.item,
    required this.onTapPending,
    required this.onTapActive,
  });

  @override
  Widget build(BuildContext context) {
    final bool pending = item.estado == _EntregaEstado.pendiente;
    final bool active = item.estado == _EntregaEstado.enCurso;
    final bool completed = item.estado == _EntregaEstado.completada;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(completed ? 0.75 : 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Tag(
                              background: const Color(0xFFE1E3E4),
                              text: item.pedidoId,
                              textColor: AppColors.bodyText,
                            ),
                            const SizedBox(width: 8),
                            _Tag(
                              background: item.estadoBackground,
                              text: item.estadoLabel,
                              textColor: item.color,
                              leadingIcon: item.estadoIcon,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.titulo,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 24,
                            color: completed ? AppColors.bodyText : AppColors.titleDark,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hora est.',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.horaEstimada,
                          style: AppTextStyles.label.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _RouteRow(
                        icon: Icons.location_on_outlined,
                        title: 'Recogida',
                        value: item.recogida,
                        muted: active,
                        crossed: active && item.recogidaTachada,
                      ),
                      const SizedBox(height: 10),
                      const _ConnectorLine(),
                      const SizedBox(height: 10),
                      _RouteRow(
                        icon: Icons.flag_outlined,
                        title: 'Destino',
                        value: item.destino,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (pending)
                  Align(
                    alignment: Alignment.centerRight,
                    child: _OutlinedActionButton(
                      label: 'Ver detalle',
                      onTap: onTapPending,
                    ),
                  )
                else if (active)
                  Align(
                    alignment: Alignment.centerRight,
                    child: _FilledActionButton(
                      label: 'Continuar entrega',
                      onTap: onTapActive,
                    ),
                  )
                else
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, size: 16, color: AppColors.bodyText),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Entregada a María López (Firma registrada)',
                          style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final Color background;
  final Color textColor;
  final String text;
  final IconData? leadingIcon;

  const _Tag({
    required this.background,
    required this.textColor,
    required this.text,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: 11, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool muted;
  final bool crossed;

  const _RouteRow({
    required this.icon,
    required this.title,
    required this.value,
    this.muted = false,
    this.crossed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  color: muted ? AppColors.bodyText : AppColors.titleDark,
                  decoration: crossed ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  const _ConnectorLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 1,
          height: 16,
          child: ColoredBox(color: AppColors.cardBorder),
        ),
      ),
    );
  }
}

class _FilledActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FilledActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accentBlue),
          foregroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

enum _EntregaEstado { pendiente, enCurso, completada }

class _EntregaItem {
  final String pedidoId;
  final _EntregaEstado estado;
  final String titulo;
  final String horaEstimada;
  final String recogida;
  final String destino;
  final Color color;
  final bool recogidaTachada;

  const _EntregaItem({
    required this.pedidoId,
    required this.estado,
    required this.titulo,
    required this.horaEstimada,
    required this.recogida,
    required this.destino,
    required this.color,
    this.recogidaTachada = false,
  });

  String get estadoLabel {
    switch (estado) {
      case _EntregaEstado.pendiente:
        return 'Pendiente';
      case _EntregaEstado.enCurso:
        return 'En curso';
      case _EntregaEstado.completada:
        return 'Completada';
    }
  }

  Color get estadoBackground {
    switch (estado) {
      case _EntregaEstado.pendiente:
        return const Color(0xFFFFF4D6);
      case _EntregaEstado.enCurso:
        return const Color(0xFFDDEBFF);
      case _EntregaEstado.completada:
        return const Color(0xFFE7E8E9);
    }
  }

  IconData get estadoIcon {
    switch (estado) {
      case _EntregaEstado.pendiente:
        return Icons.schedule;
      case _EntregaEstado.enCurso:
        return Icons.local_shipping_outlined;
      case _EntregaEstado.completada:
        return Icons.check_circle_outline;
    }
  }
}
