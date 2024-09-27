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
    
    // Asegurarse de que los datos se imprimen en consola para depuración
    print('Autocompletando datos de usuario...');
    print('Nombre: ${userProvider.nombre}');
    print('Dirección: ${userProvider.direccion}');
    print('Correo: ${userProvider.correo}');
    print('Número: ${userProvider.numero}');
    
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
        title: Text('Confirmación de compra'),
        backgroundColor: Colors.green[900],
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
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _direccionController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _correoController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _numeroController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('Método de pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text('Confirmar pedido'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orange,
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
