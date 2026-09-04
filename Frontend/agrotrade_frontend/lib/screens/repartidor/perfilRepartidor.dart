import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/buttons.dart';
import '../../ui/widgets/profile_menu_item.dart';
import '../shared/auth/Login.dart';
import 'centroAyudaRepartidor.dart';
import 'configuracionRepartidor.dart';
import 'datosPersonalesRepartidor.dart';
import 'miVehiculoRepartidor.dart';
import 'repartidor_demo.dart';
import 'repartidor_navigation.dart';
import '../../ui/widgets/repartidor_widgets.dart';

class PerfilRepartidor extends StatelessWidget {
  const PerfilRepartidor({super.key});

  void _cerrarSesion(BuildContext context) {
    ApiSession.instance.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const Login()),
      (_) => false,
    );
  }

  void _abrirPantalla(BuildContext context, Widget pantalla) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    final datos = RepartidorDemo.instance;
    final sesion = ApiSession.instance.userName?.trim();
    final nombre = sesion == null || sesion.isEmpty ? 'Juan Pérez' : sesion;

    return AnimatedBuilder(
      animation: datos,
      builder: (context, _) => RepartidorScaffold(
        titulo: 'Mi perfil',
        tab: 3,
        fondo: AppColors.screenBg,
        onBack: () => navegarRepartidor(context, 3, 0),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            RepartidorCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            border: Border.all(
                              color: AppColors.White,
                              width: 2,
                            ),
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
                    style: RepartidorTextStyles.nombrePerfil,
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
                          style: RepartidorTextStyles.chip.copyWith(
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
                      datos.disponible
                          ? 'Repartidor · Disponible'
                          : 'Fuera de servicio',
                      style: RepartidorTextStyles.chip.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Jinotepe, Carazo',
                    style: RepartidorTextStyles.SubTitle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RepartidorCard(
              padding: EdgeInsets.zero,
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
                    icon: Icons.settings_outlined,
                    title: 'Configuración',
                    onTap: () => _abrirPantalla(
                      context,
                      const ConfiguracionRepartidor(),
                    ),
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
      ),
    );
  }
}
