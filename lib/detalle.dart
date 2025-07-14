import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'detalles_provider.dart';

class DetalleProductoPage extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagenUrl;
  final String? categoria;

  const DetalleProductoPage({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagenUrl,
    this.categoria,
  }) : super(key: key);

  @override
  _DetalleProductoPageState createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  int _cantidad = 1;
  final Color _primaryColor = const Color(0xFF800020);
  bool _isImageLoading = true;

  // Controlador para detalles generales del producto
  TextEditingController _detallesGeneralesController = TextEditingController();

  bool get _isCaldo =>
      widget.nombre.toLowerCase().contains('caldo') ||
      (widget.categoria?.toLowerCase() == 'caldos');

  bool get _requiresTerminoCarne =>
      widget.descripcion.toLowerCase().contains('bistec') ||
      widget.descripcion.toLowerCase().contains('cuadril');

  bool get _requiresCuartoPreference =>
      widget.descripcion.contains("1/4");

  bool get _requiresTipoCorte =>
      widget.descripcion.contains("Pollo") && !widget.descripcion.contains("1/4");

  bool get _requiresBebida =>
      widget.descripcion.contains("bebida");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DetallesProvider>(context, listen: false).limpiarDetalles();
    });
  }

  // Método para validar que todas las opciones requeridas estén seleccionadas
  bool _validarOpcionesRequeridas(DetallesProvider detallesProvider) {
    // Lista para almacenar mensajes de error
    List<String> opcionesFaltantes = [];

    // Validar cada tipo de opción requerida según el producto
    if (_requiresCuartoPreference && detallesProvider.preferenciaCuarto.isEmpty) {
      opcionesFaltantes.add("Corte del Cuarto de Pollo");
    }

    if (_requiresTipoCorte && detallesProvider.tipoCortePollo.isEmpty) {
      opcionesFaltantes.add("Tipo de Corte");
    }

    if (_isCaldo && detallesProvider.presaCaldo.isEmpty) {
      opcionesFaltantes.add("Presa del caldo");
    }

    if (_requiresTerminoCarne && detallesProvider.terminoCarne.isEmpty) {
      opcionesFaltantes.add("Término de la carne");
    }

    if (_requiresBebida && detallesProvider.bebidaSeleccionada.isEmpty) {
      opcionesFaltantes.add("Bebida Natural");
    }

    // Si hay opciones faltantes, mostrar un mensaje de error
    if (opcionesFaltantes.isNotEmpty) {
      _mostrarErrorOpcionesFaltantes(opcionesFaltantes);
      return false;
    }

    return true;
  }

  // Método para mostrar el mensaje de error
  void _mostrarErrorOpcionesFaltantes(List<String> opcionesFaltantes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Opciones requeridas",
          style: TextStyle(
            color: _primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Por favor selecciona las siguientes opciones antes de continuar:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ...opcionesFaltantes.map(
              (opcion) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text(
                      opcion,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              "ENTENDIDO",
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final subtotal = widget.precio * _cantidad;
    final detallesProvider = Provider.of<DetallesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: _primaryColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_cart, color: _primaryColor),
            ),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Hero(
                tag: 'product-${widget.imagenUrl}',
                child: Container(
                  height: size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.imagenUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            _isImageLoading = false;
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: _primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              transform: Matrix4.translationValues(0, -30, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.nombre.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                                fontFamily: 'Lora',
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'S/ ${widget.precio.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Text(
                        widget.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (_requiresCuartoPreference)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Corte del Cuarto de Pollo:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildRadioButton(
                                  "Pecho",
                                  detallesProvider.preferenciaCuarto == "Pecho",
                                  () => detallesProvider.setCortePollo("Cuartos",
                                      preferencia: "Pecho"),
                                ),
                                const SizedBox(width: 8),
                                _buildRadioButton(
                                  "Pierna",
                                  detallesProvider.preferenciaCuarto == "Pierna",
                                  () => detallesProvider.setCortePollo("Cuartos",
                                      preferencia: "Pierna"),
                                ),
                              ],
                            ),
                          ],
                        ),

                      if (_requiresTipoCorte)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Tipo de Corte:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildRadioButton(
                                  "Cuartos",
                                  detallesProvider.tipoCortePollo == "Cuartos",
                                  () => detallesProvider.setCortePollo("Cuartos"),
                                ),
                                const SizedBox(width: 8),
                                _buildRadioButton(
                                  "Octavos",
                                  detallesProvider.tipoCortePollo == "Octavos",
                                  () => detallesProvider.setCortePollo("Octavos"),
                                ),
                              ],
                            ),
                          ],
                        ),

                      if (_isCaldo)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Selecciona la presa del caldo:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildPresaCaldoPopupMenu(detallesProvider),
                          ],
                        ),

                      if (_requiresTerminoCarne)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Término de la carne:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: detallesProvider.terminosCarne
                                  .map((termino) => _buildRadioButton(
                                        termino,
                                        detallesProvider.terminoCarne == termino,
                                        () => detallesProvider
                                            .setTerminoCarne(termino),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),

                      if (_requiresBebida)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Bebida Natural:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _primaryColor,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildBebidaPopupMenu(detallesProvider),
                            if (detallesProvider.bebidaSeleccionada.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        "Temperatura de la bebida:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _primaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "*",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildRadioButton(
                                        "Helada",
                                        detallesProvider.temperaturaBebida ==
                                            "Helada",
                                        () => detallesProvider
                                            .setTemperaturaBebida("Helada"),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildRadioButton(
                                        "Al tiempo",
                                        detallesProvider.temperaturaBebida ==
                                            "Al tiempo",
                                        () => detallesProvider
                                            .setTemperaturaBebida("Al tiempo"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),

                      // Campo para comentarios específicos del producto
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          Text(
                            "Especificaciones adicionales:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _detallesGeneralesController,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                hintText: "Ej: Sin ají, menos sal, etc.",
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                detallesProvider.setDetallesGenerales(value);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cantidad',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: _primaryColor,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  _buildQuantityButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      if (_cantidad > 1) {
                                        setState(() => _cantidad--);
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '$_cantidad',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() => _cantidad++);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'S/ ${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Validar que todas las opciones requeridas estén seleccionadas
                    if (_validarOpcionesRequeridas(detallesProvider)) {
                      // Si todas las validaciones pasan, entonces añadir al carrito
                      Map<String, dynamic> detallesProducto = detallesProvider.obtenerDetallesCompletos();
                      
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        widget.nombre,
                        widget.precio,
                        widget.imagenUrl,
                        _cantidad,
                        detallesProducto,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('¡Producto añadido al carrito!'),
                          backgroundColor: _primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    }
                    // Si no pasa las validaciones, _validarOpcionesRequeridas ya muestra el error
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'AÑADIR AL CARRITO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? _primaryColor : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBebidaPopupMenu(DetallesProvider detallesProvider) {
    return PopupMenuButton<String>(
      onSelected: (value) => detallesProvider.setBebida("Natural", value),
      itemBuilder: (context) {
        return detallesProvider.bebidasNaturales.map((bebida) {
          return PopupMenuItem(
            value: bebida,
            child: Text(
              bebida,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              detallesProvider.bebidaSeleccionada.isEmpty
                  ? "Selecciona una bebida"
                  : detallesProvider.bebidaSeleccionada,
              style: TextStyle(
                fontSize: 16,
                color: detallesProvider.bebidaSeleccionada.isEmpty
                    ? Colors.grey[600]
                    : _primaryColor,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildPresaCaldoPopupMenu(DetallesProvider detallesProvider) {
    return PopupMenuButton<String>(
      onSelected: (value) => detallesProvider.setPresaCaldo(value),
      itemBuilder: (context) {
        return detallesProvider.presasCaldo.map((presa) {
          return PopupMenuItem(
            value: presa,
            child: Text(
              presa,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              detallesProvider.presaCaldo.isEmpty
                  ? "Selecciona una presa"
                  : detallesProvider.presaCaldo,
              style: TextStyle(
                fontSize: 16,
                color: detallesProvider.presaCaldo.isEmpty
                    ? Colors.grey[600]
                    : _primaryColor,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: _primaryColor),
          ],
        ),
      ),
    );
  }
}