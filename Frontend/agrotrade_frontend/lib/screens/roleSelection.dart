import 'package:flutter/foundation.dart';

import 'Login.dart';
import 'onBoarding.dart';
import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';

class Rol {
  final int RolId;
  final String NombreRol;
  final String Description;
  final IconData icono;
  const Rol({
    required this.RolId,
    required this.NombreRol,
    required this.Description,
    required this.icono,
  });
}

class Roleselection extends StatefulWidget {
  const Roleselection({super.key});

  @override
  State<Roleselection> createState() => _RoleSelection();
}

class _RoleSelection extends State<Roleselection> {
  int? _rolSeleccionado;

  final List<Rol> _Roles = const [
    Rol(
      RolId: 1,
      NombreRol: "Cliente",
      icono: Icons.shopping_basket_outlined,
      Description: "Encuentra Productos frescos y compra directo",
    ),
    Rol(
      RolId: 2,
      NombreRol: "Proveedor",
      icono: Icons.agriculture_outlined,
      Description: "Publica productos, gestiona inventario y recibe pedidos",
    ),
    Rol(
      RolId: 3,
      NombreRol: "Repartidor",
      icono: Icons.local_shipping_outlined,
      Description: "Gestiona entregas y acepta entregas de pedidos",
    ),
  ];

  void _continuar() {
    FocusScope.of(context).unfocus();
    var RolSeleccionado = _Roles.firstWhere((r) => r.RolId == _rolSeleccionado);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Continuar Como ${RolSeleccionado.NombreRol}"),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // Aqui solo esperamos que implementen las homes segun cada rol
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selecciona Tu Perfil", style: AppTextStyles.Title),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: _Roles.map(
                    (rol) => RoleCard(
                      icon: rol.icono,
                      title: rol.NombreRol,
                      description: rol.Description,
                      selected: _rolSeleccionado == rol.RolId,
                      onTap: () => setState(() => _rolSeleccionado = rol.RolId),
                    ),
                  ).toList(),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: "Continuar",
                onPressed: _rolSeleccionado == null ? null : _continuar,
                radius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
