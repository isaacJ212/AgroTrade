import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'misPedidos.dart';
import '../../services/consumer_api_service.dart';

class ValorarPedidoScreen extends StatefulWidget {
  final int idPedido;
  final int idProveedor;

  const ValorarPedidoScreen({
    super.key,
    required this.idPedido,
    required this.idProveedor,
  });

  @override
  State<ValorarPedidoScreen> createState() => _ValorarPedidoScreenState();
}

class _ValorarPedidoScreenState extends State<ValorarPedidoScreen> {
  int _estrellaCalidad = 0;
  int _estrellaProductor = 0;
  int _estrellaEntrega = 0;

  final Set<String> _destacados = {'Precio justo'};

  final TextEditingController _comentarioCtrl = TextEditingController();
  bool _isSubmitting = false;

  static const List<String> _chips = [
    'Productos frescos',
    'Buena atención',
    'Entrega puntual',
    'Precio justo',
  ];

  @override
  void dispose() {
    _comentarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviarValoracion() async {
    // Calculamos un promedio básico de las 3 estrellas para enviarlo al backend, o mandamos 1 si no marcaron
    int promedio = ((_estrellaCalidad + _estrellaProductor + _estrellaEntrega) / 3).round();
    if (promedio == 0) promedio = 1;

    // Juntamos los destacados con el comentario
    String comentarioFinal = _comentarioCtrl.text.trim();
    if (_destacados.isNotEmpty) {
      final tags = _destacados.join(', ');
      comentarioFinal = "Destacados: $tags. $comentarioFinal";
    }

    setState(() => _isSubmitting = true);

    try {
      print('DEBUG: [ValorarPedido] Enviando valoración para Pedido ID: ${widget.idPedido}, Proveedor ID: ${widget.idProveedor}');
      final success = await ConsumerApiService.instance.valorarPedido(
        idPedido: widget.idPedido,
        idProveedor: widget.idProveedor,
        puntuacion: promedio,
        comentario: comentarioFinal,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Gracias por tu valoración!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al enviar la valoración. Inténtalo de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MisPedidosScreen()),
              );
            }
          },
        ),
        title: const Text(
          'Valorar pedido',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge número de pedido
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pedido #AT-${widget.idPedido}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Contanos cómo fue tu\nexperiencia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleDark,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Tu opinión ayuda a mantener la calidad y confianza en\nnuestra comunidad agrícola.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.TextSoft,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildCriterios(),
                  const SizedBox(height: 28),

                  _buildDestacados(),
                  const SizedBox(height: 24),
                  _buildComentario(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCriterios() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          _FilaEstrellas(
            label: 'Calidad de los productos',
            valor: _estrellaCalidad,
            onChanged: (v) => setState(() => _estrellaCalidad = v),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          _FilaEstrellas(
            label: 'Experiencia con el productor',
            valor: _estrellaProductor,
            onChanged: (v) => setState(() => _estrellaProductor = v),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.cardBorder),
          ),
          _FilaEstrellas(
            label: 'Entrega',
            valor: _estrellaEntrega,
            onChanged: (v) => setState(() => _estrellaEntrega = v),
          ),
        ],
      ),
    );
  }

  Widget _buildDestacados() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué destacarías?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.titleDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _chips.map((chip) {
            final bool sel = _destacados.contains(chip);
            return GestureDetector(
              onTap: () => setState(() {
                sel ? _destacados.remove(chip) : _destacados.add(chip);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primarySoftBg : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sel
                        ? AppColors.primaryColor
                        : const Color(0xFFCDD5D1),
                    width: sel ? 1.5 : 1.2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (sel) ...[
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      chip,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                        color: sel
                            ? AppColors.primaryColor
                            : AppColors.TextMain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildComentario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comentario (Opcional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.TextSoft,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _comentarioCtrl,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Escribe tu experiencia...',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.chipGrey),
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: AppColors.scaffoldBg,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE4E7E5), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isSubmitting
                ? const CircularProgressIndicator(color: AppColors.primaryColor)
                : PrimaryButton(
                    label: 'Enviar valoración',
                    radius: 100,
                    onPressed: _enviarValoracion,
                  ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Ahora no',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaEstrellas extends StatelessWidget {
  final String label;
  final int valor;
  final ValueChanged<int> onChanged;

  const _FilaEstrellas({
    required this.label,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.titleDark,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            final filled = i < valor;
            return GestureDetector(
              onTap: () => onChanged(i + 1),
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_outline_rounded,
                    key: ValueKey(filled),
                    size: 32,
                    color: filled
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCDD5D1),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
