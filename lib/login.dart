import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _login() async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('Usuarios')
          .where('email', isEqualTo: _emailController.text)
          .where('password', isEqualTo: _hashPassword(_passwordController.text))
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        String userName = userData['nombre'] ?? 'Usuario';
        String direccion = userData['dir_texto'] ?? '';
        String correo = _emailController.text;
        String numero = userData['telefono'] ?? '';
        String cumpleanos = userData['cumpleanos'] ?? ''; // Obtener cumpleaños

        Provider.of<UserProvider>(context, listen: false)
            .setUserData(userName, direccion, correo, numero, cumpleanos);

        Navigator.pushReplacementNamed(
          context,
          '/homepage',
          arguments: {
            'isRegistered': true,
            'userName': userName,
          },
        );
        print('Usuario autenticado');
      } else {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondopollo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email, color: Color(0xFF800020)),
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
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF800020)),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color(0xFF800020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
