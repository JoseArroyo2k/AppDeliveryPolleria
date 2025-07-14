import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalle.dart';
import 'carrito.dart';

class CarnePage extends StatefulWidget {
  @override
  _CarnePageState createState() => _CarnePageState();
}

class _CarnePageState extends State<CarnePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> carneProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarneProducts();
  }

  void _fetchCarneProducts() async {
    try {
      setState(() => _isLoading = true);
      QuerySnapshot snapshot = await _firestore
          .collection('Productos')
          .where('Categoria', isEqualTo: 'Carnes')
          .get();

      setState(() {
        carneProducts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error al obtener productos de la categoría Carnes: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product, double screenWidth, double screenHeight) {
    String nombre = product['Nombre'] ?? 'Producto sin nombre';
    String descripcion = product['Descripcion'] ?? 'Sin descripción';
    String precio = product['Precio']?.toString() ?? 'Precio no disponible';
    String imagenUrl = product['Imagen'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 100, // Ajusta el tamaño del logo de carga
                          height: 100,
                          child: Image.asset(
                            'assets/images/cargando.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Image.network(
                        imagenUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: const Color(0xFF800020),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Color(0xFF800020),
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Text(
                            'S/ $precio',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora',
                        color: const Color(0xFF800020),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Carnes y Parrillas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora',
            fontSize: screenWidth * 0.055,
          ),
        ),
        backgroundColor: const Color(0xFF800020),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarritoPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF800020),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF800020),
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 1500));
                _fetchCarneProducts();
              },
              child: carneProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: screenWidth * 0.15,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay productos disponibles',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      itemCount: carneProducts.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(
                          carneProducts[index],
                          screenWidth,
                          screenHeight,
                        );
                      },
                    ),
            ),
    );
  }
}
