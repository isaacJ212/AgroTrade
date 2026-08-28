import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/components.dart';
import '../inicioProductor.dart';

enum EstadoPedido {
  pendiente,
  enPreparacion,
  listo;

  String get label => switch (this) {
        EstadoPedido.pendiente => 'Pendiente',
        EstadoPedido.enPreparacion => 'En Prep',
        EstadoPedido.listo => 'Listo',
      };

  IconData get icon => switch (this) {
        EstadoPedido.pendiente => Icons.schedule,
        EstadoPedido.enPreparacion => Icons.inventory_2_outlined,
        EstadoPedido.listo => Icons.check_circle,
      };

  Color get chipBg => switch (this) {
        EstadoPedido.pendiente => AppColors.amberSoft,
        EstadoPedido.enPreparacion => AppColors.blueSoft,
        EstadoPedido.listo => AppColors.chipGrey,
      };

  Color get chipText => switch (this) {
        EstadoPedido.pendiente => AppColors.amber,
        EstadoPedido.enPreparacion => AppColors.accentBlue,
        EstadoPedido.listo => AppColors.primarySoft,
      };


  Color get blob => switch (this) {
        EstadoPedido.pendiente => AppColors.amberSoft,
        EstadoPedido.enPreparacion => AppColors.blueSoft,
        EstadoPedido.listo => AppColors.primarySoftBg,
      };
}


class PedidoRecibido {
  final String codigo;
  final String cliente;
  final String fecha;
  final double monto;
  final EstadoPedido estado;

  const PedidoRecibido({
    required this.codigo,
    required this.cliente,
    required this.fecha,
    required this.monto,
    required this.estado,
  });


  String get montoTexto {
    final partes = monto.toStringAsFixed(2).split('.');
    final entero = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]},',
    );
    return '\$$entero.${partes[1]}';
  }
}

class PedidosRecibidos extends StatefulWidget {
  const PedidosRecibidos({super.key});

  @override
  State<PedidosRecibidos> createState() => _PedidosRecibidosState();
}

class _PedidosRecibidosState extends State<PedidosRecibidos> {

  EstadoPedido? _filtroActual;


  static const List<PedidoRecibido> _pedidos = [
    PedidoRecibido(
      codigo: '#PED-00124',
      cliente: 'Finca El Carmen',
      fecha: '15 Oct 2024',
      monto: 1450.00,
      estado: EstadoPedido.pendiente,
    ),
    PedidoRecibido(
      codigo: '#PED-00123',
      cliente: 'Cooperativa Los Andes',
      fecha: '14 Oct 2024',
      monto: 890.50,
      estado: EstadoPedido.enPreparacion,
    ),
    PedidoRecibido(
      codigo: '#PED-00120',
      cliente: 'Distribuidora Central',
      fecha: '12 Oct 2024',
      monto: 3200.00,
      estado: EstadoPedido.listo,
    ),
    PedidoRecibido(
      codigo: '#PED-00125',
      cliente: 'Agromercados S.A.',
      fecha: '16 Oct 2024',
      monto: 550.00,
      estado: EstadoPedido.pendiente,
    ),
  ];


  List<PedidoRecibido> get _filtrados => _pedidos
      .where((p) => _filtroActual == null || p.estado == _filtroActual)
      .toList();

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ));
  }

  void _abrirPedido(PedidoRecibido pedido) {
    _mostrarSnack('Abriendo ${pedido.codigo} 📦');
  }

  void _irATab(int index) {
    if (index == 2){
      Navigator.pop(context);
      return;
    }
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioProductor()),
      );
      return;
    }
    _mostrarSnack('Esta sección estará disponible pronto 🌱');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _encabezado(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gestión de Pedidos',
                    style: AppTextStyles.headline.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Administra las compras de tus clientes.',
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 13,
                      color: AppColors.bodyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _tabsFiltro(),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(child: _lista()),
          ],
        ),
      ),
      bottomNavigationBar: ProductorBottomNav(
        items: const [
          NavElemento(label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home),
          NavElemento(label: 'Mercado', icon: Icons.storefront_outlined, activeIcon: Icons.storefront),
          NavElemento(label: 'Pedidos', icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, badge: true),
          NavElemento(label: 'Perfil', icon: Icons.person_outline, activeIcon: Icons.person),
        ],
        currentIndex: 2,
        onTap: _irATab,
      ),
    );
  }

  /// Header con wordmark + acciones (patrón de inventario/calculadora).
  Widget _encabezado() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AgroTrade',
              style: AppTextStyles.wordmark.copyWith(fontSize: 22)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.titleDark, size: 22),
                onPressed: () => _mostrarSnack('Sin notificaciones nuevas'),
              ),
              IconButton(
                icon: const Icon(Icons.account_circle_outlined,
                    color: AppColors.primaryColor, size: 26),
                onPressed: () => _mostrarSnack('Perfil próximamente'),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _tabsFiltro() {
    final filtros = <EstadoPedido?>[null, ...EstadoPedido.values];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (final filtro in filtros) _tabFiltro(filtro),
        ],
      ),
    );
  }

  Widget _tabFiltro(EstadoPedido? filtro) {
    final activo = _filtroActual == filtro;
    return GestureDetector(
      onTap: () => setState(() => _filtroActual = filtro),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              filtro == null ? 'Todos' : '${filtro.label}s', 
              style: AppTextStyles.label.copyWith(
                fontSize: 13,
                color: activo ? AppColors.primarySoft : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 2,
              color: activo ? AppColors.primaryColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }


  Widget _lista() {
    final pedidos = _filtrados;
    if (pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 40, color: AppColors.bodyText),
            const SizedBox(height: 8),
            Text('No hay pedidos en este estado',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 13)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: pedidos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) =>
          _PedidoCard(pedido: pedidos[i], onTap: () => _abrirPedido(pedidos[i])),
    );
  }
}


class _PedidoCard extends StatelessWidget {
  final PedidoRecibido pedido;
  final VoidCallback onTap;

  const _PedidoCard({required this.pedido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(

        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -45,
              right: -45,
              child: Container(
                width: 130,
                height: 130,
                color: pedido.estado.blob,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        pedido.codigo,
                        style: AppTextStyles.label.copyWith(
                          fontSize: 12,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Spacer(), 

                      StatusChip(
                        label: pedido.estado.label,
                        background: pedido.estado.chipBg,
                        color: pedido.estado.chipText,
                        icon: pedido.estado.icon,
                        radius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    pedido.cliente,
                    style: AppTextStyles.productoTitle.copyWith(fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: AppColors.bodyText),
                      const SizedBox(width: 6),
                      Text(
                        pedido.fecha,
                        style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monto Total',
                              style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pedido.montoTexto,
                              style: AppTextStyles.startValue.copyWith(
                                fontSize: 18,
                                color: AppColors.titleDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppColors.accentBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: AppColors.White, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}