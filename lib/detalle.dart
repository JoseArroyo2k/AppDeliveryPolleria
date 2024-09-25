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
        title: Text(widget.nombre),
        backgroundColor: Colors.green[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen del producto
            Image.network(
              widget.imagenUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Nombre del producto
            Text(
              widget.nombre,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Descripción del producto
            Text(
              widget.descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Precio y botones para controlar la cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: _reducirCantidad,
                ),
                Text(
                  '$_cantidad',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _aumentarCantidad,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Botón de añadir o actualizar el carrito
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
              icon: Icon(Icons.shopping_cart),
              label: Text('Añadir al carrito'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
