import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'api_client.dart';
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
    _syncAddItemToBackend(item.id, item.cantidad);
  }

  Future<void> _syncAddItemToBackend(int productId, int quantity) async {
    try {
      print('DEBUG: [CartService] Sincronizando con backend: agregando productId $productId cant $quantity');
      await ApiClient.instance.post(
        '/api/carrito/add',
        authorized: true,
        body: {
          'productId': productId,
          'quantity': quantity
        }
      );
    } catch (e) {
      print('DEBUG: [CartService] Error sincronizando carrito: $e');
    }
  }

  void updateCantidad(int id, int delta) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index >= 0) {
      final nuevaCantidad = _items[index].cantidad + delta;
      if (nuevaCantidad <= 0) {
        _items.removeAt(index);
        _syncRemoveFromBackend(id);
      } else {
        _items[index].cantidad = nuevaCantidad;
        // La API Add suma o resta. Si queremos mandar un update exacto, o un delta.
        // El endpoint Add del backend suma a la cantidad actual.
        // Por lo que mandar `delta` es correcto.
        _syncAddItemToBackend(id, delta);
      }
      notifyListeners();
    }
  }

  Future<void> _syncRemoveFromBackend(int productId) async {
    // Si la API no tiene un remove individual (solo add y clear), mandamos cantidad negativa
    // para llegar a 0.
    final itemActual = _items.firstWhere((i) => i.id == productId, orElse: () => ItemCarrito(id: -1, nombre: '', finca: '', unidad: '', precioUnitario: 0, cantidad: 0, imagenUrl: ''));
    if (itemActual.id != -1) {
      _syncAddItemToBackend(productId, -itemActual.cantidad);
    } else {
      _syncAddItemToBackend(productId, -9999); // Force reset
    }
  }

  void removeItem(int id) {
    _syncRemoveFromBackend(id);
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _syncClearCartToBackend();
  }

  Future<void> _syncClearCartToBackend() async {
    try {
      print('DEBUG: [CartService] Sincronizando con backend: limpiando carrito');
      await ApiClient.instance.delete(
        '/api/carrito/clear',
        authorized: true,
      );
    } catch (e) {
      print('DEBUG: [CartService] Error limpiando carrito en backend: $e');
    }
  }

  Map<String, List<ItemCarrito>> get agrupadoPorFinca {
    final Map<String, List<ItemCarrito>> map = {};
    for (final item in _items) {
      map.putIfAbsent(item.finca, () => []).add(item);
    }
    return map;
  }
}
