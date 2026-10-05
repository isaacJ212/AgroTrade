import 'package:flutter/material.dart';

import '../../../models/api/auth_models.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_client.dart';
import '../../../services/api_session.dart';
import '../../../services/auth_api_service.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

class CompletarInformacionGoogle extends StatefulWidget {
  const CompletarInformacionGoogle({super.key});

  @override
  State<CompletarInformacionGoogle> createState() =>
      _CompletarInformacionGoogleState();
}

class _CompletarInformacionGoogleState
    extends State<CompletarInformacionGoogle> {
  final _departamentoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();

  String? _departamentoError;
  String? _direccionError;
  String? _telefonoError;
  bool _isLoading = false;

  @override
  void dispose() {
    _departamentoController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  bool _validar() {
    final departamento = _departamentoController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();

    String? departamentoError;
    String? direccionError;
    String? telefonoError;

    if (departamento.isEmpty) {
      departamentoError = 'El departamento es obligatorio.';
    } else if (departamento.length > 100) {
      departamentoError = 'Máximo 100 caracteres.';
    }

    if (direccion.isEmpty) {
      direccionError = 'La dirección exacta es obligatoria.';
    } else if (direccion.length > 500) {
      direccionError = 'Máximo 500 caracteres.';
    }

    if (telefono.isEmpty) {
      telefonoError = 'El número de teléfono es obligatorio.';
    } else if (telefono.length > 8 || !RegExp(r'^\d{8}$').hasMatch(telefono)) {
      telefonoError = 'Ingresa un teléfono válido de 8 dígitos.';
    }

    setState(() {
      _departamentoError = departamentoError;
      _direccionError = direccionError;
      _telefonoError = telefonoError;
    });

    return departamentoError == null &&
        direccionError == null &&
        telefonoError == null;
  }

  void _mostrarSnackBar(String mensaje, {bool error = true}) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? AppColors.errorColor : AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _guardarInformacion() async {
    if (!_validar()) {
      _mostrarSnackBar('Revisa los campos marcados en rojo');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthApiService.instance.completeGoogleInfo(
        GoogleCatchDataDto(
          departamento: _departamentoController.text.trim(),
          direccionBase: _direccionController.text.trim(),
          telefono: _telefonoController.text.trim(),
        ),
      );

      if (!mounted) return;
      _mostrarSnackBar('Información guardada correctamente.', error: false);
      _irAlInicio();
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(e.message);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnackBar('No se pudo guardar la información.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _irAlInicio() {
    final roles = ApiSession.instance.roles;
    if (roles.contains('Cliente') || roles.contains('Comprador')) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicioComprador);
    } else if (roles.contains('Productor') ||
        roles.contains('Proveedor') ||
        roles.contains('Productor/Proveedor')) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicioProductor);
    } else if (roles.contains('Repartidor')) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicioRepartidor);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'lib/assets/images/Brand.png',
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Completa esta información',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.Title,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Completa esta información para continuar con AgroTrade',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.SubTitle,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  label: 'Departamento',
                  hint: 'Ej: Managua',
                  controller: _departamentoController,
                  errorText: _departamentoError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Dirección Base',
                  hint: 'Ingresa tu dirección exacta',
                  controller: _direccionController,
                  errorText: _direccionError,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Teléfono',
                  hint: '88888888',
                  keyboard: TextInputType.phone,
                  controller: _telefonoController,
                  errorText: _telefonoError,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: _isLoading ? 'Guardando...' : 'Continuar',
                  radius: 15,
                  onPressed: _isLoading ? null : _guardarInformacion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
