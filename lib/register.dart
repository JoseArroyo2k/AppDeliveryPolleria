import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'googlemaps_picker.dart';
import 'user_provider.dart';

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
  TextEditingController _birthdayController = TextEditingController();

  Map<String, dynamic>? _selectedLocation;

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

  // Método para seleccionar la ubicación usando GoogleMapsLocationPicker
  Future<void> _selectLocation() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleMapsLocationPicker(),
          fullscreenDialog: true
        ),
      );

      if (result != null) {
        setState(() {
          _selectedLocation = result;
          _addressController.text = result['address'] ?? 
            'Lat: ${result['latitude']}, Lng: ${result['longitude']}';
        });
      }
    } catch (e) {
      print('Error al seleccionar la ubicación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error al seleccionar la ubicación.')),
      );
    }
  }

  // Método para registrar al usuario en Firestore
  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_isValidDateFormat(_birthdayController.text)) {
        if (_selectedLocation == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Por favor selecciona tu ubicación en el mapa')),
          );
          return;
        }

        try {
          await _firestore.collection('Usuarios').add({
            'nombre': _nameController.text,
            'email': _emailController.text,
            'telefono': _phoneController.text,
            'direccion': _addressController.text,
            'ubicacion_coordenadas': {
              'latitude': _selectedLocation!['latitude'],
              'longitude': _selectedLocation!['longitude']
            },
            'ubicacion_nombre': _selectedLocation!['address'] ?? 'Ubicación no especificada',
            'cumpleanos': _birthdayController.text,
            'password': _hashPassword(_passwordController.text),
            'tipo': 'cliente',
          });

          // Actualizar UserProvider
          Provider.of<UserProvider>(context, listen: false).setUserData(
            _nameController.text,
            _addressController.text,
            _emailController.text,
            _phoneController.text,
            _birthdayController.text
          );

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
    }
  }

  // Método para construir TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon, color: Color(0xFF800020)),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondopollo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.05,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Regístrate para comenzar',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    // Campo de nombre
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Nombre',
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Campo de correo
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'Correo electrónico',
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El correo es requerido';
                        }
                        if (!value.contains('@')) {
                          return 'Ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Campo de teléfono
                    _buildTextField(
                      controller: _phoneController,
                      hintText: 'Teléfono',
                      prefixIcon: Icons.phone,
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
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Campo de ubicación
                    GestureDetector(
                      onTap: _selectLocation,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on, color: Color(0xFF800020)),
                            hintText: 'Selecciona tu ubicación',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.map, color: Color(0xFF800020)),
                              onPressed: _selectLocation,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (_selectedLocation == null) {
                              return 'La ubicación es requerida';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Campo de cumpleaños
                    _buildTextField(
                      controller: _birthdayController,
                      hintText: 'Cumpleaños (dd/mm/yyyy)',
                      prefixIcon: Icons.cake,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
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
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Campo de contraseña
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'Contraseña',
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La contraseña es requerida';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    // Botón de registro
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        backgroundColor: Color(0xFF800020),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        ),
                      ),
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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