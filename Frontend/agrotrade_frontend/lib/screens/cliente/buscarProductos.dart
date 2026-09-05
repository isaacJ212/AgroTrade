import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/components.dart';
import 'carrito.dart';
import '../../models/Consumidor/consumidor_models.dart';
import 'inicioComprador.dart';
import 'perfilProductor.dart';
import '../../services/consumer_api_service.dart';

class FiltrosMercado {
  final Set<String> categorias;
  final double distanciaMax;
  final double? precioMin;
  final double? precioMax;
  final bool disponibleAhora;
  final bool pocoInventario;
  final String? metodoEntrega;

  const FiltrosMercado({
    this.categorias = const {},
    this.distanciaMax = 25,
    this.precioMin,
    this.precioMax,
    this.disponibleAhora = true,
    this.pocoInventario = false,
    this.metodoEntrega,
  });
}

class BuscarProductos extends StatefulWidget {
  const BuscarProductos({super.key});

  @override
  State<BuscarProductos> createState() => _BuscarProductosState();
}

class _BuscarProductosState extends State<BuscarProductos> {
  final TextEditingController _searchController = TextEditingController();
  FiltrosMercado _filtros = const FiltrosMercado();

  List<ProductoMercado> _productos = [];
  bool _isLoading = true;
  int _page = 1;
  int _totalPages = 1;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _page = 1;
        _cargarProductos();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    setState(() => _isLoading = true);
    final response = await ConsumerApiService.instance.getProductos(
      page: _page, 
      limit: 20, 
      search: _searchController.text.trim()
    );
    if (mounted) {
      setState(() {
        _productos = response.items;
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    }
  }

  double _distanciaKm(ProductoMercado p) =>
      double.tryParse(p.distancia.split(' ').first) ?? 0;

  List<ProductoMercado> get _resultados => _productos.where((p) {
    final porCat =
        _filtros.categorias.isEmpty ||
        _filtros.categorias.map((c) => c.toLowerCase()).contains(p.categoria.toLowerCase());

    final porDist = _distanciaKm(p) <= _filtros.distanciaMax;

    final porPrecio =
        (_filtros.precioMin == null || p.precio >= _filtros.precioMin!) &&
        (_filtros.precioMax == null || p.precio <= _filtros.precioMax!);

    final porStock = _pasaStock(p);

    return porCat && porDist && porPrecio && porStock;
  }).toList();

  bool _pasaStock(ProductoMercado p) {
    if (_filtros.disponibleAhora && _filtros.pocoInventario) return true;
    if (_filtros.disponibleAhora) return !p.pocoInventario;
    if (_filtros.pocoInventario) return p.pocoInventario;
    return true;
  }

  Future<void> _abrirFiltros() async {
    final resultado = await showModalBottomSheet<FiltrosMercado>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.scaffoldBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _FiltrosSheet(initial: _filtros),
    );
    if (resultado != null) setState(() => _filtros = resultado);
  }


