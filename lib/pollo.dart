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
        title: Text('Pollo a la brasa'),
        backgroundColor: Colors.green[900],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
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
                  var descripcion = product['Descripcion'] ?? 'Sin descripción';
                  var precio = product['Precio']?.toString() ?? 'Precio no disponible';
                  var imagenUrl = product['Imagen'] ?? 'https://via.placeholder.com/150';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imagenUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error); // Muestra un icono en caso de error
                            },
                          ),
                        ),
                        title: Text(
                          nombre,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        subtitle: Text(
                          descripcion,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        trailing: Text(
                          'S/ $precio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProductoPage(
                                nombre: nombre,
                                descripcion: descripcion,
                                precio: double.parse(precio),
                                imagenUrl: imagenUrl,
                              ),
                            ),
                          );
                        },
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
