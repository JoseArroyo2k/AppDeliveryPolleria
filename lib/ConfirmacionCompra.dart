import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart'; // Importamos el UserProvider

class ConfirmacionCompraPage extends StatefulWidget {
  final bool isRegistered;

  ConfirmacionCompraPage({required this.isRegistered});

  @override
  _ConfirmacionCompraPageState createState() => _ConfirmacionCompraPageState();
}

class _ConfirmacionCompraPageState extends State<ConfirmacionCompraPage> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();

  String _metodoPago = 'efectivo'; 

  @override
  void initState() {
    super.initState();
    if (widget.isRegistered) {
      _autocompletarDatos();
    }
  }

  // Autocompletamos los datos del usuario usando el UserProvider
  void _autocompletarDatos() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    _nombreController.text = userProvider.nombre;
    _direccionController.text = userProvider.direccion;
    _correoController.text = userProvider.correo;
    _numeroController.text = userProvider.numero;
  }

  // Función de confirmación de pedido
  void _confirmarPedido() {
    if (_nombreController.text.isEmpty ||
        _direccionController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _numeroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, complete todos los campos'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pedido confirmado con éxito'),
      backgroundColor: Colors.green,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirmación de compra',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lora', // Fuente Lora para el título
          ),
        ),
        backgroundColor: Color(0xFF800020), // Fondo guinda
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: Color(0xFF800020), fontFamily: 'Lora'), // Color guinda para el label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                labelStyle: TextStyle(color: Color(0xFF800020), fontFamily: 'Lora'), // Color guinda para el label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _correoController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                labelStyle: TextStyle(color: Color(0xFF800020), fontFamily: 'Lora'), // Color guinda para el label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _numeroController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono',
                labelStyle: TextStyle(color: Color(0xFF800020), fontFamily: 'Lora'), // Color guinda para el label
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF800020), width: 2.0), // Borde guinda
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Método de pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lora'), // Fuente Lora
            ),
            ListTile(
              title: const Text('Pago en efectivo (contraentrega)'),
              leading: Radio<String>(
                value: 'efectivo',
                groupValue: _metodoPago,
                onChanged: (String? value) {
                  setState(() {
                    _metodoPago = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Pago con tarjeta (contraentrega)'),
              leading: Radio<String>(
                value: 'tarjeta',
                groupValue: _metodoPago,
                onChanged: (String? value) {
                  setState(() {
                    _metodoPago = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmarPedido,
                child: Text(
                  'CONFIRMAR PEDIDO',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Lora', // Fuente Lora para el botón
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF800020), // Fondo guinda
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
