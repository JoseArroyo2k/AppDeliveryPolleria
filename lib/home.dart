import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'pollo.dart';
import 'carne.dart';
import 'carne-personal.dart';
import 'caldos.dart';
import 'carrito.dart';
import 'platos_criollos.dart';
import 'bebidasnaturales.dart';
import 'guarniciones.dart';
import 'postres.dart';
import 'promociones.dart';
import 'mundoverde.dart';
import 'usuario.dart';
import 'status_provider.dart';
import 'order_status_bar.dart';

class CategoryHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Pollo a la brasa',
      'image': 'assets/images/pollo.png',
      'page': PolloPage(),
      'icon': Icons.restaurant_menu,
    },
    {
      'name': 'Carnes y parrillas',
      'image': 'assets/images/carnes.png',
      'page': CarnePage(),
      'icon': Icons.local_fire_department,
    },
    {
      'name': 'Carnes (platos personales)',
      'image': 'assets/images/carnes2.png',
      'page': CarnePersonalPage(),
      'icon': Icons.restaurant,
    },
    {
      'name': 'Caldo de gallina',
      'image': 'assets/images/caldos.png',
      'page': CaldosPage(),
      'icon': Icons.soup_kitchen,
    },
    {
      'name': 'Platos criollos',
      'image': 'assets/images/lomo.png',
      'page': PlatosCriollosPage(),
      'icon': Icons.local_dining,
    },
    {
      'name': 'Bebidas naturales',
      'image': 'assets/images/chicha.png',
      'page': BebidasNaturalesPage(),
      'icon': Icons.local_drink,
    },
    {
      'name': 'Guarniciones',
      'image': 'assets/images/papas.png',
      'page': GuarnicionesPage(),
      'icon': Icons.rice_bowl,
    },
    {
      'name': 'Postres',
      'image': 'assets/images/postre.png',
      'page': PostresPage(),
      'icon': Icons.cake,
    },
    {
      'name': 'Promociones',
      'image': 'assets/images/promo.png',
      'page': PromocionesPage(),
      'icon': Icons.local_offer,
    },
    {
      'name': 'Mundo verde',
      'image': 'assets/images/verde.png',
      'page': MundoVerdePage(),
      'icon': Icons.eco,
    },
  ];

  void _navigateToUserPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UsuarioPage()));
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<StatusProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF800020).withOpacity(0.95),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Nuestra Carta',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Inter',
              ),
            ),
            Spacer(),
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CarritoPage()));
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        padding: EdgeInsets.only(top: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 3 : 2,
                          childAspectRatio: isTablet ? 0.75 : 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => category['page']),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      category['image'],
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            category['icon'],
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            category['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 3.0,
                                                  color: Colors.black.withOpacity(0.5),
                                                ),
                                              ],
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
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Consumer<StatusProvider>(
                builder: (context, statusProvider, child) {
                  final estado = statusProvider.estado;
                  final mostrar = statusProvider.hayPedidoActivo &&
                      (estado == 'Generado' || estado == 'En Preparación' || estado == 'En Camino');

                  if (!mostrar) return SizedBox.shrink();

                  Color statusColor;
                  IconData statusIcon;
                  String statusText;

                  switch (estado) {
                    case 'Generado':
                      statusColor = Colors.orange;
                      statusIcon = Icons.receipt_long;
                      statusText = 'Pedido generado';
                      break;
                    case 'En Preparación':
                      statusColor = Colors.amber;
                      statusIcon = Icons.restaurant;
                      statusText = 'En preparación';
                      break;
                    case 'En Camino':
                      statusColor = Colors.green;
                      statusIcon = Icons.delivery_dining;
                      statusText = 'En camino';
                      break;
                    default:
                      statusColor = Color(0xFF800020);
                      statusIcon = Icons.local_shipping;
                      statusText = 'Sigue tu pedido';
                  }

                  return Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            insetPadding: EdgeInsets.symmetric(
                              horizontal: isTablet ? screenSize.width * 0.2 : 16,
                              vertical: isTablet ? screenSize.height * 0.15 : 24,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            backgroundColor: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Estado de tu pedido',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF800020),
                                          fontFamily: 'Lora',
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close, color: Colors.grey[700]),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  OrderStatusBar(estado: estado),
                                  SizedBox(height: 20),
                                  _buildStatusDetails(estado),
                                  SizedBox(height: 12),
                                  // Modified container to be more responsive
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time, color: Color(0xFF800020), size: 20),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Tiempo estimado a partir del pedido: 25 minutos',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              fontSize: isTablet ? 14 : 13,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF800020),
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Aceptar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: statusColor.withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      statusIcon,
                                      color: statusColor,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          statusText,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Lora',
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Toca para ver más detalles',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: statusColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Carta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Color(0xFF800020),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (index) {
            if (index == 1) {
              _navigateToUserPage(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatusDetails(String estado) {
    Widget content;
    switch (estado) {
      case 'Generado':
        content = _buildStatusDetailItem(
          Icons.receipt_long,
          'Pedido recibido',
          'Tu pedido ha sido recibido y confirmado correctamente.',
          Colors.orange,
        );
        break;
      case 'En Preparación':
        content = _buildStatusDetailItem(
          Icons.restaurant,
          'Preparando tu comida',
          'Nuestro chef está preparando tu pedido con los mejores ingredientes.',
          Colors.amber,
        );
        break;
      case 'En Camino':
        content = _buildStatusDetailItem(
          Icons.delivery_dining,
          'En camino a tu dirección',
          'Tu pedido está en manos de nuestro repartidor y llegará pronto.',
          Colors.green,
        );
        break;
      default:
        content = _buildStatusDetailItem(
          Icons.info_outline,
          'Estado del pedido',
          'Información sobre tu pedido actual.',
          Color(0xFF800020),
        );
    }
    return content;
  }

  Widget _buildStatusDetailItem(IconData icon, String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}