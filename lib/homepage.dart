import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener dimensiones de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08, // Margen horizontal proporcional
              vertical: screenHeight * 0.05, // Margen vertical proporcional
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo con tamaño proporcional
                      Image.asset(
                        'assets/images/Logo.png',
                        height: screenHeight * 0.2, // Proporcional al alto
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Título con tamaño adaptado
                      Text(
                        'Gran Chicken',
                        style: TextStyle(
                          fontSize: screenWidth * 0.1, // Escalado según ancho
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Descripción con tamaño adaptado
                      Text(
                        'Disfruta toda la carta de pollos a la brasa, carnes, caldos y demás',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Escalado según ancho
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenedor de botones
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.05), // Espaciado adaptable
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Botón de Iniciar Sesión
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF800020), // Color guinda
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02, // Altura del botón adaptable
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05, // Escalado según ancho
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Botón de Registrarse
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02, // Altura del botón adaptable
                          ),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF800020), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05, // Escalado según ancho
                            color: Color(0xFF800020),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
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
