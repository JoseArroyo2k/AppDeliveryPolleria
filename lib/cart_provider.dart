import 'package:flutter/material.dart';
import 'package:polleriadelivery/models/carrito_model.dart';

class CartProvider with ChangeNotifier {
  List<Carrito> _items = [];

  List<Carrito> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  void addItem(String nombre, double precio, String imagenUrl, int cantidad, Map<String, dynamic> detalles) {
    final index = _items.indexWhere((item) => item.nombre == nombre && _compararDetalles(item.detalles, detalles));

    if (index >= 0) {
      // Si el producto ya está en el carrito con los mismos detalles, solo actualizamos la cantidad
      _items[index].cantidad += cantidad;
    } else {
      // Si es un nuevo producto o tiene detalles diferentes, lo agregamos como nuevo item
      _items.add(Carrito(
        nombre: nombre, 
        precio: precio, 
        imagenUrl: imagenUrl, 
        cantidad: cantidad,
        detalles: detalles,
      ));
    }
    notifyListeners();
  }

  // Método auxiliar para comparar si dos mapas de detalles son iguales
  bool _compararDetalles(Map<String, dynamic> detalles1, Map<String, dynamic> detalles2) {
    if (detalles1.length != detalles2.length) return false;
    
    for (var key in detalles1.keys) {
      if (!detalles2.containsKey(key)) return false;
      if (detalles1[key] != detalles2[key]) return false;
    }
    
    return true;
  }

  void updateItemQuantity(String nombre, int nuevaCantidad, Map<String, dynamic> detalles) {
    final index = _items.indexWhere((item) => 
        item.nombre == nombre && _compararDetalles(item.detalles, detalles));
    
    if (index >= 0) {
      _items[index].cantidad = nuevaCantidad;
      notifyListeners();
    }
  }

  void removeItem(String nombre, Map<String, dynamic> detalles) {
    _items.removeWhere((item) => 
        item.nombre == nombre && _compararDetalles(item.detalles, detalles));
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}