class ValoracionConsumidor {
  final int idValoracion;
  final int idPedido;
  final int idUsuarioCliente;
  final int idProveedor;
  final String? tipoValoracion;
  final int puntuacion;
  final String? comentario;
  final DateTime fechaValoracion;

  const ValoracionConsumidor({
    required this.idValoracion,
    required this.idPedido,
    required this.idUsuarioCliente,
    required this.idProveedor,
    this.tipoValoracion,
    required this.puntuacion,
    this.comentario,
    required this.fechaValoracion,
  });

  factory ValoracionConsumidor.fromJson(Map<String, dynamic> json) {
    return ValoracionConsumidor(
      idValoracion: json['idValoracion'] as int,
      idPedido: json['idPedido'] as int,
      idUsuarioCliente: json['idUsuarioCliente'] as int,
      idProveedor: json['idProveedor'] as int,
      tipoValoracion: json['tipoValoracion'] as String?,
      puntuacion: json['puntuacion'] as int? ?? 5,
      comentario: json['comentario'] as String?,
      fechaValoracion: json['fechaValoracion'] != null
          ? DateTime.tryParse(json['fechaValoracion'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idValoracion': idValoracion,
      'idPedido': idPedido,
      'idUsuarioCliente': idUsuarioCliente,
      'idProveedor': idProveedor,
      'tipoValoracion': tipoValoracion,
      'puntuacion': puntuacion,
      'comentario': comentario,
      'fechaValoracion': fechaValoracion.toIso8601String(),
    };
  }
}
