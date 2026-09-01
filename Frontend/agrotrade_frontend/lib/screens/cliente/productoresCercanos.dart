import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class ProductoresCercanos extends StatelessWidget {
  const ProductoresCercanos({super.key});

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
          style: AppTextStyles.Title,
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
          
         
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'La Esperanza',
                    style: TextStyle(
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
          ),
          
        
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            right: MediaQuery.of(context).size.width * 0.2,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white70,
              child: Icon(Icons.agriculture, size: 14, color: Colors.grey),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: MediaQuery.of(context).size.width * 0.2,
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white70,
              child: Icon(Icons.storefront, size: 14, color: Colors.grey),
            ),
          ),

       
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
                padding: const EdgeInsets.all(20.0),
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
                    const Text(
                      'Finca La Esperanza',
                      style: TextStyle(
                        fontSize: 18,
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESPECIALIDADES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tomate, naranja y limón',
                            style: TextStyle(
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
