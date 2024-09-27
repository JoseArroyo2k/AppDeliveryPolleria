import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nombre = '';
  String _direccion = '';
  String _correo = '';
  String _numero = '';

  // Getters
  String get nombre => _nombre;
  String get direccion => _direccion;
  String get correo => _correo;
  String get numero => _numero;

  // Setters
  void setUserData(String nombre, String direccion, String correo, String numero) {
    _nombre = nombre;
    _direccion = direccion;
    _correo = correo;
    _numero = numero;
    notifyListeners();
  }

  // Para borrar datos de sesión al cerrar sesión si fuera necesario
  void clearUserData() {
    _nombre = '';
    _direccion = '';
    _correo = '';
    _numero = '';
    notifyListeners();
  }
}
