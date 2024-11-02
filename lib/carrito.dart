import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'ConfirmacionCompra.dart';
import 'user_provider.dart';

class CarritoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos Seleccionados',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora', // Fuente Lora
          ),
        ),
        backgroundColor: Color(0xFF800020), // Fondo guinda
      ),
      body: cart.items.isEmpty
          ? Center(child: Text('Tu carrito está vacío'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                var item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Color(0xFF800020), width: 3.0),
                      color: Colors.white,
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
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              item.imagenUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error, color: Colors.red);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    item.nombre,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF800020),
                                      fontFamily: 'Lora',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      color: Color(0xFF800020),
                                      onPressed: () {
                                        if (item.cantidad > 1) {
                                          cart.updateItemQuantity(item.nombre, item.cantidad - 1);
                                        }
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFF800020), width: 2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${item.cantidad}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF800020),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      color: Color(0xFF800020),
                                      onPressed: () {
                                        cart.updateItemQuantity(item.nombre, item.cantidad + 1);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Flexible(
                                  child: Text(
                                    'S/ ${item.precio * item.cantidad}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF800020),
                                      fontFamily: 'Lora',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cart.removeItem(item.nombre);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: S/ ${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Lora',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmacionCompraPage(
                        isRegistered: true,
                      ),
                    ),
                  );
                },
                child: Text(
                  'PAGAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lora',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF800020),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
