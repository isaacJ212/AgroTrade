import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/models/rol.dart';
import 'package:agrotrade_frontend/routes/app_routes.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';

class Roleselection extends StatefulWidget {
  const Roleselection({super.key});

  @override
  State<Roleselection> createState() => _RoleSelection();
}

class _RoleSelection extends State<Roleselection> {
  int? _rolSeleccionado;

  final List<Rol> _roles = const [
    Rol(
      RolId: 1,
      NombreRol: "Cliente",
      icono: Icons.shopping_basket_outlined,
      Description: "Encuentra productos frescos y compra directo del campo",
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
      Description: "Gestiona entregas y acepta rutas de pedidos",
    ),
  ];

  void _continuar() {
    FocusScope.of(context).unfocus();
    if (_rolSeleccionado == null) return;
    
    print("DEBUG: [RoleSelection] Rol seleccionado: $_rolSeleccionado, navegando a Registro");
    // Aquí idealmente pasaríamos el _rolSeleccionado a la pantalla de registro
    // Por ahora, navegamos a registro.
    Navigator.pushReplacementNamed(context, AppRoutes.registro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Selecciona Tu Perfil", style: AppTextStyles.Title),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: _roles.map(
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
