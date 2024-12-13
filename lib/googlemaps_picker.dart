import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapsLocationPicker extends StatefulWidget {
  const GoogleMapsLocationPicker({Key? key}) : super(key: key);

  @override
  _GoogleMapsLocationPickerState createState() => _GoogleMapsLocationPickerState();
}

class _GoogleMapsLocationPickerState extends State<GoogleMapsLocationPicker> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  String _addressName = '';

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        await _getCurrentLocation();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al solicitar permisos: $e')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _selectedLocation = currentLocation;
        });
      }

      await _getAddressFromCoordinates(currentLocation);
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 15));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener la ubicación actual.')),
        );
      }
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        setState(() {
          _addressName = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      print('Error al obtener la dirección: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_selectedLocation == null) {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tu ubicación'),
        backgroundColor: const Color(0xFF800020),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedLocation ?? const LatLng(-12.0464, -77.0428), // Lima, Perú
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng location) async {
              setState(() {
                _selectedLocation = location;
              });
              await _getAddressFromCoordinates(location);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation!,
                      infoWindow: InfoWindow(title: _addressName),
                    )
                  }
                : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (_addressName.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _addressName,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF800020),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _selectedLocation != null
                      ? () {
                          Navigator.pop(context, {
                            'latitude': _selectedLocation!.latitude,
                            'longitude': _selectedLocation!.longitude,
                            'address': _addressName,
                          });
                        }
                      : null,
                  child: const Text(
                    'Confirmar ubicación',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
