import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';

enum _EstadoSuscripcion { activa, pausada, cancelada }

class _SuscripcionItem {
  final int id;
  final String titulo;
  final String? finca;
  final String frecuencia;
  final String? proximaEntrega;
  final _EstadoSuscripcion estado;
  final IconData icono;

  const _SuscripcionItem({
    required this.id,
    required this.titulo,
    this.finca,
    required this.frecuencia,
    this.proximaEntrega,
    required this.estado,
    required this.icono,
  });
}

class SuscripcionesScreen extends StatefulWidget {
  const SuscripcionesScreen({super.key});

  @override
  State<SuscripcionesScreen> createState() => _SuscripcionesScreenState();
}

class _SuscripcionesScreenState extends State<SuscripcionesScreen> {
  final List<_SuscripcionItem> _suscripciones = [
    const _SuscripcionItem(
      id: 1,
      titulo: 'Canasta semanal',
      finca: 'Finca La Esperanza',
      frecuencia: 'Entrega cada semana',
      proximaEntrega: '13 de agosto',
      estado: _EstadoSuscripcion.activa,
      icono: Icons.shopping_basket_outlined,
    ),
    const _SuscripcionItem(
      id: 2,
      titulo: 'Frutas para el hogar',
      finca: null,
      frecuencia: 'Entrega cada 15 días',
      proximaEntrega: null,
      estado: _EstadoSuscripcion.pausada,
      icono: Icons.eco_outlined,
    ),
  ];

  void _crearSuscripcion() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Crear nueva suscripción (próximamente)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _administrarSuscripcion(_SuscripcionItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Administrar: ${item.titulo}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerIntro(),
            const SizedBox(height: 24),
            const Text(
              'Mis suscripciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 12),
            ..._suscripciones.map((sub) => _buildSuscripcionCard(sub)),
            const SizedBox(height: 8),
            _buildCrearNuevaCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Suscripciones',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 17,
            backgroundColor: AppColors.primarySoftBg,
            child: Icon(
              Icons.person_outline_rounded,
              size: 20,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.autorenew_rounded,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Entregas automáticas',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Programá compras frecuentes para recibir productos frescos de forma recurrente sin preocuparte por ordenar cada vez.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.TextSoft,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuscripcionCard(_SuscripcionItem sub) {
    final bool isActiva = sub.estado == _EstadoSuscripcion.activa;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActiva
              ? AppColors.primaryColor.withOpacity(0.3)
              : AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isActiva
                ? AppColors.primaryColor.withOpacity(0.04)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActiva
                        ? AppColors.primarySoftBg
                        : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    sub.icono,
                    color: isActiva ? AppColors.primaryColor : AppColors.chipGrey,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sub.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.titleDark,
                              ),
                            ),
                          ),
                          _buildBadge(sub.estado),
                        ],
                      ),
                      if (sub.finca != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          sub.finca!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.TextSoft,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.TextSoft,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sub.frecuencia,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.TextSoft,
                            ),
                          ),
                        ],
                      ),
                      if (sub.proximaEntrega != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 13,
                              color: AppColors.primaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Próxima: ${sub.proximaEntrega}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
          InkWell(
            onTap: () => _administrarSuscripcion(sub),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              child: Text(
                isActiva ? 'Administrar' : 'Reactivar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActiva ? AppColors.primaryColor : const Color(0xFFD97706),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(_EstadoSuscripcion estado) {
    Color bg;
    Color fg;
    String label;

    switch (estado) {
      case _EstadoSuscripcion.activa:
        bg = AppColors.primarySoftBg;
        fg = AppColors.primaryColor;
        label = 'Activa';
        break;
      case _EstadoSuscripcion.pausada:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFD97706);
        label = 'Pausada';
        break;
      case _EstadoSuscripcion.cancelada:
        bg = const Color(0xFFF3F4F6);
        fg = AppColors.chipGrey;
        label = 'Cancelada';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildCrearNuevaCard() {
    return InkWell(
      onTap: _crearSuscripcion,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoftBg,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Crear nueva',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elegí productos, frecuencia y modalidad de entrega.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.TextSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
