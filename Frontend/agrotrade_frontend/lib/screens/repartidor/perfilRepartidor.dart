import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../services/auth_api_service.dart';
import '../../services/repartidor_api_service.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/buttons.dart';
import '../../ui/widgets/profile_menu_item.dart';
import '../shared/auth/Login.dart';
import 'centroAyudaRepartidor.dart';
import 'configuracionRepartidor.dart';
import 'datosPersonalesRepartidor.dart';
import '../shared/change_password_dialog.dart';
import 'miVehiculoRepartidor.dart';
import 'repartidor_navigation.dart';
import '../shared/bank_accounts_screen.dart';

class PerfilRepartidor extends StatefulWidget {
  const PerfilRepartidor({super.key});

  @override
  State<PerfilRepartidor> createState() => _PerfilRepartidorState();
}

class _PerfilRepartidorState extends State<PerfilRepartidor> {
  bool _disponible = false;

  Future<void> _cerrarSesion(BuildContext context) async {
    await AuthApiService.instance.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const Login()),
      (_) => false,
    );
  }

  void _abrirPantalla(BuildContext context, Widget pantalla) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => pantalla));
  }

  Future<void> _cargarDisponibilidad() async {
    try {
      final estado = await RepartidorApiService.instance
          .getEstadoVerificacion();
      if (mounted) {
        setState(() {
          _disponible = estado.estaVerificado;
        });
      }
    } catch (_) {
      // Ignorar error
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarDisponibilidad();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = ApiSession.instance.userName?.trim();
    final nombre = sesion == null || sesion.isEmpty ? 'Repartidor' : sesion;

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Mi perfil', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(20),
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
                          Icons.local_shipping_outlined,
                          size: 14,
                          color: AppColors.White,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.Title.copyWith(fontSize: 20),
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
                        'Cuenta verificada',
                        style: AppTextStyles.chip.copyWith(
                          fontSize: 11,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
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
                  child: Text(
                    _disponible
                        ? 'Repartidor · Disponible'
                        : 'Fuera de servicio',
                    style: AppTextStyles.chip.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '—',
                  style: AppTextStyles.SubTitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.White,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'Mis entregas',
                  onTap: () => navegarRepartidor(context, 3, 1),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Datos personales',
                  onTap: () => _abrirPantalla(
                    context,
                    DatosPersonalesRepartidor(nombre: nombre),
                  ),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.two_wheeler,
                  title: 'Mi vehículo',
                  onTap: () =>
                      _abrirPantalla(context, const MiVehiculoRepartidor()),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.account_balance_outlined,
                  title: 'Cuentas bancarias',
                  onTap: () =>
                      _abrirPantalla(context, const BankAccountsScreen()),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () => showChangePasswordDialog(context),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  onTap: () =>
                      _abrirPantalla(context, const ConfiguracionRepartidor()),
                ),
                const Divider(
                  height: 1,
                  indent: 48,
                  color: AppColors.cardBorder,
                ),
                ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Centro de ayuda',
                  onTap: () =>
                      _abrirPantalla(context, const CentroAyudaRepartidor()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          TertiaryButton(
            label: 'Cerrar Sesión',
            icon: Icons.logout,
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
    );
  }
}
