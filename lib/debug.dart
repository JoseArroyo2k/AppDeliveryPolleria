import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DebugGoogleMaps extends StatefulWidget {
  const DebugGoogleMaps({Key? key}) : super(key: key);

  @override
  _DebugGoogleMapsState createState() => _DebugGoogleMapsState();
}

class _DebugGoogleMapsState extends State<DebugGoogleMaps> {
  late GoogleMapController _mapController;
  bool _mapLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Google Maps'),
        backgroundColor: const Color(0xFF800020),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              setState(() {
                _mapLoaded = true;
              });
              print('Google Maps cargado correctamente.');
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(-12.0464, -77.0428), // Coordenadas iniciales de prueba
              zoom: 12,
            ),
          ),
          if (!_mapLoaded)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF800020),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800020),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                LatLng currentCameraPosition = await _mapController.getLatLng(
                  ScreenCoordinate(x: 200, y: 200), // Coordenada centrada en el mapa
                );
                print(
                    'Coordenadas en el centro del mapa: ${currentCameraPosition.latitude}, ${currentCameraPosition.longitude}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Centro del mapa: (${currentCameraPosition.latitude}, ${currentCameraPosition.longitude})'),
                  ),
                );
              },
              child: const Text(
                'Obtener coordenadas del centro',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
