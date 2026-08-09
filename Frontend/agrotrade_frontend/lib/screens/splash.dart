import 'package:flutter/material.dart';
import '../ui/app_theme.dart';
import '../ui/components.dart';
import 'onBoarding.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // para que solo sea al inicio
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnBoarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Logo(size: 34),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Text(
                "Conectando el campo con nuevas oportunidades",
                textAlign: TextAlign.center,
                style: AppTextStyles.SubTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
