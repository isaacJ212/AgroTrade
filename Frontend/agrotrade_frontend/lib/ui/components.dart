import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../models/entrega.dart';

// esto es para el logo de agrotrade pero lo podemos cambiar por el png
class Logo extends StatelessWidget {
  final double size;
  const Logo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "lib/assets/images/logo.png",
      height: size,
      fit: BoxFit.contain,
    );
  }
}

// para los botones verdes
class PrimaryButton extends StatelessWidget {
  final double radius;
  final String label;
  final VoidCallback? onPressed;
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled
              ? AppColors.primaryColor
              : AppColors.disabledbtn,
          foregroundColor: AppColors.White,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.TextMain,
          side: const BorderSide(color: AppColors.inputBorderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// esto es para poner los iconos por ejemplo de email o lupas en los inputs
InputDecoration appInputDecoration({
  String? label,
  String? hint,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.inputBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primarySoft, width: 1.5),
    ),
  );
}

// este es para los inputs en si
class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType keyboard;
  final TextEditingController? controller;
  final String? errorText;
  const AppTextField({
    super.key,
    required this.hint,
    required this.label,
    this.keyboard = TextInputType.text,
    this.errorText,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: appInputDecoration(
        label: label,
        hint: hint,
      ).copyWith(errorText: errorText),
    );
  }
}

// segun lo que aprendi un widget con estado es un widget que puede ser manipulado por el usuario osea que no es estatico
// por eso para el switch de ver contraseña es necesario que este widget sea con stado asi con setState se vuelve a renderizar cuando lo cambias
class PasswordField extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  const PasswordField({
    super.key,
    required this.hint,
    required this.label,
    this.errorText,
    this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordField> {
  bool _obscuro = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscuro,
      decoration: appInputDecoration(
        label: widget.label,
        hint: widget.hint,
        suffixIcon: IconButton(
          icon: Icon(
            _obscuro
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.TextSoft,
          ),
          onPressed: () => setState(() => _obscuro = !_obscuro),
        ),
      ).copyWith(errorText: widget.errorText),
    );
  }
}

class OrDivider extends StatelessWidget {
  final String text;
  const OrDivider({super.key, this.text = "o"});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.inputBorderColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: AppTextStyles.SubTitle),
        ),
        Expanded(child: Divider(color: AppColors.inputBorderColor)),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final bool activo;

  const Dot({super.key, this.activo = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activo ? AppColors.primaryColor : AppColors.inputBorderColor,
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  const RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: true,
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          onTap();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? AppColors.primarySoftBg : AppColors.White,
            border: Border.all(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.inputBorderColor.withOpacity(0.4),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primarySoftBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22),
              ),
              const SizedBox(height: 10),
              Text(title, style: AppTextStyles.Title.copyWith(fontSize: 16)),
              const SizedBox(height: 4),
              Text(description, style: AppTextStyles.SubTitle),
            ],
          ),
        ),
      ),
    );
  }
}

// Tarjeta de métricas reutilizable (ventas, pedidos, alertas).

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final Color? iconColor;
  final Color titleColor;
  final Color background;
  final Color border;
  final bool glow;
  final Widget? footer;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.accent = AppColors.primaryColor,
    this.iconColor,
    this.titleColor = AppColors.bodyText,
    this.background = AppColors.White,
    this.border = AppColors.cardBorder,
    this.glow = false,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // clipBehavior recorta el glow
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),

      child: Stack(
        children: [
          if (glow)
            Positioned(
              top: 4,
              right: -16,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.fabIcon.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: Icon(icon, color: iconColor ?? accent, size: 26),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(color: titleColor),
                ),
                const SizedBox(height: 14),
                Text(
                  value,
                  style: AppTextStyles.statValue.copyWith(color: accent),
                ),
                if (footer != null) ...[const SizedBox(height: 14), footer!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Etiqueta de estado de un pedido
class StatusChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color color;

  const StatusChip({
    super.key,
    required this.label,
    required this.background,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: AppTextStyles.chip.copyWith(color: color)),
    );
  }
}

// Fila de pedido reciente
class PedidoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String titulo;
  final String comprador;
  final String monto;
  final String estado;

  const PedidoTile({
    super.key,
    required this.icon,
    this.iconColor = AppColors.primaryColor,
    required this.titulo,
    required this.comprador,
    required this.monto,
    required this.estado,
  });

  bool get _completado => estado.toLowerCase() == 'completado';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.tileBg,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          // Expanded evita desbordes si el comprador tiene nombre largo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.label.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.titleDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Comprador: $comprador',
                  style: AppTextStyles.SubTitle.copyWith(
                    color: AppColors.bodyText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                monto,
                style: AppTextStyles.label.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.titleDark,
                ),
              ),
              const SizedBox(height: 6),
              StatusChip(
                label: estado,
                background: _completado
                    ? AppColors.chipGrey
                    : AppColors.primaryColor.withOpacity(0.2),
                color: _completado
                    ? AppColors.bodyText
                    : AppColors.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Botón flotante de
class SupportFab extends StatelessWidget {
  final VoidCallback onPressed;

  const SupportFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: const SizedBox(
          width: 56,
          height: 56,
          child: Icon(
            Icons.smart_toy_outlined,
            color: AppColors.fabIcon,
            size: 28,
          ),
        ),
      ),
    );
  }
}

