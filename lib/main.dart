import 'package:flutter/material.dart';
import 'homepage.dart'; // Importa la página de inicio

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Polleria Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: HomePage(), // Establecemos HomePage como la primera pantalla
    );
  }
}
