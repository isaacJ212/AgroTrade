# Contexto de Desarrollo - Meseta Verde (Corrección de Bugs y Vinculación)

Este documento resume las correcciones de bugs recientes y la integración de funcionalidades en el flujo Productor-Cliente de la aplicación, realizadas con foco principal en la sincronización de estados, inicialización de chat y manejo de datos del usuario logueado.

## 1. Lado del Productor (Backend & Frontend)

### Bug: Confirmación infinita de pedidos
- **Problema:** En el frontend, el productor podía confirmar el mismo pedido varias veces, y el estado parecía estar bloqueado en "Pendiente" al recargar. Adicionalmente, explotaba con un "StateError" si un producto del pedido no existía localmente en caché.
- **Soluciones:**
  - **Frontend (`productor_store.dart`):** Se ajustó la validación estricta de inventario `if (item != null && ...)` para que no falle ni crashee la app si el producto ya no está en la memoria temporal del productor.
  - **Backend (`PatchPedidoEstadoCommand.cs`):** El repositorio actualizaba la entidad en la RAM pero no ejecutaba `SaveChangesAsync()`. Se inyectó `IUnitofWork` y se agregó `await unitOfWork.SaveChangesAsync(ct);`, lo que garantiza que los cambios ("Preparando", "Listo") persistan exitosamente en la base de datos MySQL/SQLServer.

## 2. Lado del Cliente (Backend & Frontend)

### Bug: Error al cargar el chat ("Error 500")
- **Problema:** Cuando el cliente presionaba "Enviar Mensaje" en la ruta de seguimiento de un pedido, el frontend enviaba por defecto el `idReceptor: 13`. Si el pedido en realidad pertenecía a otro productor (o si era un pedido mock), la llave foránea explotaba en el backend, devolviendo un error 500 y causando que la pantalla colapsara.
- **Soluciones:**
  - **Backend (`GetPedidoByIdCommand.cs` & `PedidoClienteDto.cs`):** Se expuso la propiedad `IdProveedor` dentro del `DetallePedidoDto` mapeándola directo desde el inventario.
  - **Frontend (`seguimientoPedido.dart`):** Ahora la pantalla extrae dinámicamente el `IdProveedor` desde los detalles del pedido descargado y lo envía al API como el `idReceptor` correcto. 
  - **Frontend (`chat_api_service.dart`):** Se agregó un entorno de gracia (Fallback) que devuelve una conversación "mock" temporal si el backend falla o estás offline, evitando los pantallazos rojos (crashes).

### Bug: Timeline del pedido desincronizado
- **Problema:** El API retornaba estados como `"Preparando"` o `"Listo"`, pero el Switch del cliente (`seguimientoPedido.dart`) solo contemplaba `"PENDIENTE"`, `"EN_CAMINO"` y `"ENTREGADO"`. Como resultado, los pedidos en preparación se devolvían a la casilla inicial por defecto en el Timeline UI.
- **Solución:** Se corrigió el mapping del `switch(estadoEnvio)` en la interfaz del cliente para hacer match perfecto con los estados dictados por el backend.

### Flujo de Usuario y UI (Checkout y Perfiles)
- **Problema:** Direcciones "quemadas" (hardcoded) en entregas y falta de los datos del usuario logueado en su perfil.
- **Solución:** Se editó `entrega.dart`, `profile.dart` y `editarPerfil.dart` para consumir directamente los campos (`direccion`, `nombres`, `apellidos`, etc.) almacenados en la sesión o recuperados vía el `ConsumerApiService`/`UsersApiService`.

## Conclusión y Siguientes Pasos
Se logró conectar satisfactoriamente el *Feedback Loop* entre el estado alterado por el Productor y la respuesta visual esperada del Cliente en su Tracker y Chat en tiempo real, garantizando la consistencia de la base de datos relacional.
