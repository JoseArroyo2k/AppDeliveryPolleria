import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Para la función utf8.encode

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // Función para encriptar la contraseña
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Codifica la contraseña a bytes
    var digest = sha256.convert(bytes); // Aplica SHA256
    return digest.toString(); // Retorna la contraseña encriptada
  }

  // Función para guardar el usuario en Firestore
  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Guardado de los datos del usuario en Firestore
        await _firestore.collection('Usuarios').add({
          'nombre': _nameController.text,
          'email': _emailController.text,
          'telefono': _phoneController.text,
          'dir_texto': _addressController.text,
          'dir_geo': [0, 0], // Usamos [0, 0] temporalmente
          'password': _hashPassword(_passwordController.text), // Guardar la contraseña encriptada
          'tipo': 'cliente',
        });
        print('Usuario guardado correctamente en Firestore');

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado exitosamente')),
        );

        // Redirigir al HomePage (la ruta correcta) después de un segundo
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, '/home'); // Cambié a la ruta correcta
      } catch (e) {
        print('Error al guardar el usuario en Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar el usuario')),
        );
      }
    } else {
      print('Formulario no válido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Form(
            key: _formKey,
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
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Regístrate para comenzar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 40),
                // Campo de nombre
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.orange),
                    hintText: 'Nombre',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Campo de correo
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo es requerido';
                    }
                    return null;
                  },
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
                // Campo de teléfono
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El teléfono es requerido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.orange),
                    hintText: 'Teléfono',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Campo de dirección
                TextFormField(
                  controller: _addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La dirección es requerida';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home, color: Colors.orange),
                    hintText: 'Dirección',
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
                TextFormField(
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
                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Regístrate',
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
      ),
    );
  }
}
