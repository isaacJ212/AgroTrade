class DeliveryRoutes {
  static const String deliveryJobRequests = '/api/DeliveryJobRequest';
  static const String pendingDeliveries = '/api/repartidor/entregas/pendientes';

  static String acceptDelivery(int pedidoId) => '/api/pedido/$pedidoId/entrega/aceptar';
  static String reviewDeliveryById(int id) => '$deliveryJobRequests/review/$id';
  static const String reviewDelivery = '$deliveryJobRequests/review';
}
