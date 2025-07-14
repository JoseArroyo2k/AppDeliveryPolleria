class Carrito {
  final String nombre;
  final double precio;
  int cantidad;
  final String imagenUrl;
  final Map<String, dynamic> detalles; // Añadimos campo para detalles específicos

  Carrito({
    required this.nombre,
    required this.precio,
    required this.imagenUrl,
    this.cantidad = 1,
    this.detalles = const {}, // Valor por defecto como mapa vacío
  });

  // Método para incrementar la cantidad
  void incrementarCantidad() {
    cantidad++;
  }

  // Método para decrementar la cantidad
  void decrementarCantidad() {
    if (cantidad > 1) {
      cantidad--;
    }
  }
}