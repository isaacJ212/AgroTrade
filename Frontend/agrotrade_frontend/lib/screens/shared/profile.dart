import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../cliente/inicioComprador.dart';
import '../cliente/misPedidos.dart';
import '../productor/pedidos/sales.dart';
import 'auth/Login.dart';
import 'editarPerfil.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.White,
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
          style: AppTextStyles.Title,
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
                color: AppColors.White,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
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
                            color: AppColors.cardBorder,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: AppColors.primarySoftBg,
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
                            border: Border.all(color: AppColors.White, width: 2),
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            size: 14,
                            color: AppColors.White,
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
                      color: AppColors.primarySoftBg,
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
                      color: AppColors.TextSoft,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
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
                    color: AppColors.cardBorder,
                  ),

                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Datos personales',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditarPerfil()),
                    ),
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: AppColors.cardBorder,
                  ),

                  ProfileMenuItem(
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
                    color: AppColors.cardBorder,
                  ),

                  ProfileMenuItem(
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
