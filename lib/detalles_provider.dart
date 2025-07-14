import 'package:flutter/material.dart';

class DetallesProvider with ChangeNotifier {
  String _detallesGenerales = '';
  String _tipoBebida = '';
  String _bebidaSeleccionada = '';
  String _temperaturaBebida = '';
  String _tipoCortePollo = '';
  String _preferenciaCuarto = '';
  String _presaCaldo = '';
  String _terminoCarne = '';

  // Getters
  String get detallesGenerales => _detallesGenerales;
  String get tipoBebida => _tipoBebida;
  String get bebidaSeleccionada => _bebidaSeleccionada;
  String get temperaturaBebida => _temperaturaBebida;
  String get tipoCortePollo => _tipoCortePollo;
  String get preferenciaCuarto => _preferenciaCuarto;
  String get presaCaldo => _presaCaldo;
  String get terminoCarne => _terminoCarne;

  final List<String> bebidasNaturales = [
    'Aguaymanto',
    'Maracuyá',
    'Naranjada',
    'Limonada',
    'Tuna',
    'Chicha',
    'Piña'
  ];

  final List<String> gaseosas = ['Inca Cola', 'Coca Cola'];
  final List<String> presasCaldo = ['Pierna', 'Entrepierna', 'Ala', 'Pecho'];
  final List<String> terminosCarne = [
    'Término 3/4',
    'Término medio',
    'Término bien cocido'
  ];

  void setDetallesGenerales(String detalles) {
    _detallesGenerales = detalles;
    notifyListeners();
  }

  void setBebida(String tipo, String bebida) {
    _tipoBebida = tipo;
    _bebidaSeleccionada = bebida;
    notifyListeners();
  }

  void setTemperaturaBebida(String temperatura) {
    _temperaturaBebida = temperatura;
    notifyListeners();
  }

  void setCortePollo(String tipo, {String? preferencia}) {
    _tipoCortePollo = tipo;
    if (preferencia != null) {
      _preferenciaCuarto = preferencia;
    }
    notifyListeners();
  }

  void setPresaCaldo(String presa) {
    _presaCaldo = presa;
    notifyListeners();
  }

  void setTerminoCarne(String termino) {
    _terminoCarne = termino;
    notifyListeners();
  }

  void limpiarDetalles() {
    _detallesGenerales = '';
    _tipoBebida = '';
    _bebidaSeleccionada = '';
    _temperaturaBebida = '';
    _tipoCortePollo = '';
    _preferenciaCuarto = '';
    _presaCaldo = '';
    _terminoCarne = '';
    notifyListeners();
  }

  Map<String, dynamic> obtenerDetallesCompletos() {
    return {
      'detalles_generales': _detallesGenerales,
      'bebida': _tipoBebida.isNotEmpty
          ? {
              'tipo': _tipoBebida,
              'seleccion': _bebidaSeleccionada,
              'temperatura': _temperaturaBebida,
            }
          : null,
      'corte_pollo': _tipoCortePollo.isNotEmpty
          ? {
              'tipo': _tipoCortePollo,
              'preferencia': _preferenciaCuarto,
            }
          : null,
      'presa_caldo': _presaCaldo.isNotEmpty ? _presaCaldo : null,
      'termino_carne': _terminoCarne.isNotEmpty ? _terminoCarne : null,
    };
  }
}