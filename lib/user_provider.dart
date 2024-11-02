import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nombre = '';
  String _direccion = '';
  String _correo = '';
  String _numero = '';
  String _cumpleanos = ''; // Nuevo campo para cumpleaños

  // Getters
  String get nombre => _nombre;
  String get direccion => _direccion;
  String get correo => _correo;
  String get numero => _numero;
  String get cumpleanos => _cumpleanos;

  // Setters
  void setUserData(String nombre, String direccion, String correo, String numero, String cumpleanos) {
    _nombre = nombre;
    _direccion = direccion;
    _correo = correo;
    _numero = numero;
    _cumpleanos = cumpleanos;
    notifyListeners();
  }

  // Para borrar datos de sesión al cerrar sesión
  void clearUserData() {
    _nombre = '';
    _direccion = '';
    _correo = '';
    _numero = '';
    _cumpleanos = '';
    notifyListeners();
  }
}
