class Mensaje {
  final int idMensaje;
  final int idConversacion;
  final int idUsuarioEmisor;
  final String contenido;
  final DateTime enviadoEn;
  final bool leido;

  const Mensaje({
    required this.idMensaje,
    required this.idConversacion,
    required this.idUsuarioEmisor,
    required this.contenido,
    required this.enviadoEn,
    this.leido = false,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      idMensaje: json['idMensaje'] as int,
      idConversacion: json['idConversacion'] as int,
      idUsuarioEmisor: json['idUsuarioEmisor'] as int,
      contenido: json['contenido'] as String? ?? '',
      enviadoEn: json['enviadoEn'] != null
          ? DateTime.tryParse(json['enviadoEn'] as String) ?? DateTime.now()
          : DateTime.now(),
      leido: json['leido'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMensaje': idMensaje,
      'idConversacion': idConversacion,
      'idUsuarioEmisor': idUsuarioEmisor,
      'contenido': contenido,
      'enviadoEn': enviadoEn.toIso8601String(),
      'leido': leido,
    };
  }

  String get horaEnvio {
    return '${enviadoEn.hour.toString().padLeft(2, '0')}:${enviadoEn.minute.toString().padLeft(2, '0')}';
  }
}
