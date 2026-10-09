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
      // Para la demo, simularemos que el repartidor ya está aprobado
      return RepartidorEstado(
        tieneRepartidor: true,
        solicitudEstado: '1', // Aprobado
        comentarioModerador: 'Aprobado para la demostración',
      );
    }
  }
}