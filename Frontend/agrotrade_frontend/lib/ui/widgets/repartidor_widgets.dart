import 'package:flutter/material.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/repartidor_bottom_nav.dart';
import '../../screens/repartidor/repartidor_navigation.dart';

class RepartidorTextStyles {
  static const Title = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.TextMain,
  );
  static const SubTitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.TextSoft,
  );
  static const label = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.TextMain,
  );
  static const sectionTitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.titleDark,
  );
  static const productoTitle = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.titleDark,
  );
  static const statValue = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );
  static const chip = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.TextMain,
  );
  static const menu = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.TextMain,
  );
  static const nombrePerfil = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.TextMain,
  );
  static const boton = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}

class RepartidorTheme extends StatelessWidget {
  final Widget child;
  const RepartidorTheme({super.key, required this.child});

  static ThemeData data(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: 'Raleway'),
      primaryTextTheme: base.primaryTextTheme.apply(fontFamily: 'Raleway'),
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primaryColor,
        onPrimary: AppColors.White,
        secondary: AppColors.primaryColor,
        surface: AppColors.White,
        onSurface: AppColors.TextMain,
      ),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: RepartidorTextStyles.Title,
      ),
      listTileTheme: base.listTileTheme.copyWith(
        titleTextStyle: RepartidorTextStyles.menu,
        subtitleTextStyle: RepartidorTextStyles.SubTitle,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: RepartidorTextStyles.boton,
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle: RepartidorTextStyles.SubTitle,
        labelStyle: RepartidorTextStyles.label,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
        selectionHandleColor: AppColors.primaryColor,
        selectionColor: AppColors.primaryGlow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: data(context),
    child: DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'Raleway'),
      child: child,
    ),
  );
}

class MetricasRepartidor extends StatelessWidget {
  final List<String> etiquetas;
  final List<String> valores;
  final List<IconData> iconos;
  const MetricasRepartidor({
    super.key,
    required this.etiquetas,
    required this.valores,
    required this.iconos,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final grande = MediaQuery.textScalerOf(context).scale(12) > 16;
      final columnas = constraints.maxWidth >= 300 && !grande ? 3 : 1;
      final ancho = (constraints.maxWidth - (columnas - 1) * 12) / columnas;
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (var i = 0; i < etiquetas.length; i++)
            SizedBox(
              width: ancho,
              child: RepartidorCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(iconos[i], size: 22, color: AppColors.primaryColor),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        valores[i],
                        style: RepartidorTextStyles.statValue.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      etiquetas[i],
                      style: RepartidorTextStyles.SubTitle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    },
  );
}

String dineroRepartidor(num valor) => 'C\$ ${valor.toStringAsFixed(2)}';

class RepartidorScaffold extends StatelessWidget {
  final String titulo;
  final Widget body;
  final int? tab;
  final bool volver;
  final List<Widget>? acciones;
  final Color fondo;
  final VoidCallback? onBack;
  const RepartidorScaffold({
    super.key,
    required this.titulo,
    required this.body,
    this.tab,
    this.volver = false,
    this.acciones,
    this.fondo = AppColors.scaffoldBg,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return RepartidorTheme(
      child: Scaffold(
        backgroundColor: fondo,
        appBar: AppBar(
          title: Text(
            titulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: RepartidorTextStyles.Title,
          ),
          centerTitle: false,
          leading: onBack == null
              ? null
              : IconButton(
                  tooltip: 'Volver',
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.titleDark,
                  ),
                  onPressed: onBack,
                ),
          automaticallyImplyLeading: volver,
          backgroundColor: AppColors.White,
          foregroundColor: AppColors.TextMain,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: acciones,
        ),
        body: SafeArea(top: false, bottom: tab == null, child: body),
        bottomNavigationBar: tab == null
            ? null
            : RepartidorBottomNav(
                currentIndex: tab!,
                onTap: (index) => navegarRepartidor(context, tab!, index),
              ),
      ),
    );
  }
}

class RepartidorCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const RepartidorCard({
    super.key,
    required this.child,
    this.color = AppColors.White,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: child,
  );
}

class RepartidorBoton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool secundario;
  const RepartidorBoton({
    super.key,
    required this.label,
    this.onPressed,
    this.secundario = false,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );
    return SizedBox(
      width: double.infinity,
      child: secundario
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                minimumSize: const Size(0, 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                side: const BorderSide(color: AppColors.primaryColor),
                shape: shape,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: RepartidorTextStyles.boton,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.White,
                disabledBackgroundColor: AppColors.cardBorder,
                disabledForegroundColor: AppColors.TextSoft,
                elevation: 0,
                minimumSize: const Size(0, 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: shape,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: RepartidorTextStyles.boton,
              ),
            ),
    );
  }
}

