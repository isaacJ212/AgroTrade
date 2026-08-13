import 'package:flutter/material.dart';
import 'app_theme.dart';

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
                Text(title, style: AppTextStyles.cardTitle.copyWith(color: titleColor)),
                const SizedBox(height: 14),
                Text(value, style: AppTextStyles.statValue.copyWith(color: accent)),
                if (footer != null) ...[
                  const SizedBox(height: 14),
                  footer!,
                ],
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
  //eaqui se agrega lo que es una restructuracion
  final IconData? icon;
  final double radius;

  const StatusChip({
    super.key,
    required this.label,
    required this.background,
    required this.color,
    this.icon,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null) ...[
            Icon(icon, size: 14, color: color,),
            const SizedBox(width: 4,),
          ],
        ],
      ),
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
                  style: AppTextStyles.SubTitle.copyWith(color: AppColors.bodyText),
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
                color: _completado ? AppColors.bodyText : AppColors.primaryColor,
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
  //FAB cuadrada generica
  final IconData icono;
  final Color colorIcono;
  final VoidCallback onPressed;

  const SupportFab({
  super.key, 
  required this.icono,
  required this.onPressed,
  this.colorIcono = AppColors.fabIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: SizedBox(
          width: 56,
          height: 56,
          child: Icon(icono, color: colorIcono, size: 28),
        ),
      ),
    );
  }
}
 

 //este es para el modela de la barra asica cada antalla puede 
 //declara sus propio TABS

class NavElemento{
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool badge;

  const NavElemento({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge = false,

  });
 }

// Barra de navegación inferior del productor.
// Así la lógica de navegación queda en la pantalls
class ProductorBottomNav extends StatelessWidget {
  final List<NavElemento> items;// ahora lo que es la liosta viene de afuerta
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ProductorBottomNav({
    super.key,
    required this.items,
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
          // 📚 collection-for con índice para saber cuál es el activo
          for (int i = 0; i < items.length; i++) _item(i, items[i]),
        ],
      ),
    );
  }


  Widget _item(int index, NavElemento elemento) {
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
                      activo ? (elemento.activeIcon ?? elemento.icon) : elemento.icon,
                      color: activo ? AppColors.primarySoft : AppColors.bodyText,
                      size: 22,
                    ),
                  ),
                  if (elemento.badge)
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
              elemento.label,
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



// esto son parte del inventario 
//en este caso se hace lo que fila valor

class InfoRow extends StatelessWidget{
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.titleDark
  });

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.cardTitle),
        // lo quees el Flexible eevita overflow si n este caso el valor es largo
        Flexible(child: Text(
          value,
          textAlign: TextAlign.right,
          style: AppTextStyles.label.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        )),
      ],
    );

  }
  
}


// este es para lo que wes el boton gris de accion secundaria

class NeutralButton extends StatelessWidget{
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color textColor;

  const NeutralButton({
    super.key,
    required this.label,
    this.onPressed,
    this.background = AppColors.tileBg,
    this.textColor = AppColors.titleDark,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}


