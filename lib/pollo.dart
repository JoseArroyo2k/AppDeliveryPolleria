import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text('Pollo a la brasa'),
        backgroundColor: Colors.green[900],
      ),
      body: polloProducts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: polloProducts.length,
              itemBuilder: (context, index) {
                var product = polloProducts[index];
                try {
                  // Manejar valores nulos asignando valores por defecto
                  var nombre = product['Nombre'] ?? 'Producto sin nombre';
                  var descripcion = product['Descripcion'] ?? 'Sin descripción';
                  var precio = product['Precio']?.toString() ?? 'Precio no disponible';
                  var imagenUrl = product['Imagen'] ?? 'https://via.placeholder.com/150';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagen del producto
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                imagenUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Nombre del producto
                            Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                            SizedBox(height: 5),
                            // Descripción del producto
                            Text(
                              descripcion,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Precio y botones de cantidad
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'S/ $precio',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // Lógica para disminuir cantidad
                                      },
                                      icon: Icon(Icons.remove),
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      '0', // Inicialmente la cantidad es 0
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Lógica para aumentar cantidad
                                      },
                                      icon: Icon(Icons.add),
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  // Si ocurre un error, imprimimos los detalles del producto
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menú',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          // Lógica para navegar entre el menú y el carrito
        },
      ),
    );
  }
}
