import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _nombre = '';
  String _direccionTextual = '';
  double _latitud = 0.0;
  double _longitud = 0.0;
  String _correo = '';
  String _numero = '';
  String _cumpleanos = '';

  // Getters
  String get nombre => _nombre;
  String get direccionTextual => _direccionTextual;
  double get latitud => _latitud;
  double get longitud => _longitud;
  String get correo => _correo;
  String get numero => _numero;
  String get cumpleanos => _cumpleanos;

  // Setters
  void setUserData(
    String nombre,
    String direccionTextual,
    double latitud,
    double longitud,
    String correo,
    String numero,
    String cumpleanos,
  ) {
    _nombre = nombre;
    _direccionTextual = direccionTextual;
    _latitud = latitud;
    _longitud = longitud;
    _correo = correo;
    _numero = numero;
    _cumpleanos = cumpleanos;
    notifyListeners();
  }

  void clearUserData() {
    _nombre = '';
    _direccionTextual = '';
    _latitud = 0.0;
    _longitud = 0.0;
    _correo = '';
    _numero = '';
    _cumpleanos = '';
    notifyListeners();
  }
}