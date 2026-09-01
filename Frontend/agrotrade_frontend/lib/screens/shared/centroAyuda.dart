import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';

class CentroAyuda extends StatelessWidget {
  const CentroAyuda({super.key});

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
          'Centro de Ayuda',
          style: AppTextStyles.Title,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Cómo podemos ayudarte hoy?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 20),
            
        
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar ayuda, problemas, etc.',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppColors.TextSoft),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.TextMain,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildFaqItem(
              '¿Cómo sigo mi pedido?',
              'Puedes ver el estado de tu pedido desde la sección "Mis pedidos y compras" en tu perfil. Una vez el pedido haya sido enviado, podrás ver su ubicación en tiempo real.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              '¿Qué métodos de pago aceptan?',
              'Aceptamos pagos en efectivo, transferencia bancaria y tarjeta de crédito o débito a través de la plataforma.',
            ),
            const SizedBox(height: 10),
            _buildFaqItem(
              'Tuve un problema con un producto',
              'Si tienes problemas de calidad con tu compra, por favor contáctanos en las primeras 24 horas tras recibirlo para gestionar una devolución o reembolso.',
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              'Contacto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.TextMain,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primarySoftBg,
                      child: Icon(Icons.email_outlined, color: AppColors.primaryColor),
                    ),
                    title: const Text('Soporte por Correo'),
                    subtitle: const Text('contacto@agrotrade.com'),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.TextSoft),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 70, color: AppColors.cardBorder),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primarySoftBg,
                      child: Icon(Icons.phone_outlined, color: AppColors.primaryColor),
                    ),
                    title: const Text('Llamada Telefónica'),
                    subtitle: const Text('+505 2234-5678'),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.TextSoft),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String title, String content) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.TextMain,
          ),
        ),
        collapsedIconColor: AppColors.primaryColor,
        iconColor: AppColors.primaryColor,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: const TextStyle(
                color: AppColors.TextSoft,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
