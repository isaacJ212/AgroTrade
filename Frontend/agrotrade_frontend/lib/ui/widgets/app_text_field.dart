import 'package:flutter/material.dart';
import '../app_theme.dart';

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
