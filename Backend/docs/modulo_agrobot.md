# AgroBot - Asistente Inteligente con Gemini (`/api/AgroBot`)

Módulo de asistencia inteligente e interactiva de Meseta Verde alimentado por la API de Google Gemini (`gemini-3.6-flash`). Permite responder consultas contextuales especializadas por módulo de la plataforma, manteniendo el historial conversacional y garantizando aislamiento por usuario y alta resiliencia ante saturación de servicio.

---

## Arquitectura y Funcionamiento Interno

### 1. Funcionalidad en Memoria y Concurrencia
- **Almacenamiento**: La persistencia de las conversaciones y el historial activo se gestiona mediante la interfaz `IMemoryCache` de ASP.NET Core (`Microsoft.Extensions.Caching.Memory`) a través del servicio `GetPromptServices` (que implementa `IBotServices`).
- **Política de Expiración**: Se utiliza una expiración deslizante (`SlidingExpiration`) configurada a **24 horas** (`TimeSpan.FromDays(1)`). Cada interacción del usuario renueva la ventana de expiración en memoria.
- **Control de Concurrencia**: Para evitar condiciones de carrera (*race conditions*) en escenarios multihilo, las operaciones de lectura y escritura en la caché están sincronizadas mediante un monitor exclusivo (`lock (_lock)`).
- **Carga de Prompts Embebidos**: Al inicializarse el servicio (`traerPrompts()`), se escanea la carpeta física `Embebido/` buscando archivos de directrices de sistema (`*.md`). El contenido de estos archivos se carga en un diccionario en memoria (`Dictionary<string, string> _prompts`), evitando lecturas repetitivas al disco durante el procesamiento de peticiones.
- **Copias Defensivas**: Al recuperar el historial o las conversaciones, se generan copias profundas de las listas y objetos para garantizar que mutaciones externas no corrompan el estado almacenado en caché.

### 2. Asociación de Usuarios e Historial de Conversaciones
- **Extracción de Identidad**: Todos los endpoints están protegidos con `[Authorize]`. El backend extrae el identificador del usuario (`userId`) directamente del claim `ClaimTypes.NameIdentifier` presente en el token JWT. Por seguridad, no se recibe `userId` por parámetro ni por cuerpo.
- **Aislamiento en Caché**: La clave de acceso a los datos de cada usuario sigue el patrón:
  ```text
  history_of_{userId}
  ```
  Esto garantiza un estricto aislamiento de sesiones y privacidad entre usuarios.
- **Gestión por Conversación (`chatId`)**: Dentro del registro del usuario se almacena una colección de conversaciones (`List<BotConversation>`), cada una identificada por un `chatId`:
  - Si el cliente envía una petición sin `chatId` (o vacío), el handler genera automáticamente un identificador único global (`Guid.NewGuid().ToString()`) y crea una nueva conversación.
  - Si el cliente envía un `chatId` existente, se adjunta el nuevo mensaje a esa sesión.
- **Roles e Historial**: El historial (`List<History>`) preserva secuencialmente los intercambios distinguiendo entre:
  - `"user"`: Mensaje emitido por el cliente.
  - `"model"`: Respuesta generada por la IA de Gemini.

### 3. Consumo de la API de Gemini y Modelo 3.6 Flash
- **SDK Oficial**: Se utiliza la librería oficial de Google GenAI (`Google.GenAI` y `Google.GenAI.Types`).
- **Configuración y Clave de Acceso**:
  - La clave de API se obtiene desde la configuración `Gemini:ApiKey` en `appsettings.json` o desde la variable de entorno `GEMINI_API_KEY`.
  - El modelo por defecto configurado es `gemini-3.6-flash` (configurable mediante `Gemini:Model`).
- **Inyección de Instrucciones de Sistema (`SystemInstruction`)**:
  - Según el valor del campo `Module` proporcionado en el DTO, se extrae el System Prompt precargado desde `Embebido/{Module}.md`.
  - Se asigna en la configuración de la petición (`GenerateContentConfig.SystemInstruction`), orientando las respuestas de Gemini al dominio funcional requerido (e.g., inventario, logística, catálogos, pedidos).
- **Parámetros del Modelo**:
  - `Temperature = 0.3f`: Se establece una temperatura baja para favorecer respuestas consistentes, deterministas, precisas y alineadas a los datos de la plataforma.
- **Conversión de Contexto**: El historial previo registrado para el chat más el mensaje actual se transforman a la estructura nativa `List<Content>`, con roles asignados y partes de texto (`Part { Text = ... }`), dotando a Gemini de memoria conversacional continua.

### 4. Manejo de Resiliencia y Reintentos
- **Estrategia ante Sobrecarga**: Las llamadas a la IA pueden experimentar picos de saturación (`Google.GenAI.ServerError`).
- **Mecanismo de Reintento en Bucle**:
  - Número máximo de reintentos: **3 intentos** (`maxIntentos = 3`).
  - Pausa no bloqueante entre fallos: **10 segundos** (`await Task.Delay(10000, cancellationToken)`).
- **Tratamiento de Errores**: Si tras los 3 intentos persiste el error de servidor, el handler interrumpe la ejecución de forma controlada y retorna un resultado HTTP 503 (`Result<BotResponse>.Failure(503, "El Servicio de IA está saturado temporalmente, intenta de nuevo más tarde.")`).

