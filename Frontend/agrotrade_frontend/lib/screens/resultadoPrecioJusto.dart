import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart'; 
import '../ui/widgets/buttons.dart'; 


class ResultadoPrecioJusto extends StatelessWidget {
 
  final String nombreProducto;
  final double precioSugerido;
  final double costoTotal;
  final double margenGanancia;
  final String unidad;
  

  final List<Map<String, dynamic>> desglose;

  const ResultadoPrecioJusto({
    super.key,
    required this.nombreProducto,
    required this.precioSugerido,
    required this.costoTotal,
    required this.margenGanancia,
    required this.unidad,
    required this.desglose,
  });

  @override
  Widget build(BuildContext context) {

    final gananciaNeta = precioSugerido - costoTotal;
    final porcentajeMargen = ((gananciaNeta / costoTotal) * 100).round();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.accentBlue, size: 20),
                    label: Text(
                      'Volver',
                      style: AppTextStyles.label.copyWith(color: AppColors.accentBlue, fontSize: 14),
                    ),
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8)),
                  ),
                ],
              ),
            ),
            
        
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: AppColors.navPill, // Verde suave
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Resultado de Precio\nJusto',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headline.copyWith(
                                  fontSize: 22,
                                  color: AppColors.primarySoft,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                nombreProducto,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: AppColors.White,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'PRECIO SUGERIDO',
                                      style: AppTextStyles.label.copyWith(
                                        fontSize: 11,
                                        color: AppColors.bodyText,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'C\$ $precioSugerido', 
                                          style: const TextStyle(
                                            fontSize: 32, 
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.amber, 
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                                          child: Text(
                                            '/ $unidad',
                                            style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Desglose de Costos por\n$unidad',
                                style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 16),
                              
                              // Lista de costos
                              ...desglose.map((item) => _CostoRow(
                                    icon: item['icon'] as IconData,
                                    label: item['label'] as String,
                                    value: 'C\$ ${(item['value'] as double).toStringAsFixed(2)}',
                                  )),
                              
                              const SizedBox(height: 16),
                              

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.tileBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Costo Total de\nProducción',
                                      style: AppTextStyles.label.copyWith(fontSize: 13, height: 1.2),
                                    ),
                                    Text(
                                      'C\$ ${costoTotal.toStringAsFixed(2)}',
                                      style: AppTextStyles.productoTitle.copyWith(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.navPill,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.eco, color: AppColors.primaryColor, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Margen de Ganancia Justo ($porcentajeMargen%)',
                                          style: AppTextStyles.label.copyWith(
                                            color: AppColors.primaryColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Recomendado para sostenibilidad de la finca.',
                                      style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.White,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '+ C\$ ${gananciaNeta.toStringAsFixed(2)}',
                                        style: AppTextStyles.label.copyWith(
                                          color: AppColors.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context), 
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.inputBorderColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text(
                        'Conservar precio actual',
                        style: AppTextStyles.label.copyWith(fontSize: 14, color: AppColors.titleDark),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  

                  SecondaryButton(
                    label: 'Volver a calcular',
                    icon: Icons.refresh,
                    color: AppColors.accentBlue,
                    textColor: AppColors.accentBlue,
                    onPressed: () => Navigator.pop(context), 
                  ),
                  
                  const SizedBox(height: 12),
                  

                  PrimaryButton(
                    label: 'Aplicar precio sugerido',
                    radius: 24,
                    onPressed: () {
                     
                      Navigator.pop(context, precioSugerido);
                    },
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
          NavElemento(label: 'Explorar', icon: Icons.explore_outlined, activeIcon: Icons.explore),
          NavElemento(label: 'Pedidos', icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, badge: true),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 0, 
        onTap: (index) {
           if (index == 0) return;

        },
      ),
    );
  }
}


class _CostoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CostoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.bodyText),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.SubTitle.copyWith(fontSize: 13, color: AppColors.titleDark),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.label.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}