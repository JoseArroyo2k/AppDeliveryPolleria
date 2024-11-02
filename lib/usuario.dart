import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class UsuarioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil de Usuario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Lora'),
        ),
        backgroundColor: Color(0xFF800020),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoField('Nombre', userProvider.nombre),
            SizedBox(height: 16),
            _buildUserInfoField('Correo', userProvider.correo),
            SizedBox(height: 16),
            _buildUserInfoField('Teléfono', userProvider.numero),
            SizedBox(height: 16),
            _buildUserInfoField('Dirección', userProvider.direccion),
            SizedBox(height: 16),
            _buildUserInfoField('Cumpleaños', userProvider.cumpleanos),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Carta'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        backgroundColor: Color(0xFF800020),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildUserInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lora', color: Color(0xFF800020)),
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF800020), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isNotEmpty ? value : 'N/A',
            style: TextStyle(fontSize: 18, fontFamily: 'Lora', color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
