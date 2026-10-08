import 'package:agrotrade_frontend/models/repartidor_models.dart';
import 'package:agrotrade_frontend/services/api_client.dart';
import 'package:agrotrade_frontend/models/api/backend_result.dart';

class RepartidorApiService {
  RepartidorApiService._();

  static final RepartidorApiService instance = RepartidorApiService._();

  /// Obtiene el estado de verificación del repartidor para el usuario autenticado
  /// GET /api/Repartidor/verificacion
  Future<RepartidorEstado> getEstadoVerificacion() async {
    final response = await ApiClient.instance.get(
      '/api/Repartidor/verificacion',
      authorized: true,
    );

    final result = BackendResult<dynamic>.fromJson(
      response.jsonBody ?? {},
      dataParser: (json) => json,
    );

    if (response.statusCode == 200 && result.isSuccess && result.data != null) {
      return RepartidorEstado.fromJson(result.data);
    } else {
      // En caso de error, asumimos que no tiene repartidor y no hay solicitud
      // Esto permite que el flujo continúe hacia onboarding
      return RepartidorEstado(
        tieneRepartidor: false,
        solicitudEstado: null,
        comentarioModerador: null,
      );
    }
  }
}