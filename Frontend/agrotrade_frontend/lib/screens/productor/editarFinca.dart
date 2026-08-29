import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/inputs.dart';

class EditarFincaScreen extends StatefulWidget {
  const EditarFincaScreen({super.key});

  @override
  State<EditarFincaScreen> createState() => _EditarFincaScreenState();
}

class _EditarFincaScreenState extends State<EditarFincaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController(text: 'Finca El Encanto');
  final _tamanoCtrl = TextEditingController(text: '15');
  final _ubicacionCtrl = TextEditingController(text: 'Matagalpa, Nicaragua');
  String _tipoCultivo = 'Café';

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _tamanoCtrl.dispose();
    _ubicacionCtrl.dispose();
    super.dispose();
  }

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información de finca actualizada')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Editar Finca', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image with Edit Button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?auto=format&fit=crop&w=800'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Datos Generales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleDark)),
              const SizedBox(height: 16),
              
              const Text('Nombre de la Finca', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.titleDark)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _nombreCtrl,
                hintText: 'Ej. Finca La Esperanza',
                prefixIcon: Icons.landscape,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tamaño (Hectáreas)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.titleDark)),
                        const SizedBox(height: 8),
                        CustomTextField(
                          controller: _tamanoCtrl,
                          hintText: '0.0',
                          prefixIcon: Icons.straighten,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cultivo Principal', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.titleDark)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _tipoCultivo,
                              icon: const Icon(Icons.arrow_drop_down, color: AppColors.TextSoft),
                              items: ['Café', 'Cacao', 'Frijoles', 'Hortalizas'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _tipoCultivo = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Text('Ubicación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.titleDark)),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ubicacionCtrl,
                hintText: 'Departamento, Municipio',
                prefixIcon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Matagalpa,Nicaragua&zoom=10&size=400x120&sensor=false'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.pin_drop),
                    label: const Text('Ajustar en mapa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: PrimaryButton(
          text: 'Guardar Cambios',
          onPressed: _guardarCambios,
        ),
      ),
    );
  }
}
