import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../cliente/inicioComprador.dart';
import '../cliente/misPedidos.dart';
import '../productor/pedidos/sales.dart';
import 'auth/Login.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const InicioComprador()),
              );
            }
          },
        ),
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E5E2)),
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE0E5E2),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFFEAF3ED),
                          child: Icon(
                            Icons.person,
                            size: 42,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: 2,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ApiSession.instance.userName != null &&
                            ApiSession.instance.userName!.isNotEmpty
                        ? ApiSession.instance.userName!
                        : 'Usuario AgroTrade',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.TextMain,
                    ),
                  ),

                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4F4E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          size: 14,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Cuenta Verificada',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Jinotepe, Carazo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5C6661),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E5E2)),
              ),
              child: Column(
                children: [
                  _ProfileMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Mis pedidos y compras',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MisPedidosScreen()),
                    ),
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Datos personales',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edición de datos personales'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuración de la cuenta'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Centro de ayuda',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Soporte AgroTrade: contacto@agrotrade.com'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            TertiaryButton(
              label: 'Cerrar Sesión',
              icon: Icons.logout,
              onPressed: () {
                ApiSession.instance.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                  (_) => false,
                );
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),

      bottomNavigationBar: AgroBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 3) {
            return;
          }
          if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Sales()),
            );
          }
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.primaryColor),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.TextMain,
                ),
              ),
            ),

            const Icon(Icons.chevron_right, size: 22, color: Color(0xFF59635E)),
          ],
        ),
      ),
    );
  }
}