---

### **Headers**

- `Authorization: Bearer <token>`

Todos los endpoints de este módulo requieren JWT. El usuario se obtiene del claim `NameIdentifier`; por seguridad no se recibe `userId` ni por ruta ni por cuerpo.

---

### Enviar mensaje / consulta a AgroBot

- **Método**: POST
- **Ruta**: `/api/AgroBot/push-request`
- **Descripción**: Envía un mensaje o consulta al asistente inteligente para un módulo funcional específico. Recupera el historial previo de la conversación (si se suministra `chatId`), añade el prompt de sistema del módulo, consulta a Gemini (`gemini-3.6-flash`) con reintentos automáticos y almacena tanto la pregunta como la respuesta en memoria para dar continuidad al chat.
- **Cuerpo (BotRequest)**:
  - `chatId` (string, opcional): Identificador de la conversación. Si no se envía o está vacío, el servidor genera un nuevo GUID.
  - `message` (string, requerido): Mensaje, pregunta o comando del usuario.
  - `module` (string, requerido): Nombre del módulo temático (debe coincidir con uno de los prompts del sistema en `Embebido`).

- **Respuesta**: `Result<BotResponse>`
  - Success (200): Consulta procesada y respuesta generada correctamente. Retorna `ChatId` y el texto de `Response`.
  - Failure (400): El mensaje o el módulo son nulos o están vacíos.
  - Failure (401): JWT ausente, expirado o sin claim `NameIdentifier` válido.
  - Failure (503): El servicio de IA de Gemini se encuentra temporalmente saturado tras agotar los 3 intentos.

---

### Obtener conversaciones del usuario

- **Método**: GET
- **Ruta**: `/api/AgroBot/conversations`
- **Descripción**: Obtiene la lista completa de todas las conversaciones activas iniciadas por el usuario autenticado que se encuentran almacenadas en memoria caché.
- **Cuerpo**: No requiere.

- **Respuesta**: `Result<List<BotConversation>>`
  - Success (200): Lista de conversaciones del usuario; si no tiene conversaciones retorna una lista vacía.
  - Failure (401): JWT ausente, inválido o sin claim `NameIdentifier` válido.

---

### Obtener historial de una conversación

- **Método**: GET
- **Ruta**: `/api/AgroBot/conversations/{chatId}`
- **Descripción**: Obtiene la secuencia cronológica de mensajes intercambiados (usuario y modelo) dentro de una conversación específica perteneciente al usuario autenticado.
- **Parámetros**:
  - `chatId` (string, ruta, requerido): Identificador de la conversación a consultar.
- **Cuerpo**: No requiere.

- **Respuesta**: `Result<List<History>>`
  - Success (200): Historial de mensajes de la conversación; lista vacía si el `chatId` no existe para el usuario.
  - Failure (400): El identificador de chat es nulo o vacío.
  - Failure (401): JWT ausente, inválido o sin claim `NameIdentifier` válido.

---

### Módulos Temáticos Disponibles (`Module`)

El parámetro `module` en `BotRequest` selecciona el System Prompt específico cargado en memoria desde los archivos `.md` de la carpeta `Embebido/`. Los módulos soportados son:

| Módulo (`module`) | Archivo Prompt | Descripción |
| :--- | :--- | :--- |
| `cadena_suministros` | `cadena_suministros.md` | Trazabilidad, flujo de productos, intermediarios y cadena de valor agrícola. |
| `catalogo_productos` | `catalogo_productos.md` | Búsqueda, filtrado, detalles y disponibilidad de productos del campo. |
| `categorias_productos` | `categorias_productos.md` | Organización, taxonomía y clasificación de productos agropecuarios. |
| `chat_integrado` | `chat_integrado.md` | Asistencia en la comunicación directa entre compradores, productores y repartidores. |
| `gestion_proveedores` | `gestion_proveedores.md` | Información de productores, cooperativas, certificaciones y verificación de fincas. |
| `impacto_social` | `impacto_social.md` | Indicadores de sostenibilidad, comercio justo y beneficio a comunidades locales. |
| `inventario_y_stock` | `inventario_y_stock.md` | Control de existencias, almacenes, cosechas y disponibilidad de lote. |
| `logistica_y_entregas` | `logistica_y_entregas.md` | Rutas de entrega, asignación de pedidos, zonas de cobertura y estado de despachos. |
| `pedidos_compras` | `pedidos_compras.md` | Creación, estados, procesamiento de pagos y seguimiento de órdenes. |
| `suscripciones` | `suscripciones.md` | Planes periódicos de canastas agroecológicas, entregas recurrentes y membresías. |
| `usuarios` | `usuarios.md` | Gestión de perfiles, roles (Cliente, Productor, Repartidor, Admin) y seguridad. |
| `valoraciones` | `valoraciones.md` | Calificaciones, reseñas y reputación de productos y proveedores. |

---

### Modelos

#### BotRequest

- `string chatId`
- `string Message`
- `string Module`

#### BotResponse

- `string ChatId`
- `string Response`

#### BotConversation

- `string UserId`
- `string ChatId`
- `List<History> History`

#### History

- `string Role`
- `string Content`

#### Result

- `int StatusCode`
- `string Message`
- `bool IsSuccess`

#### Result<T>

- `int StatusCode`
- `T Data`
- `string Message`
- `bool IsSuccess`
