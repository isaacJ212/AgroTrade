import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';
import '../../services/api_session.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    // Mock data pre-filled
    _nameController = TextEditingController(
      text: ApiSession.instance.userName ?? 'María González',
    );
    _emailController = TextEditingController(text: 'maria@agrotrade.com');
    _phoneController = TextEditingController(text: '+505 8888 8888');
    _locationController = TextEditingController(text: 'Jinotepe, Carazo');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil guardado exitosamente'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.TextMain),
        title: const Text(
          'Editar Perfil',
          style: AppTextStyles.Title,
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 2,
                      ),
                      color: AppColors.primarySoftBg,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cambiar foto de perfil'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.White, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: AppColors.White,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            AppTextField(
              controller: _nameController,
              label: 'Nombre completo',
              hint: 'Ingresa tu nombre completo',
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'Ingresa tu correo',
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: _phoneController,
              label: 'Teléfono',
              hint: 'Ingresa tu número',
              keyboard: TextInputType.phone,
            ),
            const SizedBox(height: 20),

            AppTextField(
              controller: _locationController,
              label: 'Ubicación',
              hint: 'Ej: Jinotepe, Carazo',
            ),
            const SizedBox(height: 32),

            // Change Password Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Redirigiendo a cambio de contraseña...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.lock_outline),
                label: const Text('Cambiar Contraseña'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.TextMain,
                  side: const BorderSide(color: AppColors.cardBorder),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
