import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../../../ui/widgets/app_text_field.dart';
import '../../../ui/widgets/buttons.dart';
import '../../../ui/widgets/app_dropdown.dart';
import 'registroCosecha.dart'; 

class AgregarProducto extends StatefulWidget {
  const AgregarProducto({super.key});

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  // Controllers
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();


  String? _categoriaSeleccionada;
  String? _unidadSeleccionada;
  final List<XFile> _imagenes = [];
  final ImagePicker _picker = ImagePicker();


  final List<String> _categorias = ['Frutas', 'Verduras', 'Granos', 'Lácteos'];
  final List<String> _unidades = ['kg', 'Tonelada', 'Caja', 'Docena'];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }


  Future<void> _agregarFoto() async {
    if (_imagenes.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo 5 fotos permitidas')),
      );
      return;
    }


    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => _seleccionarImagen(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => _seleccionarImagen(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarImagen(ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? foto = await _picker.pickImage(source: source, imageQuality: 80);
      if (foto != null) {
        setState(() => _imagenes.add(foto));
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
    }
  }

  void _eliminarFoto(int index) {
    setState(() => _imagenes.removeAt(index));
  }


  void _continuar() {
    if (_nombreController.text.trim().isEmpty) {
      return _mostrarSnack('El nombre es obligatorio');
    }
    if (_categoriaSeleccionada == null) {
      return _mostrarSnack('Selecciona una categoría');
    }
    if (_unidadSeleccionada == null) {
      return _mostrarSnack('Selecciona una unidad de medida');
    }


    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistroCosecha()),
    );
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Agregar Producto',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.titleDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.titleDark),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.cardBorder, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor blanco tipo card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete los detalles de su producto agrícola para publicarlo en el mercado.',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Nombre
                  Text('Nombre del Producto *', style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.titleDark)),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: '', // Label vacío porque usamos el Text de arriba
                    hint: 'Ej: Tomates Cherry Orgánicos',
                    controller: _nombreController,
                  ),
                  const SizedBox(height: 16),

                  // Categoría
                  AppDropdown<String>(
                    label: 'Categoría *',
                    value: _categoriaSeleccionada,
                    items: _categorias,
                    itemLabel: (item) => item,
                    hint: 'Seleccione una categoría',
                    onChanged: (val) => setState(() => _categoriaSeleccionada = val),
                  ),
                  const SizedBox(height: 16),

                  //  Descripción
                  Text('Descripción', style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.titleDark)),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: '',
                    hint: 'Describa la calidad, origen y detalles importantes...',
                    controller: _descripcionController,
                    keyboard: TextInputType.multiline,
                  ),
                  const SizedBox(height: 16),

                  //  Unidad de Medida
                  AppDropdown<String>(
                    label: 'Unidad de Medida *',
                    value: _unidadSeleccionada,
                    items: _unidades,
                    itemLabel: (item) => item,
                    hint: 'Seleccione unidad',
                    onChanged: (val) => setState(() => _unidadSeleccionada = val),
                  ),
                  const SizedBox(height: 16),

                  //  Precio E
                  Text('Precio Estimado por Unidad (Opcional)', style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.titleDark)),
                  const SizedBox(height: 8),
                  AppTextField(
                    label: '',
                    hint: '0.00',
                    prefix: '\$ ',
                    controller: _precioController,
                    keyboard: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 24),

                  //  Fotos
                  Text('Fotos del Producto', style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.titleDark)),
                  const SizedBox(height: 4),
                  Text(
                    'Agregue hasta 5 fotos claras de su producto para atraer más compradores.',
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imagenes.length + 1, // +1 para el botón de agregar
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        // Botón Agregar Foto
                        if (index == _imagenes.length) {
                          return GestureDetector(
                            onTap: _agregarFoto,
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: AppColors.tileBg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.inputBorderColor.withOpacity(0.5), style: BorderStyle.solid), // Borde punteado simulado
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, color: AppColors.bodyText, size: 24),
                                  SizedBox(height: 4),
                                  Text('Agregar', style: TextStyle(fontSize: 11, color: AppColors.bodyText)),
                                ],
                              ),
                            ),
                          );
                        }

  
                        final imagen = _imagenes[index];
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(imagen.path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () => _eliminarFoto(index),
                                child: const CircleAvatar(
                                  radius: 10,
                                  backgroundColor: AppColors.errorColor,
                                  child: Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 24),


                  PrimaryButton(
                    label: 'Continuar',
                    icon: Icons.arrow_forward,
                    radius: 25,
                    onPressed: _continuar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Mercado', icon: Icons.storefront_outlined, activeIcon: Icons.storefront),
          NavElemento(label: 'Mis Pedidos', icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 1, 
        onTap: (index) {
          if (index == 1) return;
          Navigator.pop(context); 
        },
      ),
    );
  }
}