import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'user_provider.dart';
import 'services/auth_service.dart';
import 'googlemaps_picker.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  // Colores y constantes para el diseño
  static const _primaryColor = Color(0xFF800020);
  static const _accentColor = Color(0xFFFFF0F3);
  static const _borderRadius = 16.0;
  static const _animationDuration = Duration(milliseconds: 300);

  // Controladores para la edición
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  Map<String, dynamic>? _selectedLocation;

  void _showEditProfileModal(BuildContext context, UserProvider userProvider) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    // Inicializar controladores con valores actuales
    _nameController.text = userProvider.nombre;
    _phoneController.text = userProvider.numero;
    _addressController.text = userProvider.direccionTextual;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: _primaryColor),
                        SizedBox(width: 12),
                        Text(
                          'Editar Perfil',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                            fontFamily: 'Lora',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: Icon(Icons.person, color: _primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: _primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Teléfono',
                              prefixIcon: Icon(Icons.phone, color: _primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: _primaryColor),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoogleMapsLocationPicker(),
                                  fullscreenDialog: true,
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  _selectedLocation = result;
                                  _addressController.text = result['address'] ??
                                      'Lat: ${result['latitude']}, Lng: ${result['longitude']}';
                                });
                              }
                            },
                            child: TextFormField(
                              controller: _addressController,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: 'Dirección',
                                prefixIcon: Icon(Icons.location_on, color: _primaryColor),
                                suffixIcon: Icon(Icons.map, color: _primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_borderRadius),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('Usuarios')
                                    .where('email', isEqualTo: userProvider.correo)
                                    .get()
                                    .then((querySnapshot) {
                                  if (querySnapshot.docs.isNotEmpty) {
                                    querySnapshot.docs.first.reference.update({
                                      'nombre': _nameController.text,
                                      'telefono': _phoneController.text,
                                      'direccion': _addressController.text,
                                      if (_selectedLocation != null) ...{
                                        'ubicacion_coordenadas': {
                                          'latitude': _selectedLocation!['latitude'],
                                          'longitude': _selectedLocation!['longitude']
                                        },
                                        'ubicacion_nombre': _selectedLocation!['address']
                                      }
                                    });
                                  }
                                });

                                userProvider.setUserData(
                                  _nameController.text,
                                  _addressController.text,
                                  _selectedLocation?['latitude'] ?? userProvider.latitud,
                                  _selectedLocation?['longitude'] ?? userProvider.longitud,
                                  userProvider.correo,
                                  _phoneController.text,
                                  userProvider.cumpleanos,
                                );

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Perfil actualizado exitosamente'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al actualizar el perfil'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_borderRadius),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarPedidos(BuildContext context, String email) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay información de usuario para buscar pedidos'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: _primaryColor),
                        SizedBox(width: 12),
                        Text(
                          'Mis Pedidos Anteriores',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                            fontFamily: 'Lora',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('pedidos')
                          .where('usuario', isEqualTo: email)
                          .limit(10)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: _primaryColor,
                              strokeWidth: 3,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                                SizedBox(height: 16),
                                Text(
                                  'Error al cargar pedidos',
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long, color: Colors.grey[400], size: 64),
                                SizedBox(height: 16),
                                Text(
                                  'No hay pedidos anteriores',
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tus pedidos aparecerán aquí',
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            controller: scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              final data = doc.data() as Map<String, dynamic>;
                              
                              String fechaFormateada = 'Fecha no disponible';
                              if (data['fecha'] != null) {
                                try {
                                  if (data['fecha'] is Timestamp) {
                                    Timestamp timestamp = data['fecha'];
                                    DateTime fecha = timestamp.toDate();
                                    fechaFormateada = DateFormat('dd/MM/yyyy - HH:mm').format(fecha);
                                  } else if (data['fecha'] is String) {
                                    fechaFormateada = data['fecha'];
                                  }
                                } catch (e) {
                                  fechaFormateada = 'Formato de fecha inválido';
                                }
                              }

                              Color statusColor;
                              IconData statusIcon;
                              
                              switch(data['estado']?.toString().toLowerCase() ?? '') {
                                case 'entregado':
                                  statusColor = Colors.green[700]!;
                                  statusIcon = Icons.check_circle;
                                  break;
                                case 'en camino':
                                  statusColor = Colors.blue[700]!;
                                  statusIcon = Icons.delivery_dining;
                                  break;
                                case 'preparando':
                                  statusColor = Colors.orange[700]!;
                                  statusIcon = Icons.restaurant;
                                  break;
                                case 'cancelado':
                                  statusColor = Colors.red[700]!;
                                  statusIcon = Icons.cancel;
                                  break;
                                default:
                                  statusColor = _primaryColor;
                                  statusIcon = Icons.receipt_long;
                              }

                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    _mostrarDetallesPedido(context, data);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(statusIcon, color: statusColor),
                                            SizedBox(width: 8),
                                            Text(
                                              'Pedido ${doc.id.substring(0, 8).toUpperCase()}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontFamily: 'Lora',
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: statusColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: statusColor.withOpacity(0.3)),
                                              ),
                                              child: Text(
                                                data['estado'] ?? 'Procesando',
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Fecha',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    fechaFormateada,
                                                    style: TextStyle(fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    'S/ ${data['total']?.toStringAsFixed(2) ?? '--'}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: _primaryColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarDetallesPedido(BuildContext context, Map<String, dynamic> data) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: _primaryColor),
            SizedBox(width: 8),
            Text(
              'Detalles del Pedido',
              style: TextStyle(
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
          child: ListView(
            shrinkWrap: true,
            children: [
              if (data['detalle_productos'] != null && data['detalle_productos'] is List) ...[
                Text(
                  'Productos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora',
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
                SizedBox(height: 8),
                ...List.generate(
                  (data['detalle_productos'] as List).length,
                  (index) {
                    final producto = data['detalle_productos'][index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto['nombre'] ?? 'Producto',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                if (producto['precio'] != null)
                                  Text(
                                    'S/ ${producto['precio'].toStringAsFixed(2)} x ${producto['cantidad'] ?? 1}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                              ],
                            ),
                          ),
                          if (producto['precio'] != null && producto['cantidad'] != null)
                            Text(
                              'S/ ${(producto['precio'] * producto['cantidad']).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(),
              ],

              if (data['detalle_cliente'] != null && data['detalle_cliente'] is Map) ...[
                Text(
                  'Información de Entrega',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora',
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
                SizedBox(height: 8),
                Text('Dirección: ${data['detalle_cliente']['direccion'] ?? 'No disponible'}'),
                if (data['detalle_cliente']['comentarios'] != null)
                  Text('Comentarios: ${data['detalle_cliente']['comentarios']}'),
                Divider(),
              ],

              if (data['detalles_adicionales'] != null && data['detalles_adicionales'] is Map) ...[
                Text(
                  'Detalles Adicionales',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lora',
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
                SizedBox(height: 8),
                if (data['detalles_adicionales']['metodo_pago'] != null)
                  Text('Método de pago: ${data['detalles_adicionales']['metodo_pago']}'),
                if (data['detalles_adicionales']['instrucciones'] != null)
                  Text('Instrucciones: ${data['detalles_adicionales']['instrucciones']}'),
                Divider(),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('S/ ${(data['total'] != null ? (data['total'] * 0.82).toStringAsFixed(2) : '--')}'),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('IGV (18%):', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('S/ ${(data['total'] != null ? (data['total'] * 0.18).toStringAsFixed(2) : '--')}'),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    'S/ ${data['total']?.toStringAsFixed(2) ?? '--'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(UserProvider userProvider, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 110 : 130,
      height: isSmallScreen ? 110 : 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: _animationDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _accentColor,
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Text(
            userProvider.nombre.isNotEmpty
                ? userProvider.nombre[0].toUpperCase()
                : 'U',
            style: TextStyle(
              fontSize: isSmallScreen ? 50 : 60,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              fontFamily: 'Lora',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon,
    bool isSmallScreen, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.circular(_borderRadius / 2),
                ),
                child: Icon(
                  icon,
                  color: _primaryColor,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey[600],
                        fontFamily: 'Lora',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      value.isNotEmpty ? value : 'No especificado',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                        fontFamily: 'Lora',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.grey[200],
            thickness: 1,
            indent: 24,
            endIndent: 24,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final double headerHeight = screenSize.height * (isSmallScreen ? 0.28 : 0.25);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 22 : 26,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditProfileModal(context, userProvider),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: headerHeight + 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _primaryColor,
                  _primaryColor.withOpacity(0.8),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: isSmallScreen ? 20 : 30),
                  _buildProfileAvatar(userProvider, isSmallScreen),
                  SizedBox(height: 16),
                  Text(
                    userProvider.nombre,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Lora',
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userProvider.correo,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: 'Lora',
                      shadows: [
                        Shadow(
                          blurRadius:  2,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: _primaryColor,
                                size: isSmallScreen ? 22 : 26,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Información Personal',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: _primaryColor,
                                  fontFamily: 'Lora',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 1,
                          indent: 24,
                          endIndent: 24,
                        ),
                        _buildInfoItem(
                          'Teléfono',
                          userProvider.numero,
                          Icons.phone_outlined,
                          isSmallScreen,
                        ),
                        _buildInfoItem(
                          'Dirección',
                          userProvider.direccionTextual,
                          Icons.location_on_outlined,
                          isSmallScreen,
                        ),
                        _buildInfoItem(
                          'Cumpleaños',
                          userProvider.cumpleanos,
                          Icons.cake_outlined,
                          isSmallScreen,
                          showDivider: false,
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.history, color: Colors.white),
                      label: Text(
                        'Mis pedidos anteriores',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lora',
                        ),
                      ),
                      onPressed: () => _mostrarPedidos(context, userProvider.correo),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cerrar Sesión'),
                            content: Text('¿Estás seguro que deseas cerrar sesión?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AuthService.clearSession();
                                  Provider.of<UserProvider>(context, listen: false).clearUserData();
                                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                },
                                child: Text('Cerrar Sesión', style: TextStyle(color: Colors.red[600])),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.logout, color: Colors.red[600]),
                      label: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontFamily: 'Lora',
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            elevation: 0,
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
            currentIndex: 1,
            selectedItemColor: _primaryColor,
            unselectedItemColor: Colors.grey[400],
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Lora',
              fontSize: isSmallScreen ? 12 : 14,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Lora',
              fontSize: isSmallScreen ? 12 : 14,
            ),
            onTap: (index) {
              if (index == 0) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      ),
    );
  }
}
