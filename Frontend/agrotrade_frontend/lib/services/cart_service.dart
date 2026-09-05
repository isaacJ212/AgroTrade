import 'package:flutter/foundation.dart';

class ItemCarrito {
  final int id;
  final String nombre;
  final String finca;
  final String unidad;
  final double precioUnitario;
  int cantidad;
  final String imagenUrl;

  ItemCarrito({
    required this.id,
    required this.nombre,
    required this.finca,
    required this.unidad,
    required this.precioUnitario,
    required this.cantidad,
    required this.imagenUrl,
  });

  double get subtotal => precioUnitario * cantidad;
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  static CartService get instance => _instance;
  CartService._internal();

  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => List.unmodifiable(_items);

  double get subtotalProductos => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  
  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  void addItem(ItemCarrito item) {
    print('--- AGREGANDO PRODUCTO AL CARRITO ---');
    print('ID: ${item.id}, Producto: ${item.nombre}, Cantidad: ${item.cantidad}, Precio: ${item.precioUnitario}');
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index >= 0) {
      _items[index].cantidad += item.cantidad;
      print('El producto ya existía. Nueva cantidad: ${_items[index].cantidad}');
    } else {
      _items.add(item);
      print('Producto nuevo agregado al carrito.');
    }
    notifyListeners();
  }

  void updateCantidad(int id, int delta) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index >= 0) {
      final nuevaCantidad = _items[index].cantidad + delta;
      if (nuevaCantidad <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].cantidad = nuevaCantidad;
      }
      notifyListeners();
    }
  }

  void removeItem(int id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Map<String, List<ItemCarrito>> get agrupadoPorFinca {
    final Map<String, List<ItemCarrito>> map = {};
    for (final item in _items) {
      map.putIfAbsent(item.finca, () => []).add(item);
    }
    return map;
  }
}
