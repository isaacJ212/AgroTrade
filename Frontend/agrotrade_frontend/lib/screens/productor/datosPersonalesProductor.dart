import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/api/user_models.dart';
import '../../models/productor_models.dart';
import '../../services/api_session.dart';
import '../../services/productor_store.dart';
import '../../services/users_api_service.dart';
import '../../ui/widgets/productor_widgets.dart';

class DatosPersonalesProductor extends StatefulWidget {
  const DatosPersonalesProductor({super.key});
  @override
  State<DatosPersonalesProductor> createState() =>
      _DatosPersonalesProductorState();
}

class _DatosPersonalesProductorState extends State<DatosPersonalesProductor> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _correo;
  late final TextEditingController _telefono;
  late final TextEditingController _ubicacion;
  late Uint8List? _foto;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    final store = ProductorStore.instance;
    final sesion = ApiSession.instance;

    final nombreInicial = (sesion.userName?.isNotEmpty ?? false)
        ? sesion.userName!
        : store.persona.nombre;
    final correoInicial = (sesion.userEmail?.isNotEmpty ?? false)
        ? sesion.userEmail!
        : store.persona.correo;
    final telefonoInicial = (sesion.userPhone?.isNotEmpty ?? false)
        ? sesion.userPhone!
        : store.persona.telefono;
    final ubicacionInicial = (sesion.userLocation?.isNotEmpty ?? false)
        ? sesion.userLocation!
        : store.persona.ubicacion;

    _nombre = TextEditingController(text: nombreInicial);
    _correo = TextEditingController(text: correoInicial);
    _telefono = TextEditingController(text: telefonoInicial);
    _ubicacion = TextEditingController(text: ubicacionInicial);
    _foto = store.persona.foto;

    _cargarPerfilServidor();
  }

  Future<void> _cargarPerfilServidor() async {
    try {
      final user = await UsersApiService.instance.getPerfilActual();
      if (mounted && user != null) {
        setState(() {
          if (user.name.isNotEmpty) _nombre.text = user.name;
          if (user.email.isNotEmpty) _correo.text = user.email;
          if (user.telefono != null && user.telefono!.isNotEmpty) {
            _telefono.text = user.telefono!;
          }
          if (user.direccionBase != null && user.direccionBase!.isNotEmpty) {
            _ubicacion.text = user.direccionBase!;
          } else if (user.departamento != null &&
              user.departamento!.isNotEmpty) {
            _ubicacion.text = user.departamento!;
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _telefono.dispose();
    _ubicacion.dispose();
    super.dispose();
  }

  Future<void> _elegirFoto() async {
    setState(() => _cargando = true);
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 600,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (mounted) setState(() => _foto = bytes);
      }
    } catch (_) {
      if (mounted)
        mensajeProductor(
          context,
          'No se pudo abrir la imagen. Revisa los permisos de la galería.',
        );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _guardar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _cargando = true);

    final nombre = _nombre.text.trim();
    final correo = _correo.text.trim();
    final telefono = _telefono.text.trim();
    final ubicacion = _ubicacion.text.trim();

    ProductorStore.instance.guardarPersona(
      DatosProductor(
        nombre: nombre,
        correo: correo,
        telefono: telefono,
        ubicacion: ubicacion,
        foto: _foto,
      ),
    );

    try {
      final userId = ApiSession.instance.userId;
      if (userId != null && int.tryParse(userId) != null) {
        await UsersApiService.instance.updateUser(
          userId: int.parse(userId),
          dto: UpdateUserRequestDto(
            nombres: nombre,
            email: correo,
            telefono: telefono,
            direccionBase: ubicacion,
          ),
        );
      }
    } catch (e) {
      print(
        'DEBUG: [datosPersonalesProductor] Error al sincronizar con backend: $e',
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }

    if (!mounted) return;
    mensajeProductor(context, 'Perfil actualizado.');
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => ProductorPage(
    title: 'Editar perfil',
    actions: [
      TextButton(
        onPressed: _cargando ? null : _guardar,
        child: const Text('Guardar'),
      ),
    ],
    children: [
      Form(
        key: _form,
        child: Column(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: ProductorImage(
                    bytes: _foto,
                    width: 100,
                    height: 100,
                    icon: Icons.person,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton.filled(
                    tooltip: 'Cambiar foto',
                    onPressed: _cargando ? null : _elegirFoto,
                    icon: const Icon(Icons.camera_alt, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ProductorField(
              controller: _nombre,
              label: 'Nombre completo',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Ingresa tu nombre.' : null,
            ),
            ProductorField(
              controller: _correo,
              label: 'Correo electrónico',
              keyboard: TextInputType.emailAddress,
              validator: (v) =>
                  v == null ||
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())
                  ? 'Revisa el correo.'
                  : null,
            ),
            ProductorField(
              controller: _telefono,
              label: 'Teléfono',
              keyboard: TextInputType.phone,
              validator: (v) =>
                  v == null || v.replaceAll(RegExp(r'\D'), '').length < 8
                  ? 'Revisa el teléfono.'
                  : null,
            ),
            ProductorField(
              controller: _ubicacion,
              label: 'Ubicación',
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Ingresa tu ubicación.'
                  : null,
            ),
            ProductorButton(
              label: 'Cambiar contraseña',
              outlined: true,
              icon: Icons.lock_outline,
              onPressed: () =>
                  Navigator.pushNamed(context, '/productor/contrasena'),
            ),
          ],
        ),
      ),
    ],
  );
}
