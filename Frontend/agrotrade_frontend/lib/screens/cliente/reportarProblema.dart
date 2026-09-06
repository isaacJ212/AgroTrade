import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../services/consumer_api_service.dart';

class ReportarProblemaScreen extends StatefulWidget {
  const ReportarProblemaScreen({super.key});

  @override
  State<ReportarProblemaScreen> createState() => _ReportarProblemaScreenState();
}

class _ReportarProblemaScreenState extends State<ReportarProblemaScreen> {
  String _tipoProblema = 'Pedido no entregado';
  final _detallesController = TextEditingController();

  @override
  void dispose() {
    _detallesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Reportar Problema', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Qué sucedió con tu pedido?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleDark),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _tipoProblema,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.TextSoft),
                  items: ['Pedido no entregado', 'Producto dañado', 'Faltan productos', 'Otro']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _tipoProblema = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalles del problema',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.titleDark),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _detallesController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Explica brevemente lo sucedido...',
                hintStyle: const TextStyle(color: AppColors.TextSoft),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Adjuntar imágenes (Opcional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.titleDark),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.5), style: BorderStyle.solid),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: AppColors.primaryColor, size: 32),
                    SizedBox(height: 8),
                    Text('Subir foto', style: TextStyle(color: AppColors.primaryColor, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            // Simulamos el ID del pedido (debería venir por parámetro en un caso real)
            final idPedidoSimulado = 1045;
              
              // Evitar doble submit mostrando un loader si se quisiera,
              // aquí usamos un SnackBar para informar que inicia
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enviando reporte al servidor...'), duration: Duration(seconds: 1)),
              );

              final success = await ConsumerApiService.instance.reportarProblema(
                idPedidoSimulado, 
                _tipoProblema, 
                _detallesController.text,
              );

              if (!context.mounted) return;

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reporte enviado con éxito'), backgroundColor: Colors.green),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al enviar el reporte'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Enviar Reporte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
