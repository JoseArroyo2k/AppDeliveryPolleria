import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
import 'homepage.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'cart_provider.dart';
import 'user_provider.dart';
import 'carrito.dart';
import 'status_provider.dart';
import 'detalles_provider.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _determineStartScreen(BuildContext context) async {
    final hasSession = await AuthService.hasSession();

    if (hasSession) {
      final email = await AuthService.getUserSession();
      if (email != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('Usuarios')
            .where('email', isEqualTo: email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();

          // Cargamos los datos en el UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserData(
            userData['nombre'] ?? 'Usuario',
            userData['ubicacion_nombre'] ?? 'Sin dirección',
            userData['ubicacion_coordenadas']?['latitude'] ?? 0.0,
            userData['ubicacion_coordenadas']?['longitude'] ?? 0.0,
            userData['email'] ?? '',
            userData['telefono'] ?? '',
            userData['cumpleanos'] ?? '',
          );

          return CategoryHomePage();
        }
      }
    }

    return HomePage(); // Si no hay sesión o no se encontró el usuario
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DetallesProvider()),
        ChangeNotifierProvider(create: (_) => StatusProvider()),
      ],
      child: MaterialApp(
        title: 'Polleria Delivery',
        debugShowCheckedModeBanner: false,
        locale: const Locale('es'),
        supportedLocales: const [
          Locale('es'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            return FutureBuilder<Widget>(
              future: _determineStartScreen(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return HomePage(); // Fallback
                }
              },
            );
          },
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/homepage': (context) => CategoryHomePage(),
          '/cart': (context) => CarritoPage(),
        },
      ),
    );
  }
}
