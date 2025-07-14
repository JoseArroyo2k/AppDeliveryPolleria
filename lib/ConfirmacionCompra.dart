import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'user_provider.dart';
import 'cart_provider.dart';
import 'home.dart';
import 'status_provider.dart';
import 'detalles_provider.dart';

class ConfirmacionCompraPage extends StatefulWidget {
  final bool isRegistered;

  ConfirmacionCompraPage({required this.isRegistered});

  @override
  _ConfirmacionCompraPageState createState() => _ConfirmacionCompraPageState();
}

class _ConfirmacionCompraPageState extends State<ConfirmacionCompraPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _primaryColor = Color(0xFF800020);
  static const _accentColor = Color(0xFFFFF0F3);
  static const _borderRadius = 24.0;

  // Bandera para habilitar/deshabilitar restricciones de horario (1 = activado, 0 = desactivado)
  static const int RESTRICT_HORARIO = 1;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _dniController = TextEditingController();
  TextEditingController _rucController = TextEditingController();
  TextEditingController _comentariosController = TextEditingController();

  String _metodoPago = 'efectivo';
  String _tipoComprobante = 'boleta_simple';
  bool _isLoading = false;

  // Nuevas variables para programación de pedidos
  bool _esPedidoProgramado = false;
  DateTime? _fechaHoraProgramada;

  @override
  void initState() {
    super.initState();
    if (widget.isRegistered) {
      _autocompletarDatos();
    }
  }

  void _autocompletarDatos() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nombreController.text = userProvider.nombre;
    _direccionController.text = userProvider.direccionTextual;
    _numeroController.text = userProvider.numero;
  }

  // Verifica si la hora actual está dentro del horario permitido (10:00-23:00 hora Perú)
  bool _dentroDeHorarioPermitido() {
    if (RESTRICT_HORARIO == 0) {
      return true; // Sin restricciones de horario
    }

    // Obtener la hora actual en Perú (UTC-5)
    final now = DateTime.now().toUtc().subtract(Duration(hours: 5));
    final hour = now.hour;

    // Rango permitido: 10:00 (10 AM) hasta 23:00 (11 PM)
    return hour >= 10 && hour < 23;
  }

  // Generar lista de horarios disponibles para programar
  List<DateTime> _generarHorariosDisponibles() {
    List<DateTime> horarios = [];

    // Obtener hora actual en Perú
    final now = DateTime.now().toUtc().subtract(Duration(hours: 5));

    // Horarios de atención: 10:00 - 23:00
    const horaInicio = 10;
    const horaFin = 23;

    // Generar horarios solo para hoy
    DateTime fechaActual = DateTime(now.year, now.month, now.day);

    if (RESTRICT_HORARIO == 0) {
      // Sin restricciones: generar horarios para hoy de 10:00 a 23:00
      for (int hora = horaInicio; hora < horaFin; hora++) {
        for (int minuto = 0; minuto < 60; minuto += 30) {
          DateTime horario = DateTime(fechaActual.year, fechaActual.month, fechaActual.day, hora, minuto);
          if (horario.isAfter(now)) {
            horarios.add(horario);
          }
        }
      }
    } else {
      // Con restricciones: máximo 2 horas desde ahora
      final horaLimite = now.add(Duration(hours: 2));

      // Redondear la hora actual al siguiente intervalo de 30 minutos
      DateTime proximoIntervalo = _redondearASiguienteIntervalo(now);

      // Generar horarios cada 30 minutos hasta el límite de 2 horas
      DateTime horarioActual = proximoIntervalo;

      while (horarioActual.isBefore(horaLimite) || horarioActual.isAtSameMomentAs(horaLimite)) {
        // Verificar que esté dentro del horario de atención
        if (horarioActual.hour >= horaInicio && horarioActual.hour < horaFin) {
          horarios.add(horarioActual);
        }

        // Avanzar al siguiente intervalo de 30 minutos
        horarioActual = horarioActual.add(Duration(minutes: 30));
      }
    }

    return horarios;
  }

  // Redondear al siguiente intervalo de 30 minutos
  DateTime _redondearASiguienteIntervalo(DateTime dateTime) {
    int minutoActual = dateTime.minute;
    int minutoRedondeado;
    int horaAjustada = dateTime.hour;

    if (minutoActual <= 30) {
      minutoRedondeado = 30;
    } else {
      minutoRedondeado = 0;
      horaAjustada += 1;
    }

    return DateTime(dateTime.year, dateTime.month, dateTime.day, horaAjustada, minutoRedondeado);
  }

  // Mostrar selector de horarios para programar pedido
  void _mostrarSelectorHorarios() {
    final horariosDisponibles = _generarHorariosDisponibles();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.schedule, color: Colors.white, size: 24),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Programar pedido',
                              style: TextStyle(
                                fontFamily: 'Lora',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              RESTRICT_HORARIO == 1
                                  ? 'Selecciona un horario en las próximas 2 horas'
                                  : 'Selecciona un horario para hoy',
                              style: TextStyle(
                                fontFamily: 'Lora',
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenido
                Expanded(
                  child: horariosDisponibles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.info_outline, color: Colors.grey[500], size: 48),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No hay horarios disponibles',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Lora',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                RESTRICT_HORARIO == 0
                                    ? 'No hay horarios disponibles para hoy'
                                    : 'No hay horarios disponibles\npara las próximas 2 horas',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Lora',
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: horariosDisponibles.length,
                          itemBuilder: (context, index) {
                            final horario = horariosDisponibles[index];
                            final now = DateTime.now().toUtc().subtract(Duration(hours: 5));
                            final tiempoRestante = horario.difference(now);
                            final minutosRestantes = tiempoRestante.inMinutes;

                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: _primaryColor.withOpacity(0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                leading: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _accentColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.access_time, color: _primaryColor, size: 24),
                                ),
                                title: Text(
                                  DateFormat('HH:mm').format(horario),
                                  style: TextStyle(
                                    fontFamily: 'Lora',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hoy',
                                      style: TextStyle(
                                        fontFamily: 'Lora',
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'En ${minutosRestantes} minutos',
                                      style: TextStyle(
                                        fontFamily: 'Lora',
                                        color: _primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(Icons.arrow_forward_ios, color: _primaryColor, size: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    _esPedidoProgramado = true;
                                    _fechaHoraProgramada = horario;
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                ),
                // Botones inferiores
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(_borderRadius)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey[400]!),
                          ),
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _esPedidoProgramado = false;
                              _fechaHoraProgramada = null;
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'PEDIDO INMEDIATO',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Muestra el diálogo de fuera de horario
  void _mostrarDialogoFueraDeHorario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_borderRadius),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.access_time, color: Colors.white, size: 24),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Fuera de horario',
                          style: TextStyle(
                            fontFamily: 'Lora',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Contenido
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lo sentimos, no podemos generar pedidos ahora ya que estamos fuera del horario disponible.',
                        style: TextStyle(
                          fontFamily: 'Lora',
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _accentColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _primaryColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: _primaryColor, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Horario de atención',
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                      fontWeight: FontWeight.bold,
                                      color: _primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '10:00 AM - 11:00 PM',
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                      color: _primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _mostrarSelectorHorarios();
                          },
                          icon: Icon(Icons.schedule, color: Colors.white, size: 20),
                          label: Text(
                            'PROGRAMAR PEDIDO',
                            style: TextStyle(
                              fontFamily: 'Lora',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
              ),
              child: Text(
                'ENTENDIDO',
                style: TextStyle(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarPedido() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final statusProvider = Provider.of<StatusProvider>(context, listen: false);
    final detallesProvider = Provider.of<DetallesProvider>(context, listen: false);

    final detalleProductos = cartProvider.items.map((item) {
      return {
        'nombre': item.nombre,
        'precio': item.precio,
        'cantidad': item.cantidad,
        'imagenUrl': item.imagenUrl,
        'detalles': item.detalles,
      };
    }).toList();

    try {
      // Crear pedido en Firebase con información de programación
      DocumentReference pedidoRef = await _firestore.collection('pedidos').add({
        'usuario': userProvider.correo,
        'detalle_cliente': {
          'nombre': _nombreController.text,
          'direccion': _direccionController.text,
          'latitud': userProvider.latitud,
          'longitud': userProvider.longitud,
          'numero': _numeroController.text,
          'metodoPago': _metodoPago,
          'tipoComprobante': _tipoComprobante,
          'dni': _tipoComprobante == 'boleta_dni' ? _dniController.text : null,
          'ruc': _tipoComprobante == 'factura' ? _rucController.text : null,
          'comentarios': _comentariosController.text,
        },
        'detalle_productos': detalleProductos,
        'detalles_adicionales': detallesProvider.obtenerDetallesCompletos(),
        'total': cartProvider.totalAmount,
        'estado': _esPedidoProgramado ? 'Programado' : 'Generado',
        'fecha': Timestamp.now(),
        // Nuevos campos para pedidos programados
        'es_programado': _esPedidoProgramado,
        'fecha_programada': _esPedidoProgramado ? Timestamp.fromDate(_fechaHoraProgramada!) : null,
        'hora_programada': _esPedidoProgramado ? DateFormat('HH:mm').format(_fechaHoraProgramada!) : null,
      });

      // Inicializar el StatusProvider con el pedido generado
      await statusProvider.inicializarPedido(pedidoRef.id);

      // Limpiar carrito y detalles después de la confirmación
      cartProvider.clearCart();
      detallesProvider.limpiarDetalles();
    } catch (e) {
      print('Error al guardar el pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar el pedido. Inténtalo nuevamente.')),
      );
    }
  }

  void _confirmarPedido() async {
    if (_formKey.currentState!.validate()) {
      // Si no es pedido programado, verificar horario actual solo si RESTRICT_HORARIO es 1
      if (!_esPedidoProgramado && RESTRICT_HORARIO == 1 && !_dentroDeHorarioPermitido()) {
        _mostrarDialogoFueraDeHorario();
        return;
      }

      setState(() => _isLoading = true);

      await _guardarPedido();

      setState(() => _isLoading = false);

      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => _buildSuccessModal(context),
      );
    }
  }

  Widget _buildSuccessModal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(_borderRadius)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    _esPedidoProgramado ? Icons.schedule : Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _esPedidoProgramado ? '¡Pedido programado!' : '¡Pedido generado!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lora',
                        ),
                      ),
                      Text(
                        'Tu pedido ha sido procesado correctamente',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontFamily: 'Lora',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderDetail('Nombre', _nombreController.text),
                  _buildOrderDetail('Dirección', _direccionController.text),
                  _buildOrderDetail('Teléfono', _numeroController.text),
                  _buildOrderDetail('Método de pago', _metodoPago),
                  _buildOrderDetail('Tipo de comprobante', _tipoComprobante),
                  if (_esPedidoProgramado && _fechaHoraProgramada != null)
                    _buildOrderDetail(
                      'Fecha programada',
                      DateFormat('EEEE, dd/MM/yyyy - HH:mm', 'es').format(_fechaHoraProgramada!),
                    ),
                  if (_comentariosController.text.isNotEmpty)
                    _buildOrderDetail('Comentarios', _comentariosController.text),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _primaryColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: _primaryColor, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _esPedidoProgramado
                                ? 'Tu pedido ha sido programado correctamente. Nos comunicaremos contigo en el horario indicado para coordinar la entrega.'
                                : 'Nos comunicaremos contigo a la brevedad para coordinar la entrega.',
                            style: TextStyle(
                              fontSize: 14,
                              color: _primaryColor,
                              fontFamily: 'Lora',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryHomePage()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_borderRadius),
                  ),
                ),
                child: Text(
                  'VOLVER AL INICIO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: 'Lora',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'Lora',
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
              fontFamily: 'Lora',
            ),
          ),
        ],
      ),
    );
  }

  // Widget para mostrar información del pedido programado
  Widget _buildPedidoProgramadoInfo() {
    if (!_esPedidoProgramado || _fechaHoraProgramada == null) return SizedBox.shrink();

    final now = DateTime.now().toUtc().subtract(Duration(hours: 5));
    final tiempoRestante = _fechaHoraProgramada!.difference(now);
    final minutosRestantes = tiempoRestante.inMinutes;

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accentColor,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: _primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.schedule, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 12),
              Text(
                'Pedido Programado',
                style: TextStyle(
                  color: _primaryColor,
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Fecha: ${DateFormat('EEEE, dd/MM/yyyy', 'es').format(_fechaHoraProgramada!)}',
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Lora',
              fontSize: 14,
            ),
          ),
          Text(
            'Hora: ${DateFormat('HH:mm').format(_fechaHoraProgramada!)}',
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Lora',
              fontSize: 14,
            ),
          ),
          Text(
            'En $minutosRestantes minutos',
            style: TextStyle(
              color: _primaryColor,
              fontFamily: 'Lora',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _esPedidoProgramado = false;
                _fechaHoraProgramada = null;
              });
            },
            child: Text(
              'Cancelar programación',
              style: TextStyle(
                color: _primaryColor,
                fontFamily: 'Lora',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Confirmación de compra',
          style: TextStyle(
            fontFamily: 'Lora',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(_borderRadius),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información del pedido programado
                    _buildPedidoProgramadoInfo(),
                    _buildSectionTitle('Información de entrega'),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _nombreController,
                      label: 'Nombre completo',
                      icon: Icons.person_outline,
                      validator: (value) => value?.isEmpty ?? true ? 'Ingrese su nombre' : null,
                      readOnly: true,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _direccionController,
                      label: 'Dirección de entrega',
                      icon: Icons.location_on_outlined,
                      validator: (value) => value?.isEmpty ?? true ? 'Ingrese su dirección' : null,
                      readOnly: true,
                    ),
                    SizedBox(height: 16),
                    _buildInputField(
                      controller: _numeroController,
                      label: 'Número de teléfono',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.isEmpty ?? true ? 'Ingrese su teléfono' : null,
                      readOnly: true,
                    ),
                    SizedBox(height: 32),
                    _buildSectionTitle('Método de pago'),
                    SizedBox(height: 16),
                    _buildDropdown(
                      value: _metodoPago,
                      items: [
                        DropdownMenuItem(value: 'efectivo', child: Text('Efectivo', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                        DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                        DropdownMenuItem(value: 'yape', child: Text('Yape', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                        DropdownMenuItem(value: 'plin', child: Text('Plin', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                      ],
                      onChanged: (value) {
                        setState(() => _metodoPago = value!);
                      },
                      label: 'Seleccione método de pago',
                    ),
                    SizedBox(height: 32),
                    _buildSectionTitle('Tipo de comprobante'),
                    SizedBox(height: 16),
                    _buildDropdown(
                      value: _tipoComprobante,
                      items: [
                        DropdownMenuItem(value: 'boleta_simple', child: Text('Boleta Simple', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                        DropdownMenuItem(value: 'boleta_dni', child: Text('Boleta con DNI', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                        DropdownMenuItem(value: 'factura', child: Text('Factura', style: TextStyle(fontFamily: 'Lora', fontSize: 16))),
                      ],
                      onChanged: (value) {
                        setState(() => _tipoComprobante = value!);
                      },
                      label: 'Seleccione tipo de comprobante',
                    ),
                    if (_tipoComprobante == 'boleta_dni')
                      _buildInputField(
                        controller: _dniController,
                        label: 'DNI',
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Ingrese su DNI' : null,
                      ),
                    if (_tipoComprobante == 'factura')
                      _buildInputField(
                        controller: _rucController,
                        label: 'RUC',
                        icon: Icons.credit_card,
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Ingrese su RUC' : null,
                      ),
                    SizedBox(height: 32),
                    _buildSectionTitle('Comentarios adicionales'),
                    SizedBox(height: 16),
                    _buildCommentField(
                      controller: _comentariosController,
                      label: 'Comentarios para su pedido (opcional)',
                      icon: Icons.comment_outlined,
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_borderRadius),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón para confirmar pedido ahora
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _confirmarPedido,
                  icon: Icon(
                    _esPedidoProgramado ? Icons.schedule : Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: Text(
                    _esPedidoProgramado ? 'CONFIRMAR PEDIDO PROGRAMADO' : 'CONFIRMAR PEDIDO AHORA',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
              // Botón para programar pedido
              Container(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _mostrarSelectorHorarios,
                  icon: Icon(Icons.watch_later_outlined, color: _primaryColor),
                  label: Text(
                    'PROGRAMAR PEDIDO',
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_borderRadius),
                    ),
                    side: BorderSide(color: _primaryColor, width: 2),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: _primaryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: _primaryColor.withOpacity(0.7),
            fontFamily: 'Lora',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          prefixIcon: Icon(Icons.arrow_drop_down_circle_outlined, color: _primaryColor, size: 24),
        ),
        style: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: _primaryColor, size: 28),
        borderRadius: BorderRadius.circular(_borderRadius),
        menuMaxHeight: 300,
        itemHeight: 48,
        isExpanded: true,
        elevation: 4,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
        fontFamily: 'Lora',
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        style: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
          color: readOnly ? Colors.grey[700] : Colors.grey[800],
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: _primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[50] : Colors.white,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Lora',
          ),
          errorStyle: TextStyle(
            color: Colors.red[400],
            fontFamily: 'Lora',
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: readOnly ? Icon(Icons.lock_outlined, color: Colors.grey[400], size: 18) : null,
        ),
      ),
    );
  }

  Widget _buildCommentField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        style: TextStyle(
          fontFamily: 'Lora',
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Icon(icon, color: _primaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontFamily: 'Lora',
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: 'Ej: Sin cebolla, más picante, etc.',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontFamily: 'Lora',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}