// Barra de navegación inferior del productor.
// Así la lógica de navegación queda en la pantalls
class ProductorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProductorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.White,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),

      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          _item(0, Icons.home_outlined, Icons.home, 'Inicio'),
          _item(1, Icons.explore_outlined, Icons.explore, 'Explorar'),
          _item(
            2,
            Icons.shopping_bag_outlined,
            Icons.shopping_bag,
            'Pedidos',
            badge: true,
          ),
          _item(3, Icons.person_outline, Icons.person, 'Perfil'),
        ],
      ),
    );
  }

  Widget _item(
    int index,
    IconData icon,
    IconData activeIcon,
    String label, {
    bool badge = false,
  }) {
    final bool activo = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: activo ? AppColors.navPill : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      activo ? activeIcon : icon,
                      color: activo
                          ? AppColors.primarySoft
                          : AppColors.bodyText,
                      size: 22,
                    ),
                  ),
                  if (badge)
                    Positioned(
                      top: 5,
                      right: 17,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.inputErrorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                color: activo ? AppColors.titleDark : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class RepartidorBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RepartidorBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.White,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        children: [
          _item(0, Icons.home_outlined, Icons.home, 'Inicio'),
          _item(
            1,
            Icons.local_shipping_outlined,
            Icons.local_shipping,
            'Entregas',
            badge: true,
          ),
          _item(2, Icons.person_outline, Icons.person, 'Perfil'),
        ],
      ),
    );
  }

  Widget _item(
    int index,
    IconData icon,
    IconData activeIcon,
    String label, {
    bool badge = false,
  }) {
    final bool activo = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: activo ? AppColors.navPill : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      activo ? activeIcon : icon,
                      color: activo
                          ? AppColors.primarySoft
                          : AppColors.bodyText,
                      size: 22,
                    ),
                  ),
                  if (badge)
                    Positioned(
                      top: 5,
                      right: 17,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.inputErrorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
                color: activo ? AppColors.titleDark : AppColors.bodyText,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class NotificacionEntregaTile extends StatelessWidget {
  final NotificacionEntrega notificacion; // el modelo que viene del backend
  final VoidCallback? onTap; // qué hacer al tocarla

  const NotificacionEntregaTile({
    super.key,
    required this.notificacion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // 1) Ícono circular verde
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primarySoftBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(width: 12),

            // 2) Textos principales (Expanded para que no desborden)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${notificacion.pedidoId}',
                    style: AppTextStyles.label.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacion.zonaEntrega,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notificacion.tiempoTranscurrido, // "Hace 5 min"
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),

            // 3) Monto + flecha a la derecha
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notificacion.totalFormateado, // "$1250.50"
                  style: AppTextStyles.label.copyWith(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.bodyText,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EntregaDetalleCard extends StatelessWidget {
  final NotificacionEntrega entrega;
  final VoidCallback? onVerDetalle;
  final VoidCallback? onContinuar;

  const EntregaDetalleCard({
    super.key,
    required this.entrega,
    this.onVerDetalle,
    this.onContinuar,
  });

  Color get _colorEstado {
    switch (entrega.estado) {
      case 'Completado':
        return AppColors.bodyText;
      case 'En curso':
        return AppColors.accentBlue;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(12),

        border: Border(
          left: BorderSide(color: _colorEstado, width: 4),
          top: BorderSide(color: AppColors.cardBorder),
          right: BorderSide(color: AppColors.cardBorder),
          bottom: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              ChipEstado(texto: entrega.estado, color: _colorEstado),
              const Spacer(), // empuja la hora a la derecha
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entrega.horaLabel,
                    style: AppTextStyles.SubTitle.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ---- Título ----
          Text(
            entrega.zonaEntrega,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),

          // ---- Zona 2: caja gris de ruta ----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _filaRuta(
                  Icons.location_on_outlined,
                  'Recogida',
                  entrega.zonaEntrega,
                ),
                const SizedBox(height: 10),
                _filaRuta(Icons.flag_outlined, 'Destino', entrega.zonaEntrega),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ---- Zona 3: footer según estado ----
          _footer(),
        ],
      ),
    );
  }

  // Fila ícono + label + valor (se usa 2 veces → se extrae)
  Widget _filaRuta(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, size: 16, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.SubTitle.copyWith(fontSize: 12)),
            const SizedBox(height: 2),
            Text(valor, style: AppTextStyles.label.copyWith(fontSize: 13)),
          ],
        ),
      ],
    );
  }

  // EL PORQUÉ MÁS IMPORTANTE: la UI cambia según el estado con un switch
  Widget _footer() {
    switch (entrega.estado) {
      case 'En curso':
        return SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: onContinuar ?? () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.White,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Continuar entrega',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        );
      case 'Completado':
        return Row(
          children: [
            const Icon(
              Icons.verified_outlined,
              size: 16,
              color: AppColors.bodyText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Entregada a ${entrega.pedidoId ?? '—'} (Firma registrada)',
                style: AppTextStyles.SubTitle.copyWith(fontSize: 12),
              ),
            ),
          ],
        );
      default: // Pendiente
        return Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: onVerDetalle ?? () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
                side: const BorderSide(color: AppColors.accentBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ver detalle',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
    }
  }
}

/// La "pastilla" que muestra estados: Pendiente, En curso, Completado,
/// y también los códigos como #AT-2021.
class ChipEstado extends StatelessWidget {
  final String texto;
  final Color color;

  const ChipEstado({super.key, required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // EL TRUCO: el fondo es el MISMO color pero al 12% de opacidad
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20), // bordes de píldora
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color, // el texto va con el color full
        ),
      ),
    );
  }
}
