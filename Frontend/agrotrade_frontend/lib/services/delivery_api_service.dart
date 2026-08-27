import '../models/api/backend_result.dart';
import '../models/api/delivery_models.dart';
import '../models/api/json_helpers.dart';
import '../routes/delivery_routes.dart';
import 'api_client.dart';

class DeliveryApiService {
  DeliveryApiService._();

  static final DeliveryApiService instance = DeliveryApiService._();

  Future<List<PendingDeliveryNotificationDto>> getPendingDeliveries() async {
    final response = await ApiClient.instance.get(
      DeliveryRoutes.pendingDeliveries,
      authorized: true,
    );

    final json = response.jsonBody ?? const <String, dynamic>{};
    final result = BackendResult<List<PendingDeliveryNotificationDto>>.fromJson(
      json,
      dataParser: (data) {
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map(PendingDeliveryNotificationDto.fromJson)
              .toList();
        }
        return <PendingDeliveryNotificationDto>[];
      },
    );

    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudieron obtener las entregas pendientes.',
      );
    }

    return result.data ?? <PendingDeliveryNotificationDto>[];
  }

  Future<void> acceptDelivery(int pedidoId) async {
    final response = await ApiClient.instance.post(
      DeliveryRoutes.acceptDelivery(pedidoId),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      throw ApiException(response.statusCode, 'No se pudo aceptar la entrega.');
    }

    final result = BackendResult<dynamic>.fromJson(
      response.jsonBody!,
      dataParser: (data) => data,
    );

    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo aceptar la entrega.',
      );
    }
  }

  Future<void> createDeliveryRequest(CreateDeliveryRequestDto dto) async {
    final response = await ApiClient.instance.post(
      DeliveryRoutes.deliveryJobRequests,
      body: dto.toJson(),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      throw ApiException(
        response.statusCode,
        'No se pudo crear la solicitud de repartidor.',
      );
    }

    final result = BackendResult<dynamic>.fromJson(
      response.jsonBody!,
      dataParser: (data) => data,
    );

    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo crear la solicitud de repartidor.',
      );
    }
  }

  Future<void> reviewDeliveryRequest({
    required int estado,
    required String comentario,
  }) async {
    final response = await ApiClient.instance.patch(
      DeliveryRoutes.reviewDelivery,
      body: ReviewDeliveryRequestDto(
        estado: estado,
        comentario: comentario,
      ).toJson(),
      authorized: true,
    );

    if (response.jsonBody == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }
      throw ApiException(
        response.statusCode,
        'No se pudo revisar la solicitud.',
      );
    }

    final result = BackendResult<dynamic>.fromJson(
      response.jsonBody!,
      dataParser: (data) => data,
    );

    if (!result.isSuccess) {
      throw ApiException(
        response.statusCode,
        result.message.isNotEmpty
            ? result.message
            : 'No se pudo revisar la solicitud.',
      );
    }
  }
}
