import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Función para encriptar la contraseña (igual que en el registro)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _login() async {
    try {
      // Consultar Firestore para verificar si existe el usuario con la contraseña encriptada
      QuerySnapshot userSnapshot = await _firestore
          .collection('Usuarios')
          .where('email', isEqualTo: _emailController.text)
          .where('password', isEqualTo: _hashPassword(_passwordController.text))
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Usuario encontrado, redirigir al HomePage
        Navigator.pushReplacementNamed(context, '/homepage');
        print('Usuario autenticado');
      } else {
        // Usuario no encontrado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Correo o contraseña incorrectos')),
        );
      }
    } catch (e) {
      print('Error al autenticar el usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenido de nuevo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Inicia sesión para continuar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 40),
              // Campo de correo
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.orange),
                  hintText: 'Correo electrónico',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Campo de contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.orange),
                  hintText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 40),
              // Botón de login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
