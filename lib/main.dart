import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'homepage.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase aquí
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
      initialRoute: '/home', // Ruta inicial
      routes: {
        '/home': (context) => HomePage(), // Página de bienvenida con el logo
        '/login': (context) => LoginPage(), // Pantalla de login
        '/register': (context) => RegisterPage(), // Pantalla de registro
        '/homepage': (context) => CategoryHomePage(), // Pantalla principal de categorías
      },
    );
  }
}
