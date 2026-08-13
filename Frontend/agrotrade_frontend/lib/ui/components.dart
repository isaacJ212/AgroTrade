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
          foregroundColor: AppColors.accentBlue,
          backgroundColor: AppColors.White,
          side: const BorderSide(color: AppColors.accentBlue, width: 1.2),
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

class TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const TertiaryButton({
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
          foregroundColor: AppColors.errorColor,
          backgroundColor: AppColors.White,
          side: const BorderSide(color: AppColors.errorColor, width: 1.2),
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
