import 'package:flutter/material.dart';
import 'package:agrotrade_frontend/screens/registro.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text("AgroTrade"))),
    );
  }
}
