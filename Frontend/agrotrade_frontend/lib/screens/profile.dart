import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'sales.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Mi perfil',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
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
                  const Text(
                    'Carlos Martínez',
                    style: TextStyle(
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
                          'Productor verificado',
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
                    'Finca La Esperanza',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF5C6661),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF69736E),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Jinotepe, Carazo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF69736E),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFFFA726),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.TextMain,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(32 valoraciones)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF747E79),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Editar Perfil',
              radius: 8,
              onPressed: () {
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: 'Ver perfil',
              onPressed: () {
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E5E2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sobre la finca',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.TextMain,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Productor local dedicado al cultivo y '
                    'comercialización de frutas y hortalizas frescas.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF5C6661),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Expanded(
                        child: _FarmInfoCard(
                          icon: Icons.phone_outlined,
                          title: 'Teléfono',
                          value: '8888 1234',
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: _FarmInfoCard(
                          icon: Icons.map_outlined,
                          title: 'Ubicación',
                          value: 'Jinotepe, Carazo',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: _FarmInfoCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'Productos',
                          value: '12 publicados',
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: _FarmInfoCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Miembro desde',
                          value: '2024',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
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
                    icon: Icons.person_outline,
                    title: 'Datos personales',
                    onTap: () {},
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.park_outlined,
                    title: 'Información de la finca',
                    onTap: () {},
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () {},
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Cambiar contraseña',
                    onTap: () {},
                  ),

                  const Divider(
                    height: 1,
                    indent: 48,
                    color: Color(0xFFE5E9E7),
                  ),

                  _ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Ayuda',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            TertiaryButton(
              label: 'Cerrar Sesion',
              icon: Icons.logout,
              onPressed: () {
                //despues
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

class _FarmInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _FarmInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E5E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF4F5C56)),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF58635E),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.TextMain,
            ),
          ),
        ],
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
