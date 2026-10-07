import 'package:agrotrade_frontend/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'config/env.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    MapboxOptions.setAccessToken(EnvConfig.mapboxAccessToken);
  }
  
  runApp(const AgroTradeApp());
}

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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.TextMain),
        ),
      ),

      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
