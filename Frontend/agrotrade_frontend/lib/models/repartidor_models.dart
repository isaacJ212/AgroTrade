class RepartidorEstado {
  final bool tieneRepartidor;
  final String? solicitudEstado;
  final String? comentarioModerador;
  final int? repartidorId;

  RepartidorEstado({
    required this.tieneRepartidor,
    this.solicitudEstado,
    this.comentarioModerador,
    this.repartidorId,
  });

  factory RepartidorEstado.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return RepartidorEstado(
      tieneRepartidor: data['tieneRepartidor'] ?? false,
      solicitudEstado: data['solicitudEstado'],
      comentarioModerador: data['comentarioModerador'],
      repartidorId: data['repartidorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tieneRepartidor': tieneRepartidor,
      'solicitudEstado': solicitudEstado,
      'comentarioModerador': comentarioModerador,
      'repartidorId': repartidorId,
    };
  }

  /// Devuelve true si el repartidor está completamente verificado y puede operar
  bool get estaVerificado => tieneRepartidor == true;

  /// Devuelve true si tiene una solicitud en revisión
  bool get estaPendiente => solicitudEstado == 'pendiente';

  /// Devuelve true si la solicitud fue rechazada
  bool get estaRechazada => solicitudEstado == 'Rechazada';

  /// Devuelve true si no tiene nada (requiere onboarding)
  bool get requiereOnboarding => !tieneRepartidor && solicitudEstado == null;
}