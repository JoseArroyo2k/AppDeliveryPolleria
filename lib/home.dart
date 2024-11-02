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
  final List<String> categories = [
    'Pollo a la brasa',
    'Carnes y parrillas',
    'Carnes (platos personales)',
    'Caldo de gallina',
    'Platos criollos',
    'Bebidas naturales',
    'Guarniciones',
    'Postres',
    'Promociones',
    'Mundo verde',
  ];

  final Map<String, String> categoryImages = {
    'Pollo a la brasa': 'assets/images/pollo.png',
    'Carnes y parrillas': 'assets/images/carnes.png',
    'Carnes (platos personales)': 'assets/images/carnes2.png',
    'Caldo de gallina': 'assets/images/caldos.png',
    'Platos criollos': 'assets/images/lomo.png',
    'Bebidas naturales': 'assets/images/chicha.png',
    'Guarniciones': 'assets/images/papas.png',
    'Postres': 'assets/images/postre.png',
    'Promociones': 'assets/images/promo.png',
    'Mundo verde': 'assets/images/verde.png',
  };

  void _navigateToCategory(BuildContext context, String category) {
    if (category == 'Pollo a la brasa') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PolloPage()));
    } else if (category == 'Carnes y parrillas') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CarnePage()));
    } else if (category == 'Carnes (platos personales)') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CarnePersonalPage()));
    } else if (category == 'Caldo de gallina') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CaldosPage()));
    } else if (category == 'Platos criollos') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlatosCriollosPage()));
    } else if (category == 'Bebidas naturales') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BebidasNaturalesPage()));
    } else if (category == 'Guarniciones') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GuarnicionesPage()));
    } else if (category == 'Postres') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PostresPage()));
    } else if (category == 'Promociones') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PromocionesPage()));
    } else if (category == 'Mundo verde') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MundoVerdePage()));
    }
  }

  void _navigateToUserPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UsuarioPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF800020),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Categorías',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CarritoPage()));
              },
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = categories[index];
              return GestureDetector(
                onTap: () => _navigateToCategory(context, category),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Color(0xFF800020), width: 4.0),
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
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            categoryImages[category]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Lora',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Carta'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        backgroundColor: Color(0xFF800020),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        onTap: (index) {
          if (index == 1) {
            _navigateToUserPage(context);
          }
        },
      ),
    );
  }
}
