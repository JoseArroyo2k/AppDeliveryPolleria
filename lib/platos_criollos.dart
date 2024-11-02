import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle.dart'; // Importamos la página de detalles
import 'carrito.dart'; // Importa la página de carrito

class PlatosCriollosPage extends StatefulWidget {
  @override
  _PlatosCriollosPageState createState() => _PlatosCriollosPageState();
}

class _PlatosCriollosPageState extends State<PlatosCriollosPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> criolloProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchCriolloProducts();
  }

  void _fetchCriolloProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Productos')
          .where('Categoria', isEqualTo: 'Criollos')
          .get();

      setState(() {
        criolloProducts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      print('Error al obtener productos de la categoría Criollo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Platos Criollos',
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
      body: criolloProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: criolloProducts.length,
              itemBuilder: (context, index) {
                var product = criolloProducts[index];
                try {
                  var nombre = product['Nombre'] ?? 'Producto sin nombre';
                  var descripcion = product['Descripcion'] ?? 'Sin descripción';
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
                              descripcion: descripcion,
                              precio: double.tryParse(precio) ?? 0.0,
                              imagenUrl: imagenUrl,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.21,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Color(0xFF800020), width: 3.0), // Borde guinda
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
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imagenUrl,
                                height: double.infinity,
                                width: MediaQuery.of(context).size.width * 0.35,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      nombre,
                                      textAlign: TextAlign.center,
                                      maxLines: 1, // Limitar a 1 línea
                                      overflow: TextOverflow.ellipsis, // Puntos suspensivos
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lora',
                                        color: Color(0xFF800020),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      descripcion,
                                      maxLines: 2, // Limitar a 2 líneas
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Lora',
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'S/ $precio',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lora',
                                        color: Color(0xFF800020),
                                      ),
                                    ),
                                  ],
                                ),
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
