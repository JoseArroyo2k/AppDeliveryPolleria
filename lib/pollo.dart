import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle.dart'; // Importamos la página de detalles
import 'carrito.dart'; // Importa la página de carrito

class PolloPage extends StatefulWidget {
  @override
  _PolloPageState createState() => _PolloPageState();
}

class _PolloPageState extends State<PolloPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> polloProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchPolloProducts();
  }

  void _fetchPolloProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Productos')
          .where('Categoria', isEqualTo: 'Pollo')
          .get();

      setState(() {
        polloProducts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error al obtener productos de la categoría Pollo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pollo a la brasa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Lora'),
        ),
        backgroundColor: Color(0xFF800020), // Fondo guinda para la cabecera
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white), // Carrito en blanco
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarritoPage()),
              );
            },
          ),
        ],
      ),
      body: polloProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: polloProducts.length,
              itemBuilder: (context, index) {
                var product = polloProducts[index];
                try {
                  var nombre = product['Nombre'] ?? 'Producto sin nombre';
                  var precio = product['Precio']?.toString() ?? 'Precio no disponible';
                  var imagenUrl = product['Imagen'] ?? 'https://via.placeholder.com/150';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleProductoPage(
                              nombre: nombre,
                              descripcion: product['Descripcion'] ?? '',
                              precio: double.parse(precio),
                              imagenUrl: imagenUrl,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xFF800020), width: 4.0), // Borde guinda más grueso
                          color: Colors.white, // Fondo blanco
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Imagen del producto
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.network(
                                imagenUrl,
                                height: MediaQuery.of(context).size.height * 0.25, // Imagen más grande
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red); // Icono en caso de error
                                },
                              ),
                            ),
                            // Recuadro para el nombre y el precio
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9F6F6), // Fondo gris claro para el texto
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    nombre,
                                    style: TextStyle(
                                      fontSize: 24, // Tamaño de fuente aumentado
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lora',
                                      color: Color(0xFF800020), // Texto guinda
                                    ),
                                  ),
                                  Text(
                                    'S/ $precio',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lora',
                                      color: Color(0xFF800020), // Texto guinda
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error con el producto: $product');
                  print('Error específico: $e');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error al mostrar el producto',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }
              },
            ),
    );
  }
}
