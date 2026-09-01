import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';

class FormularioDireccionScreen extends StatefulWidget {
  const FormularioDireccionScreen({super.key});

  @override
  State<FormularioDireccionScreen> createState() => _FormularioDireccionScreenState();
}

class _FormularioDireccionScreenState extends State<FormularioDireccionScreen> {
  String _tipoDireccion = 'Casa';
  final _calleController = TextEditingController();
  final _referenciaController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void dispose() {
    _calleController.dispose();
    _referenciaController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Nueva Dirección', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mapa minimizado visualmente
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Managua,Nicaragua&zoom=14&size=400x200&sensor=false'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Icon(Icons.location_on, size: 48, color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text('Dirección exacta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildTextField(_calleController, 'Ej. Barrio San Judas, Casa #123', Icons.map),
            
            const SizedBox(height: 16),
            const Text('Punto de referencia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildTextField(_referenciaController, 'Ej. Frente a la farmacia...', Icons.storefront),
            
            const SizedBox(height: 16),
            const Text('Teléfono de contacto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildTextField(_telefonoController, '+505 0000 0000', Icons.phone, TextInputType.phone),
            
            const SizedBox(height: 24),
            const Text('Guardar como', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTagOption('Casa', Icons.home),
                const SizedBox(width: 12),
                _buildTagOption('Trabajo', Icons.work),
                const SizedBox(width: 12),
                _buildTagOption('Otro', Icons.location_on),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dirección guardada exitosamente')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Guardar Dirección', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, [TextInputType type = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.TextSoft),
        prefixIcon: Icon(icon, color: AppColors.TextSoft),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryColor, width: 2)),
      ),
    );
  }

  Widget _buildTagOption(String label, IconData icon) {
    final isSelected = _tipoDireccion == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipoDireccion = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryColor : AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.TextMain),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.TextMain,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
