import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_session.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

/// Modelo de un ítem del historial de AgroBot.
class _HistorialItem {
  final String titulo;
  final String fecha;
  final String descripcion;

  const _HistorialItem({
    required this.titulo,
    required this.fecha,
    required this.descripcion,
  });
}

/// Pantalla de Historial de AgroBot.
/// Muestra las conversaciones previas del usuario con AgroBot.
/// Accesible para todos los roles.
class AgrobotHistory extends StatelessWidget {
  const AgrobotHistory({super.key});

  static const List<_HistorialItem> _historial = [
    _HistorialItem(
      titulo: 'Actualizar...',
      fecha: 'Hoy · 4:25 p. m.',
      descripcion: 'Desde Inventario, seleccioná el producto...',
    ),
    _HistorialItem(
      titulo: 'Precio Justo',
      fecha: '01 de septiembre',
      descripcion: 'Podés calcular un precio sugerido...',
    ),
    _HistorialItem(
      titulo: 'Estado de un pedido',
      fecha: '30 de agosto',
      descripcion: 'Podés consultar el seguimiento desde...',
    ),
  ];

  void _onNavTap(BuildContext context, int index) {
    if (index == 2) {
      // AgroBot → ir a Bienvenida
      Navigator.pushReplacementNamed(context, AppRoutes.agrobotWelcome);
      return;
    }
    final roles = ApiSession.instance.roles;
    if (index == 0) {
      if (roles.contains('Productor/Proveedor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
      } else if (roles.contains('Repartidor')) {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
      }
    } else if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.explorarProductos);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.White,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 34,
              height: 34,
              child: Image.asset(
                'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AgroBot',
              style: AppTextStyles.headline.copyWith(
                fontSize: 18,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
            // ── Encabezado ────────────────────────────────────────────────
            Text(
              'Historial de AgroBot',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Revisá tus consultas anteriores.',
              style: AppTextStyles.SubTitle.copyWith(
                fontSize: 14,
                color: AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 24),

            // ── Lista de conversaciones ───────────────────────────────────
            if (_historial.isEmpty)
              _EmptyHistorial()
            else
              ...List.generate(_historial.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _HistorialCard(
                    item: _historial[index],
                    onContinuar: () => Navigator.pushNamed(
                      context,
                      AppRoutes.agrobotChat,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: const AgrobotBottomNav(),
    );
  }
}

/// Tarjeta de conversación del historial.
class _HistorialCard extends StatelessWidget {
  final _HistorialItem item;
  final VoidCallback onContinuar;

  const _HistorialCard({
    required this.item,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Encabezado de la tarjeta ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  item.titulo,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                item.fecha,
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 12,
                  color: AppColors.bodyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Descripción ──────────────────────────────────────────────
          Text(
            item.descripcion,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 13,
              color: AppColors.bodyText,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // ── Botón Continuar ──────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onContinuar,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: BorderSide(
                  color: AppColors.primaryColor.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Continuar',
                style: AppTextStyles.label.copyWith(
                  fontSize: 13,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Estado vacío cuando no hay historial.
class _EmptyHistorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin historial aún',
            style: AppTextStyles.headline.copyWith(
              fontSize: 16,
              color: AppColors.titleDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus conversaciones con AgroBot\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 14,
              color: AppColors.bodyText,
            ),
          ),
        ],
      ),
    );
  }
}
