import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../../ui/widgets/app_text_field.dart';
import '../../ui/widgets/buttons.dart';

class PerfilFinca extends StatefulWidget {
  const PerfilFinca({super.key});

  @override
  State<PerfilFinca> createState() => _PerfilFincaState();
}

class _PerfilFincaState extends State<PerfilFinca> {
  int _tabActual = 3;

  static const List<NavElemento> _navItems = [
    NavElemento(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavElemento(
      label: 'Inventario',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
    ),
    NavElemento(
      label: 'Pedidos',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
    ),
    NavElemento(
      label: 'Perfil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  void _cambiarTab(int index) {
    setState(() => _tabActual = index);
    if (index != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Esta sección estará disponible pronto 🌱'),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.titleDark,
          ),
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(color: AppColors.bodyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.bodyText),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: AppColors.errorColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.White,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.titleDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mi perfil',
          style: AppTextStyles.wordmark.copyWith(fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.cardBorder, height: 1),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primarySoftBg,
                      backgroundImage: const AssetImage(
                        'lib/assets/images/LogoApp.png',
                      ),
                      onBackgroundImageError: (_, e) {},
                      child: const Icon(
                        Icons.person,
                        size: 52,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.White,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Text(
                  'Carlos Martínez',
                  style: AppTextStyles.headline,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_outlined,
                        size: 14,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Productor verificado',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: AppColors.bodyText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Jinotepe, Carazo',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '4.8',
                      style: AppTextStyles.label.copyWith(
                        fontSize: 13,
                        color: AppColors.titleDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(32 valoraciones)',
                      style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                PrimaryButton(
                  label: 'Editar perfil',
                  radius: 25,
                  onPressed: () =>
                      Navigator.pushNamed(context, '/editar-perfil'),
                ),
                const SizedBox(height: 10),

                SecondaryButton(
                  label: 'Ver perfil público',
                  color: AppColors.primaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () =>
                      _mostrarSnack('Vista pública próximamente 👁️'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sobre la finca',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Productor local dedicado al cultivo y comercialización de frutas y hortalizas frescas.',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.phone_outlined,
                        label: 'Teléfono',
                        value: '8888 1234',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.location_on_outlined,
                        label: 'Ubicación',
                        value: 'Jinotepe, Carazo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.inventory_2_outlined,
                        label: 'Productos',
                        value: '12 publicados',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Miembro desde',
                        value: '2026',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _MenuOpcion(
                  icon: Icons.person_outline,
                  label: 'Datos personales',
                  onTap: () => Navigator.pushNamed(context, '/editar-perfil'),
                  isFirst: true,
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _MenuOpcion(
                  icon: Icons.agriculture_outlined,
                  label: 'Información de la finca',
                  onTap: () => Navigator.pushNamed(context, '/productor/editar-finca'),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _MenuOpcion(
                  icon: Icons.settings_outlined,
                  label: 'Configuración',
                  onTap: () => _mostrarConfiguracion(context),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _MenuOpcion(
                  icon: Icons.lock_outline,
                  label: 'Cambiar contraseña',
                  onTap: () => _mostrarCambiarPassword(context),
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                _MenuOpcion(
                  icon: Icons.help_outline,
                  label: 'Ayuda',
                  onTap: () => Navigator.pushNamed(context, '/centro-ayuda'),
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: TertiaryButton(
              label: 'Cerrar sesión',
              icon: Icons.logout,
              onPressed: _cerrarSesion,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: _navItems,
        currentIndex: _tabActual,
        onTap: _cambiarTab,
      ),
    );
  }

  void _mostrarConfiguracion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const Text('Configuración', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SwitchListTile(
                value: true,
                onChanged: (val) {},
                title: const Text('Notificaciones push'),
                secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryColor),
              ),
              SwitchListTile(
                value: false,
                onChanged: (val) {},
                title: const Text('Modo Oscuro'),
                secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryColor),
              ),
              ListTile(
                leading: const Icon(Icons.language, color: AppColors.primaryColor),
                title: const Text('Idioma'),
                trailing: const Text('Español', style: TextStyle(color: AppColors.TextSoft)),
                onTap: () {},
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _mostrarCambiarPassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text('Cambiar Contraseña', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),
              const PasswordField(
                label: 'Contraseña Actual',
                hint: 'Ingresa tu contraseña',
              ),
              const SizedBox(height: 12),
              const PasswordField(
                label: 'Nueva Contraseña',
                hint: 'Ingresa la nueva contraseña',
              ),
              const SizedBox(height: 12),
              const PasswordField(
                label: 'Confirmar Nueva Contraseña',
                hint: 'Repite la nueva contraseña',
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Guardar Contraseña',
                radius: 12,
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contraseña actualizada')));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.bodyText),
              const SizedBox(width: 5),
              Text(label, style: AppTextStyles.SubTitle.copyWith(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.label.copyWith(
              fontSize: 13,
              color: AppColors.titleDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuOpcion extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _MenuOpcion({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(14) : Radius.zero,
        bottom: isLast ? const Radius.circular(14) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.bodyText),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.titleDark,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.chipGrey,
            ),
          ],
        ),
      ),
    );
  }
}
