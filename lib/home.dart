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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.85,
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
}
