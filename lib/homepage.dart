import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondopollo.jpg'), // Fondo de la imagen
            fit: BoxFit.cover, // Ajuste para cubrir toda la pantalla
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo aumentado en tamaño
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 180, // Aumentado en 50%
                      ),
                      SizedBox(height: 20),
                      // App name (Gran Chicken) con tamaño aumentado
                      Text(
                        'Gran Chicken',
                        style: TextStyle(
                          fontSize: 52, // Tamaño aumentado en 30%
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter', // Usar fuente Inter
                        ),
                      ),
                      SizedBox(height: 20),
                      // Descripción con mayor tamaño y grosor
                      Text(
                        'Disfruta toda la carta de pollos a la brasa, carnes, caldos y demás',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18, // Tamaño aumentado
                          color: Colors.white.withOpacity(0.9), // Mayor contraste
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600, // Letras más gruesas
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Buttons container
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Botón de Iniciar Sesión con color guinda
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF800020), // Color guinda
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold, // Letras gruesas
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Botón de Registrarse con letras blancas y fondo guinda
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white, // Fondo blanco
                          side: BorderSide(color: Color(0xFF800020), width: 2), // Borde guinda
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF800020), // Letras guinda
                            fontWeight: FontWeight.bold, // Letras gruesas
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      // El botón de "Acceder como invitado" ya no aparecerá
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
