import 'package:flutter/material.dart';

class OrderStatusBar extends StatelessWidget {
  final String estado;

  const OrderStatusBar({Key? key, required this.estado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Sigue el estado de tu pedido',
            style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Color(0xFF800020),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: _buildStatusItem(
                  'Generado',
                  Icons.description_outlined,
                  estado == 'Generado',
                  isCompleted: _isStateCompleted('Generado', estado),
                  size: size,
                ),
              ),
              _buildConnector(
                _isStateCompleted('Generado', estado),
                size: size,
              ),
              Flexible(
                child: _buildStatusItem(
                  'En Preparación',
                  Icons.restaurant,
                  estado == 'En Preparación',
                  isCompleted: _isStateCompleted('En Preparación', estado),
                  size: size,
                ),
              ),
              _buildConnector(
                _isStateCompleted('En Preparación', estado),
                size: size,
              ),
              Flexible(
                child: _buildStatusItem(
                  'En Camino',
                  Icons.delivery_dining,
                  estado == 'En Camino',
                  isCompleted: _isStateCompleted('En Camino', estado),
                  size: size,
                ),
              ),
              _buildConnector(
                _isStateCompleted('En Camino', estado),
                size: size,
              ),
              Flexible(
                child: _buildStatusItem(
                  'Entregado',
                  Icons.check_circle_outline,
                  estado == 'Entregado',
                  isCompleted: _isStateCompleted('Entregado', estado),
                  size: size,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, IconData icon, bool isActive,
      {bool isCompleted = false, required Size size}) {
    final color = isActive || isCompleted ? Color(0xFF800020) : Colors.grey;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: size.width * 0.06),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          label,
          style: TextStyle(
            fontSize: size.width * 0.03,
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConnector(bool isCompleted, {required Size size}) {
    return Container(
      width: size.width * 0.06,
      height: 2,
      color: isCompleted ? Color(0xFF800020) : Colors.grey.withOpacity(0.3),
    );
  }

  bool _isStateCompleted(String state, String currentState) {
    final states = ['Generado', 'En Preparación', 'En Camino', 'Entregado'];
    final stateIndex = states.indexOf(state);
    final currentStateIndex = states.indexOf(currentState);
    return currentStateIndex > stateIndex;
  }
}
