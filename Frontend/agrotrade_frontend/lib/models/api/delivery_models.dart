import 'json_helpers.dart';

class PendingDeliveryNotificationDto {
  final int pedidoId;
  final String zonaEntrega;
  final double totalPedido;
  final DateTime? fechaCreacion;

  const PendingDeliveryNotificationDto({
    required this.pedidoId,
    required this.zonaEntrega,
    required this.totalPedido,
    required this.fechaCreacion,
  });

  factory PendingDeliveryNotificationDto.fromJson(Map<String, dynamic> json) {
    return PendingDeliveryNotificationDto(
      pedidoId: readInt(json, const ['PedidoId', 'pedidoId']) ?? 0,
      zonaEntrega: readString(json, const ['ZonaEntrega', 'zonaEntrega']) ?? '',
      totalPedido: readDouble(json, const ['TotalPedido', 'totalPedido']) ?? 0,
      fechaCreacion: readDateTime(json, const ['FechaCreacion', 'fechaCreacion']),
    );
  }
}

class CreateDeliveryRequestDto {
  final String numeroCedula;
  final String placaVehiculo;
  final String tipoVehiculo;
  final String urlFotoCedula;
  final String urlFotoPerfil;
  final String urlRecordPolicial;
  final String urlLicencia;
  final String bancoNombre;
  final String numeroCuenta;
  final String marcaVehiculo;
  final String zonaOperaciones;
  final String departamento;

  const CreateDeliveryRequestDto({
    required this.numeroCedula,
    required this.placaVehiculo,
    required this.tipoVehiculo,
    required this.urlFotoCedula,
    required this.urlFotoPerfil,
    required this.urlRecordPolicial,
    required this.urlLicencia,
    required this.bancoNombre,
    required this.numeroCuenta,
    required this.marcaVehiculo,
    required this.zonaOperaciones,
    required this.departamento,
  });

  Map<String, dynamic> toJson() => {
        'datosRepartidor': {
          'numeroCedula': numeroCedula,
          'placaVehiculo': placaVehiculo,
          'tipoVehiculo': tipoVehiculo,
          'urlFotoCedula': urlFotoCedula,
          'urlFotoPerfil': urlFotoPerfil,
          'urlRecordPolicial': urlRecordPolicial,
          'urlLicencia': urlLicencia,
          'bancoNombre': bancoNombre,
          'numeroCuenta': numeroCuenta,
          'marcaVehiculo': marcaVehiculo,
          'zonaOperaciones': zonaOperaciones,
          'departamento': departamento,
        }
      };
}

class ReviewDeliveryRequestDto {
  final int estado;
  final String comentario;

  const ReviewDeliveryRequestDto({
    required this.estado,
    required this.comentario,
  });

  Map<String, dynamic> toJson() => {
        'estado': estado,
        'comentario': comentario,
      };
}

