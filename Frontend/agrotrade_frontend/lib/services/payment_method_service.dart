import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_method.dart';
import 'api_session.dart';

class PaymentMethodService {
  PaymentMethodService._();
  static final PaymentMethodService instance = PaymentMethodService._();

  static const String _keyPrefix = 'agrotrade_payment_methods_';

  String _getStorageKey() {
    final userId = ApiSession.instance.userId ?? 'guest';
    final key = '$_keyPrefix$userId';
    print('DEBUG [PaymentService] Storage key: $key');
    return key;
  }

  Future<List<PaymentMethod>> getAll() async {
    try {
      print('DEBUG [PaymentService] getAll() - Obteniendo métodos guardados...');
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_getStorageKey());
      if (raw == null || raw.isEmpty) {
        print('DEBUG [PaymentService] No hay métodos guardados (lista vacía).');
        return [];
      }
      final List<dynamic> list = jsonDecode(raw);
      final result = list.map((e) => PaymentMethod.fromJson(e)).toList();
      print('DEBUG [PaymentService] Se cargaron ${result.length} métodos de pago.');
      return result;
    } catch (e, stack) {
      print('DEBUG [PaymentService] ERROR getAll(): $e');
      print('DEBUG [PaymentService] StackTrace: $stack');
      return [];
    }
  }

  Future<PaymentMethod?> getDefault() async {
    try {
      print('DEBUG [PaymentService] getDefault() - Buscando método predeterminado...');
      final list = await getAll();
      try {
        final def = list.firstWhere((m) => m.esPredeterminado);
        print('DEBUG [PaymentService] Predeterminado encontrado: ${def.titular ?? def.tipo}');
        return def;
      } catch (_) {
        if (list.isNotEmpty) {
          print('DEBUG [PaymentService] Sin predeterminado. Usando primero: ${list.first.titular ?? list.first.tipo}');
          return list.first;
        }
        print('DEBUG [PaymentService] Lista vacía: sin predeterminado.');
        return null;
      }
    } catch (e) {
      print('DEBUG [PaymentService] ERROR getDefault(): $e');
      return null;
    }
  }

  Future<PaymentMethod> save(PaymentMethod method) async {
    try {
      print('DEBUG [PaymentService] save() - Guardando método: ${method.tipo} / ${method.titular ?? 'sin titular'} (predet: ${method.esPredeterminado})');
      final list = await getAll();

      if (method.esPredeterminado) {
        print('DEBUG [PaymentService] Removiendo flag predeterminado de ${list.length} métodos existentes.');
        for (int i = 0; i < list.length; i++) {
          list[i] = list[i].copyWith(esPredeterminado: false);
        }
      }

      final idx = list.indexWhere((m) => m.id == method.id);
      if (idx >= 0) {
        print('DEBUG [PaymentService] Actualizando método existente en índice $idx.');
        list[idx] = method;
      } else {
        print('DEBUG [PaymentService] Agregando método NUEVO.');
        list.add(method);
      }

      await _persist(list);
      print('DEBUG [PaymentService] save() - ÉXITO. Total almacenados: ${list.length}');
      return method;
    } catch (e, stack) {
      print('DEBUG [PaymentService] ERROR save(): $e');
      print('DEBUG [PaymentService] StackTrace: $stack');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      print('DEBUG [PaymentService] delete() - Eliminando método ID: $id');
      final list = await getAll();
      final antes = list.length;
      list.removeWhere((m) => m.id == id);
      if (antes == list.length) {
        print('DEBUG [PaymentService] No se encontró el ID para eliminar.');
      } else {
        await _persist(list);
        print('DEBUG [PaymentService] Eliminado correctamente. Antes: $antes, Ahora: ${list.length}');
      }
    } catch (e) {
      print('DEBUG [PaymentService] ERROR delete(): $e');
    }
  }

  Future<void> setDefault(String id) async {
    try {
      print('DEBUG [PaymentService] setDefault() - ID: $id');
      final list = await getAll();
      for (int i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(esPredeterminado: list[i].id == id);
      }
      await _persist(list);
      print('DEBUG [PaymentService] setDefault() - ÉXITO.');
    } catch (e) {
      print('DEBUG [PaymentService] ERROR setDefault(): $e');
    }
  }

  Future<void> _persist(List<PaymentMethod> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = jsonEncode(list.map((e) => e.toJson()).toList());
      final ok = await prefs.setString(_getStorageKey(), raw);
      print('DEBUG [PaymentService] _persist() - SharedPreferences setString OK=$ok, chars=${raw.length}');
    } catch (e, stack) {
      print('DEBUG [PaymentService] ERROR _persist(): $e');
      print('DEBUG [PaymentService] StackTrace: $stack');
    }
  }
}
