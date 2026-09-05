import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../models/productor_models.dart';
import '../../routes/productor_navigation.dart';
import '../app_theme.dart';
import 'productor_bottom_nav.dart';

void mensajeProductor(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
}

bool accionProductor(BuildContext context, VoidCallback action) {
  try {
    action();
    return true;
  } on StateError catch (e) {
    mensajeProductor(context, e.message);
    return false;
  }
}

class ProductorPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final int? rootIndex;
  final List<Widget>? actions;
  final Widget? bottom, floatingActionButton;
  const ProductorPage({
    super.key,
    required this.title,
    required this.children,
    this.rootIndex,
    this.actions,
    this.bottom,
    this.floatingActionButton,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(
          fontFamily: 'Raleway',
          bodyColor: AppColors.TextMain,
          displayColor: AppColors.TextMain,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          surface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.inputBorderColor),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.TextMain,
          ),
          iconTheme: IconThemeData(color: AppColors.TextMain),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: rootIndex == null,
          centerTitle: false,
          actions: actions,
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  floatingActionButton != null ? 100 : 28,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: children,
              ),
            ),
          ),
        ),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: rootIndex != null
            ? ProductorBottomNav(
                currentIndex: rootIndex!,
                onTap: (index) {
                  if (index != rootIndex)
                    ProductorNavigation.cambiarTab(context, index);
                },
                items: const [
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
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag,
                  ),
                  NavElemento(
                    label: 'Perfil',
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                  ),
                ],
              )
            : bottom == null
            ? null
            : ColoredBox(
                color: Colors.white,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: bottom,
                  ),
                ),
              ),
      ),
    );
  }
}

class ProductorCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const ProductorCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: child,
  );
}

class ProductorSection extends StatelessWidget {
  final String text;
  const ProductorSection(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14, top: 8),
    child: Text(text, style: AppTextStyles.sectionTitle),
  );
}

class ProductorButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined, danger;
  const ProductorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.danger = false,
  });
  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.errorColor : AppColors.primaryColor;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    );
    return SizedBox(
      width: double.infinity,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(
                  color: onPressed == null ? AppColors.cardBorder : color,
                ),
                shape: shape,
                minimumSize: const Size(0, 48),
                textStyle: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: shape,
                minimumSize: const Size(0, 48),
                textStyle: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: child,
            ),
    );
  }
}

class ProductorField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool readOnly, obscure;
  final int maxLines;
  const ProductorField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboard,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.obscure = false,
    this.maxLines = 1,
    this.focusNode,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboard,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
      ),
    ),
  );
}

class ProductorMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final String? subtitle;
  const ProductorMenuItem({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Icon(icon, color: AppColors.primaryColor),
    title: Text(label),
    subtitle: subtitle == null
        ? null
        : Text(subtitle!, style: AppTextStyles.SubTitle),
    trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

class ProductorStatus extends StatelessWidget {
  final String text;
  final bool warning;
  final IconData? icon;
  const ProductorStatus(
    this.text, {
    super.key,
    this.warning = false,
    this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: warning ? AppColors.amberSoft : AppColors.primarySoftBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: warning ? AppColors.warning : AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

class ProductorImage extends StatelessWidget {
  final String url;
  final Uint8List? bytes;
  final double height;
  final double? width;
  final IconData icon;
  const ProductorImage({
    super.key,
    this.url = '',
    this.bytes,
    this.height = 160,
    this.width,
    this.icon = Icons.agriculture_outlined,
  });
  @override
  Widget build(BuildContext context) {
    Widget fallback() => Container(
      color: AppColors.primarySoftBg,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.primaryColor, size: 36),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: width ?? double.infinity,
        child: bytes != null
            ? Image.memory(
                bytes!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback(),
              )
            : url.isEmpty
            ? fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback(),
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : fallback(),
              ),
      ),
    );
  }
}

class ProductorStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final VoidCallback? onTap;
  const ProductorStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: ProductorCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryColor),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.statValue),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.SubTitle),
        ],
      ),
    ),
  );
}

class ProductorOrderTile extends StatelessWidget {
  final PedidoRecibido pedido;
  final VoidCallback onTap;
  const ProductorOrderTile({
    super.key,
    required this.pedido,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ProductorCard(
    padding: EdgeInsets.zero,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(pedido.codigo, style: AppTextStyles.productoTitle),
                ProductorStatus(
                  pedido.estado.label,
                  warning:
                      pedido.estado == EstadoPedido.pendiente ||
                      pedido.estado == EstadoPedido.rechazado,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(pedido.cliente),
            const SizedBox(height: 6),
            Text(fechaCorta(pedido.fecha), style: AppTextStyles.SubTitle),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    pedido.montoTexto,
                    style: AppTextStyles.statValue,
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.primaryColor),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class ProductorEmpty extends StatelessWidget {
  final String text;
  const ProductorEmpty(this.text, {super.key});
  @override
  Widget build(BuildContext context) => ProductorCard(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 36,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class ProductorMap extends StatelessWidget {
  final String label;
  const ProductorMap({super.key, required this.label});
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Representación de la zona: $label',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: CustomPaint(
          painter: ProductorMapPainter(),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Icon(Icons.location_on, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class ProductorMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFD1FAE5),
    );
    final grid = Paint()
      ..color = const Color(0xFFB9EDD3)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(size.width * .45, 0),
      Offset(size.width * .45, size.height),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * .5),
      Offset(size.width, size.height * .5),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant ProductorMapPainter oldDelegate) => false;
}
