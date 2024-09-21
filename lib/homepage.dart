import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart'; // Importa home.dart donde tienes la nueva clase 'CategoryHomePage'

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900], // Fondo verde oscuro para resaltar el logo
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
                  'assets/images/Logo.png', // Asegúrate de que el logo esté en esta ruta
                  height: 180, // Tamaño del logo ajustado
                ),
                SizedBox(height: 30),
                Text(
                  'Gran Chicken', // Nombre de la pollería
                  style: TextStyle(
                    fontSize: 48, // Tamaño adecuado
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins', // Fuente moderna
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
                    fontFamily: 'Poppins', // Fuente moderna
                    height: 1.5, // Mejora el espaciado de las líneas
                  ),
                ),
                SizedBox(height: 50),
                // Botón de Iniciar Sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange, // Color naranja vivo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Bordes más suaves
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'Poppins', // Fuente moderna
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
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
                        fontFamily: 'Poppins', // Fuente moderna
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Botón de acceder como invitado
                TextButton(
                  onPressed: () {
                    // Navegar a la página CategoryHomePage con categorías
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryHomePage()), // Aquí va la página con el menú de categorías
                    );
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
