class Repartidor {
  final int id;
  final int idUsuario;
  final String placaVehiculo;
  final String estado;
  final String vehiculo;
  final double promedioCalificacion;
  final String cuentaBancaria;
  final String urlFotoPerfil;
  final String zonaOperaciones;
  final String departamento;

  const Repartidor({
    required this.id,
    required this.idUsuario,
    required this.placaVehiculo,
    this.estado = "DISPONIBLE",
    required this.vehiculo,
    required this.promedioCalificacion,
    required this.cuentaBancaria,
    required this.urlFotoPerfil,
    required this.zonaOperaciones,
    required this.departamento,
  });

  factory Repartidor.fromJson(Map<String, dynamic> json) {
    return Repartidor(
      id: json['id'] as int,
      idUsuario: json['idUsuario'] as int,
      placaVehiculo: json['placaVehiculo'] as String? ?? '',
      estado: json['estado'] as String? ?? 'DISPONIBLE',
      vehiculo: json['vehiculo'] as String? ?? '',
      promedioCalificacion: (json['promedioCalificacion'] as num?)?.toDouble() ?? 0.0,
      cuentaBancaria: json['cuentaBancaria'] as String? ?? '',
      urlFotoPerfil: json['urlFotoPerfil'] as String? ?? '',
      zonaOperaciones: json['zonaOperaciones'] as String? ?? '',
      departamento: json['departamento'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'placaVehiculo': placaVehiculo,
      'estado': estado,
      'vehiculo': vehiculo,
      'promedioCalificacion': promedioCalificacion,
      'cuentaBancaria': cuentaBancaria,
      'urlFotoPerfil': urlFotoPerfil,
      'zonaOperaciones': zonaOperaciones,
      'departamento': departamento,
    };
  }
}