  @override
  Widget build(BuildContext context) {
    final resultados = _resultados;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
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
        title: Text(
          'Buscar',
          style: AppTextStyles.headline.copyWith(
            fontSize: 20,
            color: AppColors.primarySoft,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.tune,
              color: AppColors.primaryColor,
              size: 22,
            ),
            onPressed: _abrirFiltros,
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.titleDark,
              size: 22,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CarritoScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buscador(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Text(
              '${resultados.length} productos encontrados',
              style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                : resultados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 40,
                            color: AppColors.bodyText,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sin resultados con estos filtros',
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : _grid(resultados),
            ),
            _paginacionWidget(),
          ],
        ),
      );
    }

    Widget _paginacionWidget() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: AppColors.White,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: _page > 1 && !_isLoading
                  ? () {
                      _page--;
                      _cargarProductos();
                    }
                  : null,
              icon: const Icon(Icons.chevron_left),
              label: const Text('Anterior'),
            ),
            Text('Página $_page de ${max(1, _totalPages)}'),
            TextButton(
              onPressed: _page < _totalPages && !_isLoading
                  ? () {
                      _page++;
                      _cargarProductos();
                    }
                  : null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('Siguiente'), Icon(Icons.chevron_right)],
              ),
            ),
          ],
        ),
      );
    }

    Widget _buscador() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.inputBorderColor.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, size: 20, color: AppColors.bodyText),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar productos',
                  hintStyle: AppTextStyles.SubTitle.copyWith(
                    fontSize: 13,
                    color: AppColors.bodyText.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: AppColors.bodyText,
                    ),
                    onPressed: () => setState(() => _searchController.clear()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _grid(List<ProductoMercado> lista) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 180,
      ),
      itemCount: lista.length,
      itemBuilder: (context, i) => _GridCard(
        producto: lista[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PerfilProductorScreen()),
        ),
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final ProductoMercado producto;
  final VoidCallback onTap;

  const _GridCard({required this.producto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              producto.imagenUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: AppColors.tileBg,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 24,
                  color: AppColors.bodyText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      fontSize: 13,
                      color: AppColors.titleDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'C\$ ${producto.precio.toStringAsFixed(2)} / ${producto.unidad}',
                    style: AppTextStyles.label.copyWith(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                    ),
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

class _FiltrosSheet extends StatefulWidget {
  final FiltrosMercado initial;

  const _FiltrosSheet({required this.initial});

  @override
  State<_FiltrosSheet> createState() => _FiltrosSheetState();
}

class _FiltrosSheetState extends State<_FiltrosSheet> {
  late final Set<String> _cats = {...widget.initial.categorias};
  late double _distancia = widget.initial.distanciaMax;
  late final TextEditingController _minC = TextEditingController(
    text: widget.initial.precioMin?.toString() ?? '',
  );
  late final TextEditingController _maxC = TextEditingController(
    text: widget.initial.precioMax?.toString() ?? '',
  );
  late bool _disp;
  late bool _poco;
  late String? _metodo;

  List<String> _catsDisponibles = [
    'Frutas',
    'Cítricos',
    'Verduras',
    'Tubérculos',
  ];
  bool _cargandoCats = true;

  @override
  void initState() {
    super.initState();
    _disp = widget.initial.disponibleAhora;
    _poco = widget.initial.pocoInventario;
    _metodo = widget.initial.metodoEntrega;
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final cats = await ConsumerApiService.instance.getCategoriasActivas();
      if (mounted && cats.isNotEmpty) {
        setState(() {
          _catsDisponibles = cats;
          _cargandoCats = false;
        });
      } else {
        setState(() => _cargandoCats = false);
      }
    } catch (e) {
      if (mounted) setState(() => _cargandoCats = false);
    }
  }

  @override
  void dispose() {
    _minC.dispose();
    _maxC.dispose();
    super.dispose();
  }

  void _limpiar() {
    setState(() {
      _cats.clear();
      _distancia = 25;
      _minC.clear();
      _maxC.clear();
      _disp = true;
      _poco = false;
      _metodo = null;
    });
  }

  void _aplicar() {
    Navigator.pop(
      context,
      FiltrosMercado(
        categorias: _cats,
        distanciaMax: _distancia,
        precioMin: double.tryParse(_minC.text),
        precioMax: double.tryParse(_maxC.text),
        disponibleAhora: _disp,
        pocoInventario: _poco,
        metodoEntrega: _metodo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollCtrl) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: ListView(
          controller: scrollCtrl,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filtros',
                  style: AppTextStyles.Title.copyWith(fontSize: 18),
                ),
                TextButton(
                  onPressed: _limpiar,
                  child: const Text(
                    'Limpiar',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Categorías',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _cargandoCats
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _catsDisponibles.map((cat) {
                    final sel = _cats.contains(cat);
                    return FilterChip(
                      label: Text(cat),
                      selected: sel,
                      onSelected: (val) => setState(() {
                        val ? _cats.add(cat) : _cats.remove(cat);
                      }),
                      selectedColor: AppColors.primarySoftBg,
                      checkmarkColor: AppColors.primaryColor,
                      labelStyle: TextStyle(
                        color: sel ? AppColors.primaryColor : AppColors.titleDark,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
            const SizedBox(height: 20),
            Text(
              'Distancia máxima: ${_distancia.toInt()} km',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            Slider(
              value: _distancia,
              min: 1,
              max: 50,
              divisions: 49,
              activeColor: AppColors.primaryColor,
              onChanged: (v) => setState(() => _distancia = v),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Aplicar Filtros',
              radius: 10,
              onPressed: _aplicar,
            ),
          ],
        ),
      ),
    );
  }
}
