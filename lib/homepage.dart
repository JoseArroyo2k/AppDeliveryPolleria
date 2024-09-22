import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart'; // Pantalla de categorías

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900], // Fondo verde oscuro
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo centrado
            Column(
              children: [
                Image.asset(
                  'assets/images/Logo.png', // Asegúrate que este logo esté bien ubicado
                  height: 180, // Tamaño del logo
                ),
                SizedBox(height: 30),
                Text(
                  'Gran Chicken', // Nombre de la pollería
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Disfruta toda la carta de pollos a la brasa, carnes, caldos y demás',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 50),
                // Botón de Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Botón de Registro
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.orange, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Botón de acceder como invitado
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  child: Text(
                    'Acceder como invitado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
