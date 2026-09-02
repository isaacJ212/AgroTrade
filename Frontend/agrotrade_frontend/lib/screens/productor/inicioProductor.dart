import 'package:flutter/material.dart';
import '../../services/api_session.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'package:agrotrade_frontend/models/pedido.dart';
import '../../routes/app_routes.dart';
import '../shared/auth/Login.dart';



class InicioProductor extends StatefulWidget {
  const InicioProductor({super.key});

  @override
  State<InicioProductor> createState() => _InicioProductorState();
}

class _InicioProductorState extends State<InicioProductor> {
  int _tabActual = 0;


  static const List<NavElemento> _navItems = [
    NavElemento(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavElemento(
      label: 'Explorar',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore,
    ),
    NavElemento(
      label: 'Pedidos',
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
      badge: true,
    ),
    NavElemento(
      label: 'Perfil',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  static const List<Pedido> _pedidosRecientes = [
    Pedido(
      id: 4829,
      comprador: 'Mercado Central',
      monto: '\$1,250',
      estado: 'Preparado',
    ),
    Pedido(
      id: 4830,
      comprador: 'Restaurante El cielo',
      monto: '\$12,250',
      estado: 'Listo',
    ),
  ];

  String get _saludo {
    final hora = DateTime.now().hour;
    if (hora < 19) return 'Buenos dias';
    if (hora > 19) return 'Buenas tardes';
    return 'Buenas noches';
  }

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cambiarTab(int index) {
    if (index == _tabActual) return;
    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.inventario);
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, AppRoutes.pedidosRecibidos);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.perfilFinca);
    } else {
      setState(() => _tabActual = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_saludo, ${ApiSession.instance.userName ?? 'Carlos'}', style: AppTextStyles.headline),
                      const SizedBox(height: 8),
                      Text(
                        'Aquí tienes un resumen de tu actividad de hoy.',
                        style: AppTextStyles.SubTitle.copyWith(
                          fontSize: 12,
                          color: AppColors.bodyText,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar sesión',
                  onPressed: () {
                    ApiSession.instance.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                      (_) => false,
                    );
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.bodyText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),


            StatCard(
              title: 'Ventas del Mes',
              value: '\$45,200',
              icon: Icons.trending_up,
              glow: true,
              footer: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '+12% ',
                      style: AppTextStyles.label.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'vs mes pasado',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: AppColors.titleDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

        
            StatCard(
              title: 'Pedidos Pendientes',
              value: '14',
              icon: Icons.pending_actions,
              accent: AppColors.titleDark,
              iconColor: AppColors.amber,
              footer: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pushReplacementNamed(
                  context, AppRoutes.pedidosRecibidos,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primarySoft,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.primarySoft,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

        
            StatCard(
              title: 'Alertas de Inventario',
              value: '3',
              icon: Icons.warning,
              accent: AppColors.errorDark,
              iconColor: AppColors.inputErrorColor,
              titleColor: AppColors.errorDark,
              background: AppColors.errorBg,
              border: AppColors.inputErrorColor.withValues(alpha: 0.2),
              footer: Text(
                'Tomates (Bajo stock)',
                style: AppTextStyles.cardTitle.copyWith(
                  color: AppColors.errorDark,
                ),
              ),
            ),
            const SizedBox(height: 32),

        
            Text('Pedidos Recientes', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),
            _tarjetaPedidosRecientes(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SupportFab(
          icono: Icons.smart_toy_outlined,
          onPressed: () => Navigator.pushNamed(context, '/chat', arguments: {'contactName': 'Soporte AgroTrade', 'contactRole': 'Asistencia Técnica'}),
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: _navItems,
        currentIndex: _tabActual,
        onTap: _cambiarTab,
      ),
    );
  }


  Widget _tarjetaPedidosRecientes() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _pedidosRecientes.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.cardBorder),
            PedidoTile(
              icon: _pedidosRecientes[i].estado == 'Completado'
                  ? Icons.check_circle_outline
                  : Icons.local_shipping_outlined,
              iconColor: _pedidosRecientes[i].estado == 'Completado'
                  ? AppColors.bodyText
                  : AppColors.primaryColor,
              titulo: 'Pedido #${_pedidosRecientes[i].id}',
              comprador: _pedidosRecientes[i].comprador,
              monto: _pedidosRecientes[i].monto,
              estado: _pedidosRecientes[i].estado,
            ),
          ],
        ],
      ),
    );
  }
}
