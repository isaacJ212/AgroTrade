import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../services/consumer_api_service.dart';
import '../../models/Consumidor/consumidor_models.dart';

class ProductoresCercanos extends StatefulWidget {
  const ProductoresCercanos({super.key});

  @override
  State<ProductoresCercanos> createState() => _ProductoresCercanosState();
}

class _ProductoresCercanosState extends State<ProductoresCercanos> {
  List<ProductorDestacado> _productores = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProductores();
  }

  Future<void> _cargarProductores() async {
    print('DEBUG: [ProductoresCercanos] Obteniendo lista de productores de la API...');
    try {
      final lista = await ConsumerApiService.instance.getProductoresDestacados([]);
      print('DEBUG: [ProductoresCercanos] Se cargaron ${lista.length} productores exitosamente.');
      if (mounted) {
        setState(() {
          _productores = lista;
          _cargando = false;
        });
      }
    } catch (e) {
      print('DEBUG: [ProductoresCercanos] Error al cargar productores: $e');
      if (mounted) {
        setState(() => _cargando = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Productores cercanos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.titleDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
   
          Container(
            color: const Color(0xFFF0F2F5),
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: _MapGridPainter(),
            ),
          ),
          if (_cargando)
            const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
          else if (_productores.isNotEmpty)
            ..._productores.asMap().entries.map((entry) {
              final idx = entry.key;
              final prod = entry.value;
              // Mock randomish positions based on index
              final topOffset = 0.15 + (idx * 0.1) % 0.6;
              final leftOffset = 0.2 + (idx * 0.3) % 0.6;
              
              if (idx == 0) {
                // El primer productor se muestra destacado
                return Positioned(
                  top: MediaQuery.of(context).size.height * topOffset,
                  left: MediaQuery.of(context).size.width * leftOffset,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prod.nombre.length > 15 ? prod.nombre.substring(0, 15) : prod.nombre,
                          style: const TextStyle(
                            color: AppColors.White,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primaryColor,
                        size: 32,
                      ),
                    ],
                  ),
                );
              }
              
              return Positioned(
                top: MediaQuery.of(context).size.height * topOffset,
                left: MediaQuery.of(context).size.width * leftOffset,
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.agriculture, size: 12, color: Colors.grey),
                ),
              );
            }).toList(),

       
          Positioned(
            top: 20,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.White,
              elevation: 2,
              onPressed: () => _mostrarFiltros(context),
              child: const Icon(Icons.tune, color: AppColors.TextMain),
            ),
          ),

       
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _productores.isNotEmpty ? _productores[0].nombre : 'Seleccione un productor',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.TextMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.primaryColor, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Productor verificado',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryColor.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.TextMain,
                          ),
                        ),
                        const Text(
                          ' · 32 valoraciones',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.TextSoft,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.directions_walk, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          'A 4.2 km',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.TextSoft,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoftBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ESPECIALIDADES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _productores.isNotEmpty && _productores[0].descripcion != null && _productores[0].descripcion!.isNotEmpty
                                ? _productores[0].descripcion!
                                : 'Productos frescos',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.TextMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Ver productos',
                      icon: Icons.shopping_basket_outlined,
                      radius: 25,
                      onPressed: () {
                  
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtros de Búsqueda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Distancia Máxima', style: TextStyle(fontWeight: FontWeight.w600)),
              Slider(
                value: 10,
                min: 1,
                max: 50,
                activeColor: AppColors.primaryColor,
                onChanged: (val) {},
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 km'),
                  Text('50 km'),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Categoría Principal', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['Frutas', 'Verduras', 'Cereales', 'Café']
                    .map((cat) => Chip(
                          label: Text(cat),
                          backgroundColor: AppColors.primarySoftBg,
                          labelStyle: const TextStyle(color: AppColors.primaryColor),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Aplicar Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10;
      
    // Draw some simple simulated roads
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.5, size.height), paint);
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
