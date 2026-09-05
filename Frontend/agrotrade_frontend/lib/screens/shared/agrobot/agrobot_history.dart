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

/// Pantalla de hstorial de AgroBot.
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
      // AgroBot -> ir a bienvenida
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
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFF3F6F4),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.only(top: 4),
              child: ClipOval(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'lib/assets/images/Agrobot/assets_preview_rev_1.png',
                    fit: BoxFit.contain,
                    width: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AgroBot',
              style: AppTextStyles.Title.copyWith(
                fontSize: 18,
                color: AppColors.titleDark,
                fontWeight: FontWeight.w700,
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

            //Lista de conversaciones
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

// Tarjeta de conversación del historial.
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la tarjeta
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  item.titulo,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                item.fecha,
                style: AppTextStyles.SubTitle.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // descripcion
          Text(
            item.descripcion,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // botón Continuar
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onContinuar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF064E3B), 
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Continuar',
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF064E3B),
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
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin historial aún',
            style: AppTextStyles.headline.copyWith(
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus conversaciones con AgroBot\naparecerán aquí.',
            textAlign: TextAlign.center,
            style: AppTextStyles.SubTitle.copyWith(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
