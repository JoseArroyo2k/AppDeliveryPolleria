class Carrito {
  final String nombre;
  final double precio;
  int cantidad;
  final String imagenUrl; // Nuevo campo para la URL de la imagen

  Carrito({
    required this.nombre,
    required this.precio,
    required this.imagenUrl, // Requerimos la imagen
    this.cantidad = 1,
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
