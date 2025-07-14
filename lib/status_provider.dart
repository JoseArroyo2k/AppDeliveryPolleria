import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatusProvider with ChangeNotifier {
  String _pedidoId = '';
  String _estado = '';
  bool _hayPedidoActivo = false;

  // Getters
  String get pedidoId => _pedidoId;
  String get estado => _estado;
  bool get hayPedidoActivo => _hayPedidoActivo;

  // Inicializar el pedido con el ID y el estado inicial
  Future<void> inicializarPedido(String pedidoId) async {
    _pedidoId = pedidoId;
    _hayPedidoActivo = true;

    // Escuchar cambios en el estado del pedido desde Firebase
    FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedidoId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _estado = snapshot.data()?['estado'] ?? '';
        notifyListeners();
      }
    });
  }

  // Limpiar el estado del pedido
  void limpiarPedido() {
    _pedidoId = '';
    _estado = '';
    _hayPedidoActivo = false;
    notifyListeners();
  }
}
