import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';
import '../../services/users_api_service.dart';
import '../../services/api_session.dart';
import '../../models/api/user_models.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departamentoController;
  late TextEditingController _municipioController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _departamentoController = TextEditingController();
    _municipioController = TextEditingController();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userIdStr = ApiSession.instance.userId;
      if (userIdStr != null) {
        final userId = int.tryParse(userIdStr);
        if (userId != null) {
          final user = await UsersApiService.instance.getUserById(userId);
          setState(() {
            final parts = user.name.split(' ');
            _nombresController.text = parts.isNotEmpty ? parts[0] : '';
            _apellidosController.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
            _emailController.text = user.email;
            _phoneController.text = user.telefono ?? '';
            _departamentoController.text = user.departamento ?? '';
            _municipioController.text = user.municipio ?? '';
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint("Error loading user: $e");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departamentoController.dispose();
    _municipioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    try {
      final userIdStr = ApiSession.instance.userId;
      if (userIdStr != null) {
        final userId = int.tryParse(userIdStr);
        if (userId != null) {
          await UsersApiService.instance.updateUser(
            userId: userId,
            // Jafet: Se integró el fetch a la API para enviar los campos actualizados (Nombres, Apellidos, Municipio)
            dto: UpdateUserRequestDto(
              nombres: _nombresController.text,
              apellidos: _apellidosController.text,
              telefono: _phoneController.text,
              departamento: _departamentoController.text,
              municipio: _municipioController.text,
            ),
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil guardado exitosamente'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              controller: _nombresController,
              label: 'Nombres',
              hint: 'Ingresa tus nombres',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _apellidosController,
              label: 'Apellidos',
              hint: 'Ingresa tus apellidos',
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
              controller: _departamentoController,
              label: 'Departamento',
              hint: 'Ej: Carazo',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _municipioController,
              label: 'Municipio',
              hint: 'Ej: Jinotepe',
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
