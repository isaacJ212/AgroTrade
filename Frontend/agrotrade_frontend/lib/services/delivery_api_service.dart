import '../models/api/backend_result.dart';
import '../models/api/delivery_models.dart';
import '../models/api/json_helpers.dart';
import '../routes/delivery_routes.dart';
import 'api_client.dart';

class DeliveryApiService {
  DeliveryApiService._();

  static final DeliveryApiService instance = DeliveryApiService._();

  // Mock temporal para flujo de entrega (CRUD temporal)
  final List<PendingDeliveryNotificationDto> _mockPending = [];
  final List<PendingDeliveryNotificationDto> _mockAccepted = [];
  
  bool _mockInitialized = false;

  void _initMock() {
    if (_mockInitialized) return;
    _mockInitialized = true;
    _mockPending.addAll([
      PendingDeliveryNotificationDto(
        pedidoId: 1054,
        zonaEntrega: 'Residencial Los Robles, Casa 24',
        totalPedido: 45.00,
        fechaCreacion: DateTime.now(),
      ),
      PendingDeliveryNotificationDto(
        pedidoId: 1055,
        zonaEntrega: 'Centro Comercial Metrocentro',
        totalPedido: 120.50,
        fechaCreacion: DateTime.now(),
      )
    ]);
  }

  Future<List<PendingDeliveryNotificationDto>> getPendingDeliveries() async {
    try {
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
    } catch (e) {
      _initMock();
      return _mockPending.toList();
    }
  }

  Future<Map<String, dynamic>?> getDetalleEntrega(int pedidoId) async {
    // Intentar endpoint de detalle si existe en el futuro
    // Por ahora retorna null ya que el endpoint no existe
    return null;
  }

  Future<void> acceptDelivery(int pedidoId) async {
    try {
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
    } catch (e) {
      // Mock Fallback
      _initMock();
      final index = _mockPending.indexWhere((element) => element.pedidoId == pedidoId);
      if (index != -1) {
        final item = _mockPending.removeAt(index);
        _mockAccepted.add(item);
      }
      return;
    }
  }

  Future<void> confirmarEntrega(int pedidoId, String nota) async {
    // Simulamos un endpoint que no existe actualmente en el api client
    await Future.delayed(const Duration(milliseconds: 500));
    _initMock();
    final index = _mockAccepted.indexWhere((element) => element.pedidoId == pedidoId);
    if (index != -1) {
      _mockAccepted.removeAt(index);
    }
    // Si la queremos dejar como completada en una lista _mockCompleted podríamos hacerlo.
    return;
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
