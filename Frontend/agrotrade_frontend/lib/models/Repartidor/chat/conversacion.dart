class ConversacionRepartidor {
  final int idConversacion;
  final int idPedido;
  final DateTime creadaEn;

  const ConversacionRepartidor({
    required this.idConversacion,
    required this.idPedido,
    required this.creadaEn,
  });

  factory ConversacionRepartidor.fromJson(Map<String, dynamic> json) {
    return ConversacionRepartidor(
      idConversacion: json['idConversacion'] as int,
      idPedido: json['idPedido'] as int,
      creadaEn: json['creadaEn'] != null
          ? DateTime.tryParse(json['creadaEn'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idConversacion': idConversacion,
      'idPedido': idPedido,
      'creadaEn': creadaEn.toIso8601String(),
    };
  }
}
