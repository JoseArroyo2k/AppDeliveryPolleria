import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

class DetalleProductoPage extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;

  const DetalleProductoPage({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
  }) : super(key: key);

  @override
  _DetalleProductoPageState createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  int _cantidad = 1;
  final Color _primaryColor = const Color(0xFF800020);
  bool _isImageLoading = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final subtotal = widget.precio * _cantidad;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: _primaryColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_cart, color: _primaryColor),
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Imagen Hero con indicador de carga
          Stack(
            children: [
              Hero(
                tag: 'product-${widget.imagenUrl}',
                child: Container(
                  height: size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.imagenUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            _isImageLoading = false;
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: _primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      // Gradiente superior para el texto
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Contenido
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0, -30, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título y precio
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.nombre.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontFamily: 'Lora',
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'S/ ${widget.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Descripción
                      Text(
                        widget.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Selector de cantidad
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      if (_cantidad > 1) {
                                        setState(() => _cantidad--);
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_cantidad',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() => _cantidad++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'S/ ${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false).addItem(
                      widget.nombre,
                      widget.precio,
                      widget.imagenUrl,
                      _cantidad,
                    );
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('¡Producto añadido al carrito!'),
                        backgroundColor: _primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'AÑADIR AL CARRITO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}