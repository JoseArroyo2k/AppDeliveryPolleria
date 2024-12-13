import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'homepage.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'cart_provider.dart';
import 'user_provider.dart';
import 'carrito.dart'; // Importa la página del carrito

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Añadimos el UserProvider
      ],
      child: MaterialApp(
        title: 'Polleria Delivery',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        initialRoute: '/home', // Ruta inicial regresando al HomePage
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/homepage': (context) => CategoryHomePage(),
          '/cart': (context) => CarritoPage(), // Ruta del carrito
        },
      ),
    );
  }
}
