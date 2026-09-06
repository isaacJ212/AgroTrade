import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import '../shared/profile.dart';
import 'inicioComprador.dart';
import 'seguimientoPedido.dart';
import 'valorarPedido.dart';
import '../../services/consumer_api_service.dart';

enum _EstadoPedido { confirmado, enCamino, entregado }

class _Pedido {
  final String numero;
  final double total;
  final _EstadoPedido estado;
  final String fecha;
  final String? productores;
  final List<String> imagenesUrl;
  final String? finca;
  final String? destino;

  const _Pedido({
    required this.numero,
    required this.total,
    required this.estado,
    required this.fecha,
    this.productores,
    this.imagenesUrl = const [],
    this.finca,
    this.destino,
  });
}

class MisPedidosScreen extends StatefulWidget {
  const MisPedidosScreen({super.key});

  @override
  State<MisPedidosScreen> createState() => _MisPedidosScreenState();
}

class _MisPedidosScreenState extends State<MisPedidosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  List<_Pedido> _pedidos = [];
  bool _cargando = true;

  List<_Pedido> get _todos => _pedidos;
  List<_Pedido> get _enCurso => _pedidos
      .where(
        (p) =>
            p.estado == _EstadoPedido.confirmado ||
            p.estado == _EstadoPedido.enCamino,
      )
      .toList();
  List<_Pedido> get _entregados =>
      _pedidos.where((p) => p.estado == _EstadoPedido.entregado).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _cargarPedidos();
  }
  
  Future<void> _cargarPedidos() async {
    final pedApi = await ConsumerApiService.instance.getMisPedidos();
    
    // Map API models to UI models
    final pedUI = pedApi.map((p) {
      _EstadoPedido estado;
      switch (p.estado.toLowerCase()) {
        case 'entregado':
          estado = _EstadoPedido.entregado;
          break;
        case 'encamino':
        case 'en camino':
          estado = _EstadoPedido.enCamino;
          break;
        default:
          estado = _EstadoPedido.confirmado;
      }
      return _Pedido(
        numero: p.id,
        total: p.total,
        estado: estado,
        fecha: p.fecha,
        productores: '${p.itemsCount} productos',
      );
    }).toList();
    
    if (mounted) {
      setState(() {
        _pedidos = pedUI;
        _cargando = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_Pedido> get _pedidosFiltrados {
    switch (_tabController.index) {
      case 0:
        return _todos;
      case 1:
        return _enCurso;
      case 2:
        return _entregados;
      default:
        return _todos;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: AnimatedBuilder(
              animation: _tabController,
              builder: (_, __) {
                if (_cargando) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
                }
                final lista = _pedidosFiltrados;
                if (lista.isEmpty) {
                  return _buildVacio();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  itemCount: _agruparPorFecha(lista).length,
                  itemBuilder: (context, i) {
                    final entry = _agruparPorFecha(lista).entries.elementAt(i);
                    return _buildGrupo(entry.key, entry.value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
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
        'Mis pedidos',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Profile()),
            ),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.primarySoftBg,
              child: const Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.TextSoft,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 2.5,
        onTap: (_) => setState(() {}),
        tabs: const [
          Tab(text: 'Todos'),
          Tab(text: 'En curso'),
          Tab(text: 'Entregados'),
        ],
      ),
    );
  }

  Map<String, List<_Pedido>> _agruparPorFecha(List<_Pedido> lista) {
    final Map<String, List<_Pedido>> map = {};
    for (final p in lista) {
      map.putIfAbsent(p.fecha, () => []).add(p);
    }
    return map;
  }

  Widget _buildGrupo(String fecha, List<_Pedido> pedidos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 4),
          child: Text(
            fecha,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.TextSoft,
              letterSpacing: 0.3,
            ),
          ),
        ),
        ...pedidos.map((p) => _buildCard(p)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCard(_Pedido p) {
    switch (p.estado) {
      case _EstadoPedido.confirmado:
        return _CardConfirmado(pedido: p);
      case _EstadoPedido.enCamino:
        return _CardEnCamino(pedido: p);
      case _EstadoPedido.entregado:
        return _CardEntregado(pedido: p);
    }
  }

  Widget _buildVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 36,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sin pedidos aquí',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.titleDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Cuando realices un pedido\naparecerá en esta sección.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.TextSoft),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardConfirmado extends StatelessWidget {
  final _Pedido pedido;
  const _CardConfirmado({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedido #${pedido.numero}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _BadgeEstado(estado: pedido.estado),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'C\$${pedido.total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.TextSoft,
            ),
          ),
          if (pedido.productores != null) ...[
            const SizedBox(height: 6),
            Text(
              pedido.productores!,
              style: const TextStyle(fontSize: 13, color: AppColors.TextSoft),
            ),
          ],
          if (pedido.imagenesUrl.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: pedido.imagenesUrl
                  .map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primarySoftBg,
                              child: const Icon(
                                Icons.image_outlined,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SeguimientoPedidoScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                side: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Ver pedido',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardEnCamino extends StatelessWidget {
  final _Pedido pedido;
  const _CardEnCamino({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      highlighted: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'En tránsito',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.TextSoft,
                ),
              ),
              const Spacer(),
              _BadgeEstado(estado: pedido.estado),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedido #${pedido.numero}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.titleDark,
                  ),
                ),
              ),
              Text(
                'C\$${pedido.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.TextSoft,
                ),
              ),
            ],
          ),

          if (pedido.finca != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: AppColors.TextSoft,
                ),
                const SizedBox(width: 5),
                Text(
                  pedido.finca!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.TextSoft,
                  ),
                ),
              ],
            ),
          ],

          if (pedido.destino != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primarySoftBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Destino',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primarySoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        pedido.destino!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Seguir entrega',
            radius: 100,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SeguimientoPedidoScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CardEntregado extends StatelessWidget {
  final _Pedido pedido;
  const _CardEntregado({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      dimmed: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedido #${pedido.numero}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.TextSoft,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _BadgeEstado(estado: pedido.estado),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'C\$${pedido.total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, color: AppColors.chipGrey),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                final idStr = pedido.numero.replaceAll(RegExp(r'[^0-9]'), '');
                final int idPedido = int.tryParse(idStr) ?? 0;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ValorarPedidoScreen(
                      idPedido: idPedido,
                      idProveedor: 1, // Proveedor fallback para el demo
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.TextSoft,
                side: const BorderSide(color: AppColors.cardBorder, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Valorar pedido',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.TextSoft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  final bool highlighted;
  final bool dimmed;

  const _BaseCard({
    required this.child,
    this.highlighted = false,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? AppColors.primaryColor.withOpacity(0.3)
              : AppColors.cardBorder,
          width: highlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: highlighted
                ? AppColors.primaryColor.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            blurRadius: highlighted ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BadgeEstado extends StatelessWidget {
  final _EstadoPedido estado;
  const _BadgeEstado({required this.estado});

  @override
  Widget build(BuildContext context) {
    switch (estado) {
      case _EstadoPedido.confirmado:
        return _badge(
          icon: Icons.circle,
          iconSize: 8,
          label: 'Confirmado',
          color: const Color(0xFF3B82F6),
          bg: const Color(0xFFEFF6FF),
        );
      case _EstadoPedido.enCamino:
        return _badge(
          icon: Icons.local_shipping_outlined,
          label: 'En camino',
          color: AppColors.primaryColor,
          bg: AppColors.primarySoftBg,
        );
      case _EstadoPedido.entregado:
        return _badge(
          icon: Icons.check_circle_outline_rounded,
          label: 'Entregado',
          color: AppColors.chipGrey,
          bg: AppColors.tileBg,
        );
    }
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    double iconSize = 13,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
