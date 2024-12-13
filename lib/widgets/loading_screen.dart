import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: const Color(0xFF800020), // Fondo guinda
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animación circular de carga
          const CircularProgressIndicator(
            color: Colors.orange, // Bolita naranja
            strokeWidth: 6.0, // Tamaño de la línea
          ),
          const SizedBox(height: 20),
          // Texto "Cargando..."
          Text(
            'Cargando...',
            style: TextStyle(
              fontSize: screenWidth * 0.06, // Ajustado a la pantalla
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora',
            ),
          ),
          const SizedBox(height: 20),
          // Slogan temático
          Text(
            'Preparando los mejores pollos a la brasa 🍗',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: Colors.white.withOpacity(0.8),
              fontFamily: 'Lora',
            ),
          ),
        ],
      ),
    );
  }
}
