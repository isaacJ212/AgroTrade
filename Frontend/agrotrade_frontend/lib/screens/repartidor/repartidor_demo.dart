import 'package:flutter/foundation.dart';

import '../../models/api/delivery_models.dart';
import '../../services/api_client.dart';
import '../../services/delivery_api_service.dart';

enum EstadoEntregaDemo { pendiente, enCurso, completada }

class ProductoEntregaDemo {
  final String nombre;
  final int cantidad;
  final String unidad;
  final double precio;
  final String imagen;
  const ProductoEntregaDemo(
    this.nombre,
    this.cantidad,
    this.unidad,
    this.precio,
    this.imagen,
  );
  double get subtotal => cantidad * precio;
}

class EntregaDemo {
  final int id;
  final String finca;
  final String cliente;
  final String destino;
  final String indicaciones;
  final String hora;
  final double distancia;
  final int minutos;
  final double pago;
  final List<ProductoEntregaDemo> productos;
  final double? totalApi;
  EstadoEntregaDemo estado;
  bool recogido;
  final bool esApi;
  String nota = '';

  EntregaDemo({
    required this.id,
    required this.finca,
    required this.cliente,
    required this.destino,
    required this.hora,
    required this.productos,
    this.indicaciones = 'Avisar al llegar al punto de entrega.',
    this.distancia = 4.2,
    this.minutos = 20,
    this.pago = 50,
    this.estado = EstadoEntregaDemo.pendiente,
    this.recogido = false,
    this.esApi = false,
    this.totalApi,
  });

  factory EntregaDemo.fromApi(PendingDeliveryNotificationDto notification) {
    final fecha = notification.fechaCreacion;
    return EntregaDemo(
      id: notification.pedidoId,
      finca: 'Productor del pedido',
      cliente: 'Cliente del pedido',
      destino: notification.zonaEntrega,
      hora: fecha == null ? 'Por confirmar' : _formatHour(fecha),
      pago: notification.totalPedido,
      totalApi: notification.totalPedido,
      productos: const [],
      indicaciones: 'Consulta los detalles del pedido en la entrega.',
      esApi: true,
    );
  }

  static String _formatHour(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour < 12 ? 'a. m.' : 'p. m.';
    return '$hour:$minute $period';
  }

  double get total =>
      totalApi ?? productos.fold(0.0, (suma, p) => suma + p.subtotal);
  String get codigo => '#AT-$id';
  String get estadoTexto {
    switch (estado) {
      case EstadoEntregaDemo.pendiente:
        return 'Pendiente';
      case EstadoEntregaDemo.enCurso:
        return recogido ? 'En camino' : 'Por recoger';
      case EstadoEntregaDemo.completada:
        return 'Completada';
    }
  }
}

class RepartidorDemo extends ChangeNotifier {
  RepartidorDemo();
  static final instance = RepartidorDemo();

  bool _apiCargada = false;
  bool _cargandoApi = false;
  String? _apiError;

  static const tomate =
      'https://www.yarabrasil.com.br/globalassets/blog-yara-nutre_tomate_640x420px-9.png';
  static const naranja =
      'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=240&q=80';
  static const manzana =
      'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=240&q=80';
  static const cafe =
      'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=240&q=80';
  static const queso =
      'https://images.unsplash.com/photo-1452195100486-9cc805987862?auto=format&fit=crop&w=240&q=80';
  static const banano =
      'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=240&q=80';

  bool disponible = true;
  bool notificaciones = true;
  final List<EntregaDemo> _entregas = [
    EntregaDemo(
      id: 101,
      finca: 'Finca La Esperanza',
      cliente: 'María López',
      destino: 'Barrio Centro, Jinotepe',
      hora: '10:30 a. m.',
      indicaciones: 'Casa de portón verde, frente al parque.',
      productos: const [
        ProductoEntregaDemo('Tomate', 2, 'lb', 25, tomate),
        ProductoEntregaDemo('Naranja', 2, 'doc', 18, naranja),
        ProductoEntregaDemo('Manzana', 1, 'lb', 32, manzana),
      ],
    ),
    EntregaDemo(
      id: 102,
      finca: 'Cooperativa Los Andes',
      cliente: 'Roberto García',
      destino: 'Barrio San José, Diriamba',
      hora: '10:00 a. m.',
      distancia: 6.1,
      minutos: 25,
      pago: 65,
      estado: EstadoEntregaDemo.enCurso,
      recogido: true,
      indicaciones: 'Entregar en la entrada principal. Avisar al llegar.',
      productos: const [
        ProductoEntregaDemo('Naranja', 3, 'doc', 18, naranja),
        ProductoEntregaDemo('Manzana', 2, 'lb', 32, manzana),
      ],
    ),
    EntregaDemo(
      id: 103,
      finca: 'Finca El Carmen',
      cliente: 'Ana Ruiz',
      destino: 'Centro de Dolores, Carazo',
      hora: '11:00 a. m.',
      distancia: 3.5,
      minutos: 15,
      pago: 45,
      productos: const [ProductoEntregaDemo('Manzana', 3, 'lb', 32, manzana)],
    ),
    EntregaDemo(
      id: 104,
      finca: 'Finca La Esperanza',
      cliente: 'Luis Castillo',
      destino: 'Barrio San Antonio, Jinotepe',
      hora: '8:15 a. m.',
      pago: 55,
      estado: EstadoEntregaDemo.completada,
      recogido: true,
      productos: const [ProductoEntregaDemo('Tomate', 3, 'lb', 25, tomate)],
    ),
    EntregaDemo(
      id: 105,
      finca: 'Cooperativa Los Andes',
      cliente: 'Elena Pérez',
      destino: 'Barrio La Cruz, Diriamba',
      hora: '9:00 a. m.',
      pago: 65,
      estado: EstadoEntregaDemo.completada,
      recogido: true,
      productos: const [ProductoEntregaDemo('Naranja', 2, 'doc', 18, naranja)],
    ),
    EntregaDemo(
      id: 106,
      finca: 'Finca San José',
      cliente: 'Restaurante El Güegüense',
      destino: 'Masaya, Masaya',
      hora: '12:30 p. m.',
      distancia: 15.2,
      minutos: 35,
      pago: 90,
      productos: const [
        ProductoEntregaDemo('Banano', 4, 'kg', 68, banano),
        ProductoEntregaDemo('Queso fresco', 2, 'lb', 78, queso),
      ],
    ),
    EntregaDemo(
      id: 107,
      finca: 'Cooperativa El Progreso',
      cliente: 'Pulpería La Bendición',
      destino: 'Barrio San Antonio, Jinotepe',
      hora: '1:15 p. m.',
      distancia: 7.4,
      minutos: 22,
      pago: 60,
      productos: const [ProductoEntregaDemo('Café tostado', 3, 'lb', 95, cafe)],
    ),
  ];

