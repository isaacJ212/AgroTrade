import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/buttons.dart';
import '../../ui/widgets/app_text_field.dart';

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
        padding: const EdgeInsets.all(16.0),
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
                    height: 140,
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
              const SizedBox(height: 20),
              const Text('Datos Generales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.titleDark)),
              const SizedBox(height: 12),
              
              AppTextField(
                controller: _nombreCtrl,
                label: 'Nombre de la Finca',
                hint: 'Ej. Finca La Esperanza',
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          controller: _tamanoCtrl,
                          label: 'Tamaño (Hectáreas)',
                          hint: '0.0',
                          keyboard: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: appInputDecoration(label: 'Cultivo Principal', hint: ''),
                      isExpanded: true,
                      value: _tipoCultivo,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.TextSoft),
                      items: ['Café', 'Cacao', 'Frijoles', 'Hortalizas'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(fontSize: 15)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _tipoCultivo = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              const Text('Ubicación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.titleDark)),
              const SizedBox(height: 12),
              AppTextField(
                controller: _ubicacionCtrl,
                label: 'Dirección Exacta',
                hint: 'Departamento, Municipio',
              ),
              const SizedBox(height: 12),
              
              Container(
                height: 100,
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
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: PrimaryButton(
          label: 'Guardar Cambios',
          onPressed: _guardarCambios,
          radius: 12,
        ),
      ),
    );
  }
}
