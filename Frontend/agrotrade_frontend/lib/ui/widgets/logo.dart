import 'package:flutter/material.dart';

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
