class PaymentMethod {
  final String id;
  final String tipo;
  final String? numeroTarjeta;
  final String? ultimos4;
  final String? titular;
  final String? vencimiento;
  final String? cvv;
  final String? tipoTarjeta;
  final bool esPredeterminado;
  final DateTime fechaGuardado;

  PaymentMethod({
    required this.id,
    required this.tipo,
    this.numeroTarjeta,
    this.ultimos4,
    this.titular,
    this.vencimiento,
    this.cvv,
    this.tipoTarjeta,
    this.esPredeterminado = false,
    required this.fechaGuardado,
  });

  String get maskedNumber {
    if (ultimos4 != null && ultimos4!.isNotEmpty) {
      return '•••• •••• •••• $ultimos4';
    }
    if (numeroTarjeta != null && numeroTarjeta!.length >= 4) {
      final clean = numeroTarjeta!.replaceAll(' ', '');
      return '•••• •••• •••• ${clean.substring(clean.length - 4)}';
    }
    return '•••• •••• •••• ••••';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo,
    'numeroTarjeta': numeroTarjeta,
    'ultimos4': ultimos4,
    'titular': titular,
    'vencimiento': vencimiento,
    'cvv': cvv,
    'tipoTarjeta': tipoTarjeta,
    'esPredeterminado': esPredeterminado,
    'fechaGuardado': fechaGuardado.toIso8601String(),
  };

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    id: json['id'],
    tipo: json['tipo'],
    numeroTarjeta: json['numeroTarjeta'],
    ultimos4: json['ultimos4'],
    titular: json['titular'],
    vencimiento: json['vencimiento'],
    cvv: json['cvv'],
    tipoTarjeta: json['tipoTarjeta'],
    esPredeterminado: json['esPredeterminado'] ?? false,
    fechaGuardado: DateTime.parse(json['fechaGuardado']),
  );

  PaymentMethod copyWith({
    String? id,
    String? tipo,
    String? numeroTarjeta,
    String? ultimos4,
    String? titular,
    String? vencimiento,
    String? cvv,
    String? tipoTarjeta,
    bool? esPredeterminado,
    DateTime? fechaGuardado,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      numeroTarjeta: numeroTarjeta ?? this.numeroTarjeta,
      ultimos4: ultimos4 ?? this.ultimos4,
      titular: titular ?? this.titular,
      vencimiento: vencimiento ?? this.vencimiento,
      cvv: cvv ?? this.cvv,
      tipoTarjeta: tipoTarjeta ?? this.tipoTarjeta,
      esPredeterminado: esPredeterminado ?? this.esPredeterminado,
      fechaGuardado: fechaGuardado ?? this.fechaGuardado,
    );
  }
}
