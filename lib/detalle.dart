import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart'; // Importamos el CartProvider

class DetalleProductoPage extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;

  DetalleProductoPage({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
  });

  @override
  _DetalleProductoPageState createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  int _cantidad = 1;

  void _aumentarCantidad() {
    setState(() {
      _cantidad++;
    });
  }

  void _reducirCantidad() {
    if (_cantidad > 1) {
      setState(() {
        _cantidad--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombre,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora',
          ),
        ),
        backgroundColor: Color(0xFF800020), // Fondo guinda
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del producto con borde guinda y tamaño más grande
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF800020), width: 3), // Borde guinda
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imagenUrl,
                  height: 350, // Aumentamos la altura de la imagen
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Nombre del producto en mayúsculas y color guinda
            Text(
              widget.nombre.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF800020), // Color guinda
                fontFamily: 'Lora', // Usamos la fuente Lora
              ),
            ),
            SizedBox(height: 10),
            // Descripción con texto más grande
            Text(
              widget.descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18), // Aumentamos el tamaño de la descripción
            ),
            SizedBox(height: 20),
            // Precio y botones para controlar la cantidad con estilo mejorado
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _reducirCantidad,
                  color: Color(0xFF800020), // Color guinda para los botones
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF800020), width: 2), // Borde guinda alrededor del número
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_cantidad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF800020), // Color guinda
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _aumentarCantidad,
                  color: Color(0xFF800020), // Color guinda para los botones
                ),
              ],
            ),
            SizedBox(height: 20),
            // Botón de añadir al carrito con estilo guinda y letras blancas
            ElevatedButton.icon(
              onPressed: () {
                // Añadimos el producto al carrito utilizando el Provider y pasando la cantidad seleccionada
                Provider.of<CartProvider>(context, listen: false).addItem(
                  widget.nombre,
                  widget.precio,
                  widget.imagenUrl,
                  _cantidad, // Pasamos la cantidad seleccionada
                );
                Navigator.pop(context); // Cierra la ventana al añadir/actualizar
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white, // Ícono del carrito en blanco
              ),
              label: Text(
                'AÑADIR AL CARRITO',
                style: TextStyle(
                  color: Colors.white, // Letras blancas
                  fontFamily: 'Lora',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF800020), // Fondo guinda
              ),
            ),
          ],
        ),
      ),
    );
  }
}
