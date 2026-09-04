import 'package:flutter/foundation.dart';

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
  EstadoEntregaDemo estado;
  bool recogido;
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
  });

  double get total => productos.fold(0.0, (suma, p) => suma + p.subtotal);
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

  static const tomate =
      'https://www.yarabrasil.com.br/globalassets/blog-yara-nutre_tomate_640x420px-9.png';
  static const naranja =
      'https://images.unsplash.com/photo-1547514701-42782101795e?auto=format&fit=crop&w=240&q=80';
  static const manzana =
      'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=240&q=80';

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
  ];

  List<EntregaDemo> get entregas => List.unmodifiable(_entregas);
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

  void aceptar(int id) {
    if (!disponible) return;
    final entrega = buscar(id);
    if (entrega == null || entrega.estado != EstadoEntregaDemo.pendiente)
      return;
    entrega.estado = EstadoEntregaDemo.enCurso;
    notifyListeners();
  }

  void recoger(int id) {
    final entrega = buscar(id);
    if (entrega == null || entrega.estado != EstadoEntregaDemo.enCurso) return;
    entrega.recogido = true;
    notifyListeners();
  }

  void completar(int id, String nota) {
    final entrega = buscar(id);
    if (entrega == null ||
        entrega.estado != EstadoEntregaDemo.enCurso ||
        !entrega.recogido)
      return;
    entrega.estado = EstadoEntregaDemo.completada;
    entrega.nota = nota.trim();
    notifyListeners();
  }
}
