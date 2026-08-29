import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';

class DetalleProductoCliente extends StatefulWidget {
  const DetalleProductoCliente({super.key});

  @override
  State<DetalleProductoCliente> createState() => _DetalleProductoClienteState();
}

class _DetalleProductoClienteState extends State<DetalleProductoCliente> {
  int _cantidad = 2;

  void _incrementar() {
    setState(() => _cantidad++);
  }

  void _decrementar() {
    if (_cantidad > 1) {
      setState(() => _cantidad--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.titleDark),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.titleDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCDCDC),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=600&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.spa, color: AppColors.White, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Cosechado hoy',
                          style: TextStyle(
                            color: AppColors.White,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VERDURAS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.TextSoft,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tomate',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Finca
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoftBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: AppColors.primaryColor, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Finca La Esperanza',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        '4.8',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.TextMain),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '·',
                        style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '32 valoraciones',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.TextSoft,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '·',
                        style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 2),
                      const Text(
                        'A 4.2 km',
                        style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(height: 1, color: AppColors.cardBorder),
                  ),
                  
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'C\$ 25.00',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          Text(
                            'por libra',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.TextSoft,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, color: AppColors.primaryColor, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'Disponible',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
           
                  const Text(
                    'Tomate fresco de producción local, disponible para entrega o retiro en finca.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.TextSoft,
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver perfil del productor',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
              
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Cantidad',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.TextMain,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.screenBg,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: AppColors.primaryColor,
                                    onPressed: _decrementar,
                                  ),
                                  Container(
                                    width: 30,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_cantidad',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.TextMain,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    color: AppColors.primaryColor,
                                    onPressed: _incrementar,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'libras',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.TextSoft,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
               
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.White,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.primarySoftBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_shipping_outlined, color: AppColors.primaryColor),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrega disponible',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.TextMain,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Calculado en el checkout',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.TextSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.White,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 18),
                label: const Text('Enviar mensaje'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text('Agregar al carrito'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.White,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