// Reemplazo simple para EstadoEntregaChip - usa un string de estado en lugar de EntregaDemo
class EstadoEntregaChip extends StatelessWidget {
  final String estado; // 'pendiente', 'en_curso', 'completada'
  const EstadoEntregaChip({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final pendiente = estado == 'pendiente';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: pendiente ? AppColors.amberSoft : AppColors.navPill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado.toUpperCase(),
        style: RepartidorTextStyles.chip.copyWith(
          color: pendiente ? AppColors.warning : AppColors.primaryColor,
        ),
      ),
    );
  }
}

class DatoRepartidor extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  const DatoRepartidor({
    super.key,
    required this.icon,
    required this.titulo,
    required this.valor,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: RepartidorTextStyles.SubTitle),
              const SizedBox(height: 4),
              Text(
                valor,
                style: RepartidorTextStyles.label.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Reemplazo simple para EntregaDemoCard - usa datos simples en lugar de EntregaDemo
class EntregaDemoCard extends StatelessWidget {
  final int pedidoId;
  final String zonaEntrega;
  final double totalPedido;
  final String estado;
  final VoidCallback? onTap;
  const EntregaDemoCard({
    super.key,
    required this.pedidoId,
    required this.zonaEntrega,
    required this.totalPedido,
    required this.estado,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => RepartidorCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Entrega #AT-$pedidoId',
              style: RepartidorTextStyles.productoTitle,
            ),
            _EstadoChip(estado: estado),
          ],
        ),
        const SizedBox(height: 12),
        _DatoSimple(
          icon: Icons.storefront_outlined,
          titulo: 'Recogida',
          valor: '—',
        ),
        _DatoSimple(
          icon: Icons.location_on_outlined,
          titulo: 'Destino',
          valor: zonaEntrega,
        ),
        const Divider(height: 24, color: AppColors.cardBorder),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            Text('— productos', style: RepartidorTextStyles.SubTitle),
            Text(
              'Pago: \$${totalPedido.toStringAsFixed(2)}',
              style: RepartidorTextStyles.label.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RepartidorBoton(
          label: estado == 'en_curso' ? 'Continuar entrega' : 'Ver detalle',
          onPressed: () {},
        ),
      ],
    ),
  );
}

class _EstadoChip extends StatelessWidget {
  final String estado;
  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final pendiente = estado == 'pendiente';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: pendiente ? AppColors.amberSoft : AppColors.navPill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado.toUpperCase(),
        style: RepartidorTextStyles.chip.copyWith(
          color: pendiente ? AppColors.warning : AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _DatoSimple extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  const _DatoSimple({
    required this.icon,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: RepartidorTextStyles.SubTitle),
              const SizedBox(height: 4),
              Text(
                valor,
                style: RepartidorTextStyles.label.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Reemplazo simple para ProductoRepartidorRow - usa datos simples
class ProductoRepartidorRow extends StatelessWidget {
  final String nombre;
  final String cantidadUnidad;
  final String precio;
  final String subtotal;
  final String? imagen;
  const ProductoRepartidorRow({
    super.key,
    required this.nombre,
    required this.cantidadUnidad,
    required this.precio,
    required this.subtotal,
    this.imagen,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imagen != null
                ? Image.network(
                    imagen!,
                    fit: BoxFit.cover,
                    width: 56,
                    height: 56,
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: AppColors.navPill,
                      child: Center(
                        child: Icon(
                          Icons.eco_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  )
                : const ColoredBox(
                    color: AppColors.navPill,
                    child: Center(
                      child: Icon(
                        Icons.eco_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre, style: RepartidorTextStyles.label),
              const SizedBox(height: 4),
              Text(cantidadUnidad, style: RepartidorTextStyles.SubTitle),
              const SizedBox(height: 4),
              Text(
                subtotal,
                style: RepartidorTextStyles.label.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

void mostrarInfoRepartidor(BuildContext context, String titulo, String texto) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.White,
      surfaceTintColor: Colors.transparent,
      title: Text(titulo, style: RepartidorTextStyles.Title),
      content: SingleChildScrollView(
        child: Text(texto, style: RepartidorTextStyles.SubTitle),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}
