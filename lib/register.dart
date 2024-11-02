import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
  TextEditingController _birthdayController = TextEditingController(); // Nuevo campo para cumpleaños

  // Función para encriptar la contraseña
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validación de formato de fecha
  bool _isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return regex.hasMatch(date);
  }

  // Función para guardar el usuario en Firestore
  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_isValidDateFormat(_birthdayController.text)) { // Verificación del formato de fecha
        try {
          await _firestore.collection('Usuarios').add({
            'nombre': _nameController.text,
            'email': _emailController.text,
            'telefono': _phoneController.text,
            'direccion': _addressController.text,
            'cumpleanos': _birthdayController.text,
            'password': _hashPassword(_passwordController.text),
            'tipo': 'cliente',
          });
          print('Usuario guardado correctamente en Firestore');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado exitosamente')),
          );

          await Future.delayed(Duration(seconds: 1));
          Navigator.pushReplacementNamed(context, '/home');
        } catch (e) {
          print('Error al guardar el usuario en Firestore: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al registrar el usuario')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Formato de fecha inválido')),
        );
      }
    } else {
      print('Formulario no válido');
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
                        prefixIcon: Icon(Icons.person, color: Color(0xFF800020)),
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
                        if (!value.contains('@')) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
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
                    // Campo de teléfono
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El teléfono es requerido';
                        }
                        if (!RegExp(r'^9[0-9]{8}$').hasMatch(value)) {
                          return 'El teléfono debe comenzar con 9 y tener 9 dígitos';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF800020)),
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
                        prefixIcon: Icon(Icons.home, color: Color(0xFF800020)),
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
                    // Campo de cumpleaños con inserción automática de '/'
                    TextFormField(
                      controller: _birthdayController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10), // Limita a 10 caracteres
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          String text = newValue.text.replaceAll('/', '');
                          if (text.length >= 2) text = text.substring(0, 2) + '/' + text.substring(2);
                          if (text.length >= 5) text = text.substring(0, 5) + '/' + text.substring(5);
                          return newValue.copyWith(
                            text: text,
                            selection: TextSelection.collapsed(offset: text.length),
                          );
                        }),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.cake, color: Color(0xFF800020)),
                        hintText: 'Cumpleaños (dd/mm/yyyy)',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        return null;
                      },
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
                    // Botón de registro
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Color(0xFF800020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Regístrate',
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
      ),
    );
  }
}
