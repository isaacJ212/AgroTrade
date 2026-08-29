import 'package:agrotrade_frontend/screens/shared/auth/Login.dart';
import 'package:flutter/material.dart';
import '../../../ui/app_theme.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final AnimationController _taglineController;
  late final Animation<double> _taglineOpacity;
  late final Animation<Offset> _taglineSlide;

  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _logoScale = Tween<double>(begin: 0.70, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _ejecutarSecuencia();
  }

  Future<void> _ejecutarSecuencia() async {
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, anim2) => const Login(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (ctx, animation, secondaryAnim, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.12),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.White,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_logoController, _pulseController]),
              builder: (context, _) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value * _pulse.value,
                    child: Image.asset(
                      'lib/assets/images/LogoApp.png',
                      width: 160,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _taglineSlide,
              child: FadeTransition(
                opacity: _taglineOpacity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'Conectando el campo con nuevas oportunidades',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.SubTitle.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.bodyText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
