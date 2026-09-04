class DatosRepartidor {
  final String numeroCedula;
  final String placaVehiculo;
  final String tipoVehiculo;
  final String marcaVehiculo;
  final String zonaOperaciones;
  final String departamento;
  final String urlFotoPerfil;
  final String urlFotoCedula;
  final String urlRecordPolicial;
  final String urlLicencia;
  final String bancoNombre;
  final String numeroCuenta;

  const DatosRepartidor({
    required this.numeroCedula,
    required this.placaVehiculo,
    required this.tipoVehiculo,
    required this.marcaVehiculo,
    required this.zonaOperaciones,
    required this.departamento,
    required this.urlFotoPerfil,
    required this.urlFotoCedula,
    required this.urlRecordPolicial,
    required this.urlLicencia,
    required this.bancoNombre,
    required this.numeroCuenta,
  });

  factory DatosRepartidor.fromJson(Map<String, dynamic> json) {
    return DatosRepartidor(
      numeroCedula: json['numeroCedula'] as String? ?? '',
      placaVehiculo: json['placaVehiculo'] as String? ?? '',
      tipoVehiculo: json['tipoVehiculo'] as String? ?? '',
      marcaVehiculo: json['marcaVehiculo'] as String? ?? '',
      zonaOperaciones: json['zonaOperaciones'] as String? ?? '',
      departamento: json['departamento'] as String? ?? '',
      urlFotoPerfil: json['urlFotoPerfil'] as String? ?? '',
      urlFotoCedula: json['urlFotoCedula'] as String? ?? '',
      urlRecordPolicial: json['urlRecordPolicial'] as String? ?? '',
      urlLicencia: json['urlLicencia'] as String? ?? '',
      bancoNombre: json['bancoNombre'] as String? ?? '',
      numeroCuenta: json['numeroCuenta'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numeroCedula': numeroCedula,
      'placaVehiculo': placaVehiculo,
      'tipoVehiculo': tipoVehiculo,
      'marcaVehiculo': marcaVehiculo,
      'zonaOperaciones': zonaOperaciones,
      'departamento': departamento,
      'urlFotoPerfil': urlFotoPerfil,
      'urlFotoCedula': urlFotoCedula,
      'urlRecordPolicial': urlRecordPolicial,
      'urlLicencia': urlLicencia,
      'bancoNombre': bancoNombre,
      'numeroCuenta': numeroCuenta,
    };
  }
}
