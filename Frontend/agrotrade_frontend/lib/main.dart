import 'package:agrotrade_frontend/screens/repartidor/homeRepartidor.dart';
import 'package:agrotrade_frontend/screens/productor/inventario/inventarioProductor.dart';
import 'package:agrotrade_frontend/screens/productor/inventario/registroCosecha.dart';
import 'package:agrotrade_frontend/screens/shared/onboarding/splash.dart';
import 'package:flutter/material.dart';
import 'ui/app_theme.dart';

void main() => runApp(const AgroTradeApp());

class AgroTradeApp extends StatelessWidget {
  const AgroTradeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroTrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.TextMain),
        ),
      ),
      home: const RegistroCosecha(),
    );
  }
}
