# Carrito, Checkout y Entregas (`/api`)

### **Headers**

- `Authorization: Bearer <token>`

Todos los endpoints de este documento requieren JWT. El usuario se obtiene del claim `NameIdentifier`; por seguridad no se recibe `userId` ni por ruta ni por cuerpo.

### Agregar producto al carrito

- **Método**: POST
- **Ruta**: `/api/carrito/add`
- **Descripción**: Agrega un producto al carrito del usuario autenticado. Si ya existe, suma la cantidad solicitada.
- **Cuerpo (AddCartItemRequestDto)**:
  - `productId` (int, requerido): ID del producto.
  - `quantity` (int, requerido): cantidad a agregar; debe ser mayor que cero.

- **Respuesta**: `Result`
  - Success (200): producto agregado al carrito.
  - Failure (400): usuario, producto o cantidad inválidos.
  - Failure (401): JWT ausente, inválido o sin `NameIdentifier` válido.

### Vaciar carrito

- **Método**: DELETE
- **Ruta**: `/api/carrito/clear`
- **Descripción**: Elimina todos los productos del carrito del usuario autenticado.
- **Cuerpo**: no requiere.

- **Respuesta**: `Result`
  - Success (200): carrito vaciado correctamente.
  - Failure (401): JWT ausente, inválido o sin `NameIdentifier` válido.

### Procesar checkout y distribuir pagos

- **Método**: POST
- **Ruta**: `/api/pedido/checkout`
- **Descripción**: Procesa el carrito del usuario autenticado. Valida inventario, aplica descuentos, crea el pedido, descuenta stock y genera una transferencia ACH simulada por proveedor: 12% para Meseta Verde y 88% para el productor. También registra una notificación in-app para cada repartidor disponible cuya `ZonaOperaciones` coincide exactamente con la `DireccionBase` del cliente.
- **Cuerpo (CheckoutRequestDto)**:
  - `metodoPago` (string, requerido): método de pago utilizado.

- **Respuesta**: `Result<CheckoutResponseDto>`
  - Success (201): checkout procesado, pedido creado y transferencias generadas.
  - Failure (400): método de pago inválido, carrito vacío o cantidades inválidas.
  - Failure (401): JWT ausente, inválido o sin `NameIdentifier` válido.
  - Failure (404): cliente o producto no encontrado.
  - Failure (409): producto no disponible o stock insuficiente.
  - Failure (500): no fue posible completar la transacción.

### Obtener ofertas de entrega pendientes

- **Método**: GET
- **Ruta**: `/api/repartidor/entregas/pendientes`
- **Descripción**: Obtiene las notificaciones de entrega pendientes del repartidor autenticado. Solo retorna ofertas creadas para ese usuario repartidor.
- **Cuerpo**: no requiere.

- **Respuesta**: `Result<List<NotificacionEntregaDto>>`
  - Success (200): lista de ofertas pendientes; puede ser vacía.
  - Failure (400): identificador del repartidor inválido.
  - Failure (401): JWT ausente, inválido o sin `NameIdentifier` válido.

### Aceptar una entrega

- **Método**: POST
- **Ruta**: `/api/pedido/{pedidoId}/entrega/aceptar`
- **Descripción**: El repartidor autenticado acepta su oferta pendiente. Crea `LogisticaEntrega`, asigna el repartidor al pedido, cambia su estado a `EN ENTREGA` y cierra las demás ofertas del mismo pedido. Solo puede existir una asignación logística por pedido.
- **Parámetros**:
  - `pedidoId` (int, ruta, requerido): ID del pedido a aceptar.

- **Respuesta**: `Result`
  - Success (200): entrega aceptada y asignada.
  - Failure (400): pedido o repartidor inválido.
  - Failure (401): JWT ausente, inválido o sin `NameIdentifier` válido.
  - Failure (404): no existe una oferta pendiente para ese repartidor y pedido.
  - Failure (409): el repartidor no está disponible o el pedido fue aceptado por otro repartidor.

### Modelos

#### AddCartItemRequestDto

- `int ProductId`
- `int Quantity`

#### CheckoutRequestDto

- `string MetodoPago`

#### CheckoutResponseDto

- `int PedidoId`
- `decimal Total`
- `decimal ComisionPlataforma`
- `decimal TotalProductores`
- `string MetodoPago`
- `int RepartidoresNotificados`
- `List<TransferenciaCheckoutDto> Transferencias`

#### TransferenciaCheckoutDto

- `string IdTransferencia`
- `string Proveedor`
- `decimal MontoEnviado`
- `string Estado`

#### NotificacionEntregaDto

- `int PedidoId`
- `string ZonaEntrega`
- `decimal TotalPedido`
- `DateTime FechaCreacion`

#### Result

- `int StatusCode`
- `string Message`
- `bool IsSuccess`

#### Result<T>

- `int StatusCode`
- `T Data`
- `string Message`
- `bool IsSuccess`
