import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/api/bank_account_models.dart';
import '../../routes/app_routes.dart';
import '../../screens/shared/bank_accounts_screen.dart';
import '../../services/api_client.dart';
import '../../services/bank_account_api_service.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/app_text_field.dart';
import '../../ui/widgets/buttons.dart';

class FormularioSolicitudRepartidor extends StatefulWidget {
  const FormularioSolicitudRepartidor({super.key});

  @override
  State<FormularioSolicitudRepartidor> createState() =>
      _FormularioSolicitudRepartidorState();
}

class _FormularioSolicitudRepartidorState
    extends State<FormularioSolicitudRepartidor> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Controladores de texto
  final _cedulaController = TextEditingController();
  final _placaController = TextEditingController();
  final _tipoVehiculoController = TextEditingController();
  final _marcaVehiculoController = TextEditingController();
  final _municipioController = TextEditingController();
  final _departamentoController = TextEditingController();

  // Dropdowns
  String? _selectedTipoVehiculo;
  String? _selectedDepartamento;
  int? _selectedCuentaBancariaId;
  List<BankAccountDto> _cuentasBancarias = [];
  bool _loadingCuentas = true;
  String? _cuentasError;

  // Imágenes
  XFile? _fotoPerfil;
  XFile? _fotoCedula;
  XFile? _fotoLicencia;
  XFile? _recordPolicial;

  // Estado
  bool _submitting = false;
  String? _error;

  static const List<String> _tiposVehiculo = [
    'Moto',
    'Carro',
    'Bicicleta',
    'Camioneta',
  ];
  static const List<String> _departamentos = [
    'Managua',
    'León',
    'Granada',
    'Masaya',
    'Matagalpa',
    'Estelí',
    'Chinandega',
    'Jinotega',
    'Boaco',
    'Carazo',
    'Chontales',
    'Madriz',
    'Nueva Segovia',
    'Rivas',
    'Río San Juan',
    'Región Autónoma Costa Caribe Norte',
    'Región Autónoma Costa Caribe Sur',
  ];

  @override
  void initState() {
    super.initState();
    _cargarCuentasBancarias();
  }

  Future<void> _cargarCuentasBancarias() async {
    setState(() {
      _loadingCuentas = true;
      _cuentasError = null;
    });
    try {
      // Usar getAccounts() que ya filtra por usuario autenticado (JWT)
      final cuentas = await BankAccountApiService.instance.getAccounts();
      if (mounted) {
        setState(() {
          _cuentasBancarias = cuentas;
          _loadingCuentas = false;
          // Lista vacía NO es error - es estado normal
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingCuentas = false;
          _cuentasError = 'Error cargando cuentas: $e';
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source, Function(XFile) onPicked) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null && mounted) {
        onPicked(picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _showImagePickerOptions(Function(XFile) onPicked) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, onPicked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, onPicked);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required XFile? image,
    required VoidCallback onTap,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label${isRequired ? ' *' : ''}', style: AppTextStyles.label),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              border: Border.all(
                color: image != null
                    ? AppColors.primaryColor
                    : AppColors.cardBorder,
                width: image != null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 40,
                        color: AppColors.TextSoft,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para agregar',
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
          ),
        ),
        if (isRequired && image == null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'Este campo es obligatorio',
              style: TextStyle(fontSize: 11, color: AppColors.inputErrorColor),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCuentaBancariaId == null) {
      setState(() => _error = 'Selecciona una cuenta bancaria');
      return;
    }
    if (_fotoPerfil == null ||
        _fotoCedula == null ||
        _fotoLicencia == null ||
        _recordPolicial == null) {
      setState(() => _error = 'Todas las fotos son obligatorias');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      // Preparar campos para multipart
      final fields = {
        'NumeroCedula': _cedulaController.text.trim(),
        'PlacaVehiculo': _placaController.text.trim(),
        'TipoVehiculo': _selectedTipoVehiculo!,
        'MarcaVehiculo': _marcaVehiculoController.text.trim(),
        'Municipio': _municipioController.text.trim(),
        'Departamento': _selectedDepartamento!,
        'IdCuentaBancaria': _selectedCuentaBancariaId.toString(),
      };

      // Preparar rutas de archivos (usar path directo como en productos)
      final filePaths = <String, String>{};

      if (_fotoPerfil != null) {
        filePaths['FotoPerfil'] = _fotoPerfil!.path;
        print('DEBUG: FotoPerfil path: ${_fotoPerfil!.path}');
      }
      if (_fotoCedula != null) {
        filePaths['FotoCedula'] = _fotoCedula!.path;
        print('DEBUG: FotoCedula path: ${_fotoCedula!.path}');
      }
      if (_fotoLicencia != null) {
        filePaths['FotoLicencia'] = _fotoLicencia!.path;
        print('DEBUG: FotoLicencia path: ${_fotoLicencia!.path}');
      }
      if (_recordPolicial != null) {
        filePaths['RecordPolicial'] = _recordPolicial!.path;
        print('DEBUG: RecordPolicial path: ${_recordPolicial!.path}');
      }

      print('DEBUG: Fields to send: $fields');
      print('DEBUG: FilePaths to send: $filePaths');

      // Enviar multipart (usa fromPath para auto-detectar Content-Type)
      final response = await ApiClient.instance.EnviaEnviapostMultipart(
        '/api/DeliveryJobRequest',
        fields: fields,
        filePaths: filePaths,
        authorized: true,
      );

      if (!mounted) return;
      print('DEBUG: status code del backend  ${response.statusCode}');
      print('DEBUG: response body: ${response.rawBody}');
      print('DEBUG: response jsonBody: ${response.jsonBody}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada, en revisión'),
            backgroundColor: AppColors.primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.inicioRepartidor,
          (_) => false,
        );
      } else {
        final msg =
            response.jsonBody?['message'] ?? 'Error al enviar la solicitud';
        setState(() => _error = msg);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Error de conexión: $e');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _placaController.dispose();
    _tipoVehiculoController.dispose();
    _marcaVehiculoController.dispose();
    _municipioController.dispose();
    _departamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Solicitud de   EmpleoP', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            // Sección: Documentos de identidad
            Text('Documentos de Identidad', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: '',
              validator: (v) {
                final val = _cedulaController.text;
                if (val.trim().isEmpty) return 'La cédula es obligatoria';
                final regex = RegExp(r'^[0-9]{3}-[0-9]{6}-[0-9]{4}[A-Za-z]$');
                if (!regex.hasMatch(val.trim()))
                  return 'Formato: 001-120794-0005A';
                return null;
              },
              builder: (state) {
                return AppTextField(
                  label: 'Número de Cédula',
                  hint: '001-120794-0005A',
                  controller: _cedulaController,
                  keyboard: TextInputType.text,
                  errorText: state.errorText,
                );
              },
            ),
            const SizedBox(height: 16),

            // Sección: Vehículo
            Text('Datos del Vehículo', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: '',
              validator: (v) {
                final val = _placaController.text;
                if (val.trim().isEmpty) return 'La placa es obligatoria';
                final regex = RegExp(r'^[A-Za-z]{1,2}[- ]?[0-9]{3,6}$');
                if (!regex.hasMatch(val.trim())) return 'Formato: M-123456';
                return null;
              },
              builder: (state) {
                return AppTextField(
                  label: 'Placa del Vehículo',
                  hint: 'M-123456',
                  controller: _placaController,
                  errorText: state.errorText,
                );
              },
            ),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: _selectedTipoVehiculo,
              validator: (v) => v == null || v.isEmpty
                  ? 'Selecciona un tipo de vehículo'
                  : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedTipoVehiculo,
                      isExpanded: true,
                      decoration: appInputDecoration(
                        label: 'Tipo de Vehículo *',
                        hint: 'Selecciona el tipo',
                        errorText: state.errorText,
                      ),
                      items: _tiposVehiculo
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                t,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedTipoVehiculo = v);
                        state.didChange(v);
                      },
                      menuMaxHeight: 300,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: '',
              validator: (v) {
                final val = _marcaVehiculoController.text;
                if (val.trim().isEmpty) return 'La marca es obligatoria';
                return null;
              },
              builder: (state) {
                return AppTextField(
                  label: 'Marca del Vehículo',
                  hint: 'Honda, Toyota, etc.',
                  controller: _marcaVehiculoController,
                  errorText: state.errorText,
                );
              },
            ),
            const SizedBox(height: 16),

            // Sección: Ubicación
            Text('Ubicación', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: '',
              validator: (v) {
                final val = _municipioController.text;
                if (val.trim().isEmpty) return 'El municipio es obligatorio';
                return null;
              },
              builder: (state) {
                return AppTextField(
                  label: 'Municipio',
                  hint: 'Jinotepe, Diriamba, etc.',
                  controller: _municipioController,
                  errorText: state.errorText,
                );
              },
            ),
            const SizedBox(height: 16),
            FormField<String>(
              initialValue: _selectedDepartamento,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Selecciona un departamento' : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedDepartamento,
                      isExpanded: true,
                      decoration: appInputDecoration(
                        label: 'Departamento *',
                        hint: 'Selecciona el departamento',
                        errorText: state.errorText,
                      ),
                      items: _departamentos
                          .map(
                            (d) => DropdownMenuItem(
                              value: d,
                              child: Text(
                                d,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedDepartamento = v);
                        state.didChange(v);
                      },
                      menuMaxHeight: 300,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Sección: Cuenta Bancaria
            Text('Cuenta Bancaria', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            if (_loadingCuentas)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            else if (_cuentasError != null)
              Column(
                children: [
                  Text(
                    _cuentasError!,
                    style: TextStyle(color: AppColors.inputErrorColor),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _cargarCuentasBancarias,
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            else if (_cuentasBancarias.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoftBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_outlined,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No tienes cuentas bancarias registradas. Necesitas una para recibir pagos.',
                            style: AppTextStyles.SubTitle.copyWith(
                              color: AppColors.primarySoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: 'Agregar cuenta bancaria',
                        icon: Icons.add_outlined,
                        radius: 12,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BankAccountsScreen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              FormField<int>(
                initialValue: _selectedCuentaBancariaId,
                validator: (v) =>
                    v == null ? 'Selecciona una cuenta bancaria' : null,
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<int>(
                        value: _selectedCuentaBancariaId,
                        isExpanded: true,
                        decoration: appInputDecoration(
                          label: 'Cuenta Bancaria *',
                          hint: 'Selecciona una cuenta',
                          errorText: state.errorText,
                        ),
                        items: _cuentasBancarias
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.idCuentaBancaria,
                                child: Text(
                                  '${c.nombreBanco} •••• ${c.numeroCuentaBancaria.substring(c.numeroCuentaBancaria.length - 4)}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedCuentaBancariaId = v);
                          state.didChange(v);
                        },
                        menuMaxHeight: 300,
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 24),

            // Sección: Fotos obligatorias
            Text(
              'Documentos Requeridos (Fotos)',
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 8),
            Text(
              'Todas las fotos son obligatorias para la verificación',
              style: AppTextStyles.SubTitle.copyWith(
                fontSize: 12,
                color: AppColors.TextSoft,
              ),
            ),
            const SizedBox(height: 16),
            _buildImagePicker(
              label: 'Foto de Perfil',
              image: _fotoPerfil,
              onTap: () => _showImagePickerOptions(
                (img) => setState(() => _fotoPerfil = img),
              ),
              isRequired: true,
            ),
            _buildImagePicker(
              label: 'Cédula (Frente/Verso)',
              image: _fotoCedula,
              onTap: () => _showImagePickerOptions(
                (img) => setState(() => _fotoCedula = img),
              ),
              isRequired: true,
            ),
            _buildImagePicker(
              label: 'Licencia de Conducir',
              image: _fotoLicencia,
              onTap: () => _showImagePickerOptions(
                (img) => setState(() => _fotoLicencia = img),
              ),
              isRequired: true,
            ),
            _buildImagePicker(
              label: 'Registro Policial',
              image: _recordPolicial,
              onTap: () => _showImagePickerOptions(
                (img) => setState(() => _recordPolicial = img),
              ),
              isRequired: true,
            ),

            // Error general
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.inputErrorColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.inputErrorColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: AppColors.inputErrorColor),
                      ),
                    ),
                  ],
                ),
              ),

            // Botón enviar
            PrimaryButton(
              label: _submitting ? 'Enviando...' : 'Enviar Solicitud',
              icon: Icons.send_outlined,
              radius: 24,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
