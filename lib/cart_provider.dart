import 'package:flutter/material.dart';
import 'package:polleriadelivery/models/carrito_model.dart'; // Ruta corregida

class CartProvider with ChangeNotifier {
  List<Carrito> _items = []; // Lista bien definida de tipo Carrito

  List<Carrito> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.precio * item.cantidad));
  }

  void addItem(String nombre, double precio, String imagenUrl, int cantidad) {
    final index = _items.indexWhere((item) => item.nombre == nombre);

    if (index >= 0) {
      // Si el producto ya está en el carrito, solo actualizamos la cantidad sumándola
      _items[index].cantidad += cantidad;
    } else {
      // Si es un nuevo producto, lo agregamos con la cantidad especificada
      _items.add(Carrito(nombre: nombre, precio: precio, imagenUrl: imagenUrl, cantidad: cantidad));
    }
    notifyListeners();
  }

  void updateItemQuantity(String nombre, int nuevaCantidad) {
    final index = _items.indexWhere((item) => item.nombre == nombre);
    if (index >= 0) {
      _items[index].cantidad = nuevaCantidad;
      notifyListeners();
    }
  }

  void removeItem(String nombre) {
    _items.removeWhere((item) => item.nombre == nombre);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
