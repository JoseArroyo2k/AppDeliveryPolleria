import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'cart_provider.dart';
import 'ConfirmacionCompra.dart';

class CarritoPage extends StatelessWidget {
  static const _primaryColor = Color(0xFF800020);
  static const _accentColor = Color(0xFFFFF0F3);
  static const _borderRadius = 24.0;
  static const _animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: cart.items.isEmpty
                  ? _buildEmptyCart(size)
                  : _buildCartContent(cart, size, context),
            ),
          ],
        ),
        bottomNavigationBar: cart.items.isEmpty
            ? null
            : _buildBottomBar(cart, size, context),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: _primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Mi Carrito',
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _primaryColor.withOpacity(0.8),
                _primaryColor,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(Size size) {
    return Container(
      height: size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentColor,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontFamily: 'Lora',
            ),
          ),
          SizedBox(height: 12),
          Text(
            '¡Agrega algunos productos para comenzar!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Lora',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartProvider cart, Size size, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '${cart.items.length} ${cart.items.length == 1 ? 'Producto' : 'Productos'} en tu carrito',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontFamily: 'Lora',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            return _buildCartItem(cart.items[index], cart, size, context, index);
          },
        ),
      ],
    );
  }

  Widget _buildCartItem(dynamic item, CartProvider cart, Size size, BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Hero(
        tag: 'product_${item.nombre}_$index',
        child: Material(
          elevation: 4,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(_borderRadius),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildProductImage(item, size),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildProductDetails(item, cart, size),
                        ),
                        _buildDeleteButton(item, cart, context),
                      ],
                    ),
                    
                    // Mostrar detalles específicos del producto si existen
                    if (item.detalles.isNotEmpty) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(_borderRadius / 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalles del producto:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 6),
                            _buildDetallesProducto(item.detalles),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetallesProducto(Map<String, dynamic> detalles) {
    List<Widget> detallesWidgets = [];

    // Bebida
    if (detalles['bebida'] != null) {
      var bebidaInfo = detalles['bebida'];
      String bebidaText = '${bebidaInfo['seleccion']}';
      
      if (bebidaInfo['temperatura']?.isNotEmpty ?? false) {
        bebidaText += ' (${bebidaInfo['temperatura']})';
      }
      
      detallesWidgets.add(_buildDetalleItem('Bebida', bebidaText));
    }

    // Corte de pollo
    if (detalles['corte_pollo'] != null) {
      var corteInfo = detalles['corte_pollo'];
      String corteText = 'Corte: ${corteInfo['tipo']}';
      
      if (corteInfo['preferencia']?.isNotEmpty ?? false) {
        corteText += ' (${corteInfo['preferencia']})';
      }
      
      detallesWidgets.add(_buildDetalleItem('Pollo', corteText));
    }

    // Presa de caldo
    if (detalles['presa_caldo'] != null) {
      detallesWidgets.add(_buildDetalleItem('Presa', detalles['presa_caldo']));
    }

    // Término de carne
    if (detalles['termino_carne'] != null) {
      detallesWidgets.add(_buildDetalleItem('Término', detalles['termino_carne']));
    }

    // Detalles generales
    if (detalles['detalles_generales']?.isNotEmpty ?? false) {
      detallesWidgets.add(_buildDetalleItem('Nota', detalles['detalles_generales']));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: detallesWidgets,
    );
  }

  Widget _buildDetalleItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(dynamic item, Size size) {
    return Container(
      width: size.width * 0.25,
      height: size.width * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius / 2),
        child: Stack(
          children: [
            Image.network(
              item.imagenUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.error_outline, color: Colors.red),
                );
              },
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(dynamic item, CartProvider cart, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.nombre,
          style: TextStyle(
            fontSize: size.width * 0.042,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            fontFamily: 'Lora',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        _buildQuantityControls(item, cart),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              'S/ ',
              style: TextStyle(
                fontSize: size.width * 0.035,
                color: _primaryColor,
                fontFamily: 'Lora',
              ),
            ),
            Text(
              '${(item.precio * item.cantidad).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
                fontFamily: 'Lora',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityControls(dynamic item, CartProvider cart) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _accentColor,
        borderRadius: BorderRadius.circular(_borderRadius / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            Icons.remove_rounded,
            () {
              if (item.cantidad > 1) {
                cart.updateItemQuantity(item.nombre, item.cantidad - 1, item.detalles);
              }
            },
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_borderRadius / 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${item.cantidad}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ),
          _buildQuantityButton(
            Icons.add_rounded,
            () => cart.updateItemQuantity(item.nombre, item.cantidad + 1, item.detalles),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_borderRadius / 2),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(dynamic item, CartProvider cart, BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
            ),
            title: Text(
              '¿Eliminar producto?',
              style: TextStyle(
                color: _primaryColor,
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              '¿Estás seguro de que deseas eliminar este producto del carrito?',
              style: TextStyle(fontFamily: 'Lora'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              TextButton(
                onPressed: () {
                  cart.removeItem(item.nombre, item.detalles);
                  Navigator.pop(context);
                },
                child: Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(CartProvider cart, Size size, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: size.width * 0.035,
                    fontFamily: 'Lora',
                  ),
                ),
                Text(
                  'S/ ${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: size.width * 0.035,
                    fontFamily: 'Lora',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a Pagar',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                    fontFamily: 'Lora',
                  ),
                ),
                Text(
                  'S/ ${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: size.width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                    fontFamily: 'Lora',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'CONTINUAR COMPRA',
                      style: TextStyle(
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontFamily: 'Lora',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}