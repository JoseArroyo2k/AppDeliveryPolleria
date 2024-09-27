import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'pollo.dart'; // Importamos el archivo de la categoría Pollo
import 'carrito.dart'; // Importamos el archivo de carrito

class CategoryHomePage extends StatefulWidget {
  @override
  _CategoryHomePageState createState() => _CategoryHomePageState();
}

class _CategoryHomePageState extends State<CategoryHomePage> {
  int _selectedIndex = 0;
  bool isRegistered = false; // Inicialmente asumimos que es invitado
  String userName = 'Invitado'; // Nombre por defecto para invitados
  final CarouselController _carouselController = CarouselController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibimos el argumento desde el LoginPage
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      isRegistered = args['isRegistered'] ?? false;
      userName = args['userName'] ?? 'Invitado';
    }
  }

  // Lista de categorías
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

  // Lista de promociones
  final List<String> promotionImages = [
    'assets/images/categorias/promociones/promo2.png',
    'assets/images/categorias/promociones/promo1.png',
  ];

  // Lista de imágenes de categorías
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

  // Función para manejar la navegación a las páginas de categorías
  void _navigateToCategory(String category) {
    if (category == 'Pollo a la brasa') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PolloPage()), // Navega a la pantalla de Pollo
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido: $userName', // Mostramos el nombre del usuario o "Invitado"
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.shopping_cart), // Cambiamos aquí el carrito
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CarritoPage()), // Navega al carrito
                );
              },
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.green[900],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Slider de promociones
              CarouselSlider(
                items: promotionImages.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 270.0,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                ),
              ),
              SizedBox(height: 15),
              // Grid de categorías
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      String category = categories[index];
                      return GestureDetector(
                        onTap: () => _navigateToCategory(category),
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.green[900]!,
                                  width: 3.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  categoryImages[category]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              category,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[900],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menú',
          ),
          if (isRegistered) // Mostramos el botón de usuario solo si el usuario está registrado
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Usuario',
            )
          else
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Más',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