  List<EntregaDemo> get entregas => List.unmodifiable(_entregas);
  bool get cargandoApi => _cargandoApi;
  String? get apiError => _apiError;
  List<EntregaDemo> porEstado(EstadoEntregaDemo estado) =>
      _entregas.where((e) => e.estado == estado).toList(growable: false);
  EntregaDemo? buscar(int? id) {
    if (id == null) return null;
    for (final entrega in _entregas) {
      if (entrega.id == id) return entrega;
    }
    return null;
  }

  EntregaDemo? get activa {
    final lista = porEstado(EstadoEntregaDemo.enCurso);
    return lista.isEmpty ? null : lista.first;
  }

  double get ganancias => porEstado(
    EstadoEntregaDemo.completada,
  ).fold(0.0, (suma, e) => suma + e.pago);

  void cambiarDisponibilidad(bool valor) {
    disponible = valor;
    notifyListeners();
  }

  void cambiarNotificaciones(bool valor) {
    notificaciones = valor;
    notifyListeners();
  }

  Future<void> cargarDesdeApi() async {
    if (_apiCargada || _cargandoApi) return;
    _cargandoApi = true;
    _apiError = null;
    notifyListeners();
    try {
      final pendientes = await DeliveryApiService.instance
          .getPendingDeliveries();
      for (final pendiente in pendientes) {
        if (pendiente.pedidoId <= 0 || buscar(pendiente.pedidoId) != null) {
          continue;
        }
        _entregas.add(EntregaDemo.fromApi(pendiente));
      }
      _apiCargada = true;
    } on ApiException catch (error) {
      _apiError = error.message;
    } catch (_) {
      _apiError = 'No se pudieron cargar las entregas del servidor.';
    } finally {
      _cargandoApi = false;
      notifyListeners();
    }
  }

  void registrarPendientesApi(List<PendingDeliveryNotificationDto> pendientes) {
    for (final pendiente in pendientes) {
      if (pendiente.pedidoId <= 0 || buscar(pendiente.pedidoId) != null) {
        continue;
      }
      _entregas.add(EntregaDemo.fromApi(pendiente));
    }
    notifyListeners();
  }

  void aceptar(int id) {
    if (!disponible) {
      return;
    }
    final entrega = buscar(id);
    if (entrega == null || entrega.estado != EstadoEntregaDemo.pendiente) {
      return;
    }
    entrega.estado = EstadoEntregaDemo.enCurso;
    notifyListeners();
  }

  Future<void> aceptarEntrega(int id) async {
    final entrega = buscar(id);
    if (!disponible ||
        entrega == null ||
        entrega.estado != EstadoEntregaDemo.pendiente) {
      return;
    }
    if (entrega.esApi) {
      await DeliveryApiService.instance.acceptDelivery(id);
    }
    aceptar(id);
  }

  void recoger(int id) {
    final entrega = buscar(id);
    if (entrega == null || entrega.estado != EstadoEntregaDemo.enCurso) {
      return;
    }
    entrega.recogido = true;
    notifyListeners();
  }

  Future<void> confirmarRecogida(int id) async {
    final entrega = buscar(id);
    if (entrega == null || entrega.estado != EstadoEntregaDemo.enCurso) {
      throw StateError('La entrega no está lista para confirmar la recogida.');
    }
    recoger(id);
  }

  void completar(int id, String nota) {
    final entrega = buscar(id);
    if (entrega == null ||
        entrega.estado != EstadoEntregaDemo.enCurso ||
        !entrega.recogido) {
      return;
    }
    entrega.estado = EstadoEntregaDemo.completada;
    entrega.nota = nota.trim();
    notifyListeners();
  }

  Future<void> confirmarEntrega(int id, String nota) async {
    final entrega = buscar(id);
    if (entrega == null ||
        entrega.estado != EstadoEntregaDemo.enCurso ||
        !entrega.recogido) {
      throw StateError('La entrega debe estar recogida antes de completarse.');
    }
    completar(id, nota);
  }
}
