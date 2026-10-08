import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import 'confirmarEntregaRepartidor.dart';
import 'rutaEntregaRepartidor.dart';
import 'recogerPedidoRepartidor.dart';

class EntregaEnCursoRepartidor extends StatefulWidget {
  final int? pedidoId;
  const EntregaEnCursoRepartidor({super.key, this.pedidoId});

  @override
  State<EntregaEnCursoRepartidor> createState() =>
      _EntregaEnCursoRepartidorState();
}

class _EntregaEnCursoRepartidorState extends State<EntregaEnCursoRepartidor> {
  bool _recogido = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(
          'Entrega #AT-${widget.pedidoId ?? '—'}',
          style: AppTextStyles.Title,
        ),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header con estado
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x4D006E2C)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _recogido
                        ? AppColors.primaryColor
                        : AppColors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _recogido ? Icons.local_shipping : Icons.pending_actions,
                    color: _recogido ? Colors.white : AppColors.amber,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entrega #AT-${widget.pedidoId ?? '—'}',
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _recogido
                              ? AppColors.primaryColor.withValues(alpha: 0.15)
                              : AppColors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _recogido
                                ? AppColors.primaryColor
                                : AppColors.amber,
                          ),
                        ),
                        child: Text(
                          _recogido ? 'En camino' : 'Pendiente de recogida',
                          style: AppTextStyles.chip.copyWith(
                            color: _recogido
                                ? AppColors.primaryColor
                                : AppColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Mapa (placeholder)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text('Mapa de ruta', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 4),
                  Text(
                    'El mapa se cargará cuando el backend exponga el endpoint de ruta',
                    style: AppTextStyles.SubTitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Progreso
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso de la entrega',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 16),
                _Paso(titulo: 'Entrega aceptada', completo: true),
                _Paso(titulo: 'Pedido recogido', completo: _recogido),
                _Paso(titulo: 'En camino', completo: false, activo: _recogido),
                _Paso(titulo: 'Entregado', completo: false),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Información básica
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información de la entrega',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Destino',
                  value: '—',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Destinatario',
                  value: '—',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.storefront_outlined,
                  label: 'Punto de recogida',
                  value: '—',
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.schedule_outlined,
                  label: 'Hora estimada',
                  value: '—',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nota
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoftBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x4D006E2C)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nota', style: AppTextStyles.label),
                const SizedBox(height: 8),
                Text(
                  'La información detallada (ruta, cliente, indicaciones) se cargará cuando el backend exponga el endpoint de detalle de entrega.',
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botones de acción dinámicos (Recoger / Llegué al destino)
          ..._buildActionButtons(context),
          const SizedBox(height: 12),

          // Botón Ver ruta
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      RutaEntregaRepartidor(pedidoId: widget.pedidoId),
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
                side: const BorderSide(color: AppColors.accentBlue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Ver ruta',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón Información de contacto
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _mostrarInfoContacto(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.TextSoft,
                side: const BorderSide(color: AppColors.TextSoft, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Información de contacto',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botón Reportar problema
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _reportarProblema(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.errorColor,
                side: const BorderSide(color: AppColors.errorColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Reportar problema',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarInfoContacto(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Información de contacto'),
        content: const Text('Información no disponible en esta versión.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _reportarProblema(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reportar problema'),
        content: const Text('La opción de reportes aún no está disponible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    if (!_recogido) {
      return [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RecogerPedidoRepartidor(pedidoId: widget.pedidoId),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Verificar recogida',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ];
    } else {
      return [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ConfirmarEntregaRepartidor(pedidoId: widget.pedidoId),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Llegué al destino',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ];
    }
  }
}

class _Paso extends StatelessWidget {
  final String titulo;
  final bool completo;
  final bool activo;
  const _Paso({
    required this.titulo,
    this.completo = false,
    this.activo = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: completo || activo
              ? AppColors.navPill
              : AppColors.surfaceAlt,
          child: Icon(
            completo
                ? Icons.check
                : activo
                ? Icons.local_shipping
                : Icons.circle_outlined,
            size: 17,
            color: completo || activo
                ? AppColors.primaryColor
                : AppColors.TextSoft,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            titulo,
            style: AppTextStyles.label.copyWith(
              color: activo ? AppColors.primaryColor : AppColors.TextMain,
            ),
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.label.copyWith(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
