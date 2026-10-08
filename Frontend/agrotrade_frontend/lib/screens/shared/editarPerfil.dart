import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:agrotrade_frontend/ui/components.dart';
import '../../services/users_api_service.dart';
import '../../services/api_session.dart';
import '../../services/users_api_service.dart';
import '../../models/api/user_models.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _locationError;
  bool _cargando = false;

  bool _validarCampos() {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? 'Ingresa tu nombre.'
          : null;
      final email = _emailController.text.trim();
      _emailError =
          email.isEmpty ||
              !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)
          ? 'Revisa el correo.'
          : null;
      final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      _phoneError = phoneDigits.length < 8 ? 'Revisa el teléfono.' : null;
      _locationError = _locationController.text.trim().isEmpty
          ? 'Ingresa tu ubicación.'
          : null;
    });
    return _nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _locationError == null;
  }

  @override
  void initState() {
    super.initState();
    // Inicializar con datos de sesión como fallback
    _nameController = TextEditingController(
      text: ApiSession.instance.userName ?? '',
    );
    _emailController = TextEditingController(
      text: ApiSession.instance.userEmail ?? '',
    );
    _phoneController = TextEditingController(
      text: ApiSession.instance.userPhone ?? '',
    );
    _locationController = TextEditingController(
      text: ApiSession.instance.userLocation ?? '',
    );

    _cargarPerfilServidor();
  }

  Future<void> _cargarPerfilServidor() async {
    try {
      final user = await UsersApiService.instance.getPerfilActual();
      if (mounted && user != null) {
        setState(() {
          if (user.name.isNotEmpty) _nameController.text = user.name;
          if (user.email.isNotEmpty) _emailController.text = user.email;
          if (user.telefono != null && user.telefono!.isNotEmpty) {
            _phoneController.text = user.telefono!;
          }
          if (user.direccionBase != null && user.direccionBase!.isNotEmpty) {
            _locationController.text = user.direccionBase!;
          } else if (user.departamento != null &&
              user.departamento!.isNotEmpty) {
            _locationController.text = user.departamento!;
          }
        });
      }
    } catch (_) {}
  }

  Future<void> _saveProfile() async {
    if (!_validarCampos()) return;
    setState(() => _cargando = true);

    final nombre = _nameController.text.trim();
    final correo = _emailController.text.trim();
    final telefono = _phoneController.text.trim();
    final ubicacion = _locationController.text.trim();

    try {
      final userId = ApiSession.instance.userId;
      if (userId != null && int.tryParse(userId) != null) {
        await UsersApiService.instance.updateUser(
          userId: int.parse(userId),
          dto: UpdateUserRequestDto(
            nombreCompleto: nombre,
            email: correo,
            telefono: telefono,
            direccionBase: ubicacion,
          ),
        );

        // Actualizar sesión local
        await ApiSession.instance.updateUserProfile(
          name: nombre,
          email: correo,
          phone: telefono,
          location: ubicacion,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil guardado exitosamente'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
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
        title: const Text('Editar Perfil', style: AppTextStyles.Title),
        actions: [
          TextButton(
            onPressed: _cargando ? null : _saveProfile,
            child: _cargando
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
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
              child: Form(
                key: GlobalKey<FormState>(),
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
                                  border: Border.all(
                                    color: AppColors.White,
                                    width: 2,
                                  ),
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
                      errorText: _nameError,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      hint: 'Ingresa tu correo',
                      keyboard: TextInputType.emailAddress,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      controller: _phoneController,
                      label: 'Teléfono',
                      hint: 'Ingresa tu número',
                      keyboard: TextInputType.phone,
                      errorText: _phoneError,
                    ),
                    const SizedBox(height: 20),

                    AppTextField(
                      controller: _locationController,
                      label: 'Ubicación',
                      hint: 'Ej: Jinotepe, Carazo',
                      errorText: _locationError,
                    ),
                    const SizedBox(height: 32),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Redirigiendo a cambio de contraseña...',
                              ),
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
            ),
    );
  }
}
