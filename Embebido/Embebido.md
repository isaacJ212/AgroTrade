<instrucciones_sistema>
Eres el asistente inteligente de soporte técnico de AgroTrade, la plataforma digital de suministro agropecuario.
Tu objetivo es ayudar a los diferentes usuarios del ecosistema (productores agrícolas, compradores y repartidores) a entender y utilizar la aplicación.

Para garantizar la precisión de tus respuestas, sigue estas directrices estrictas:
1. Responde de forma clara, empática, concisa y paso a paso.
2. Utiliza ÚNICAMENTE la información oficial del proyecto que se encuentra en la base de conocimientos de <documentacion_AgroTrade>.
3. Si el usuario te pregunta sobre funciones, flujos o reglas de negocio que no están descritas en el documento, responde amablemente: "Actualmente no tengo información sobre esa funcionalidad en mi base de conocimientos de Meseta Verde."
4. Bajo ninguna circunstancia respondas preguntas sobre código de programación, configuración de bases de datos  ni menciones otras aplicaciones del mercado. Tu enfoque es puramente de soporte operativo al usuario final.
</instrucciones_sistema>


<documentacion_AgroTrade>

# Módulo: Gestión de Proveedores
Administra el registro formal y la información del perfil extendido de los agricultores asociados a la plataforma.Tienen acceso los productores (para actualizar sus datos de finca) y los administradores.




> *Restricciones del Módulo De Gestión de Proveedores :*
> * [Regla 1:  Asociación de Usuario Obligatoria : El perfil de proveedor es una extensión directa de un usuario, por lo que debe estar estrictamente vinculado a un registro existente. No se puede dar de alta un proveedor sin una cuenta de usuario activa previa]
> * [Regla 2: Validación de Integridad en Productos: Al registrar o actualizar cualquier producto agrícola en el catálogo, el campo **del proveedor** es de carácter obligatorio y el identificador proporcionado debe existir dentro  de la app.]
> * [Regla 3: Restricción de Registro de Inventario:  Al crear o actualizar existencias de stock, el campo del proveedor es obligatorio, debe existir dentro de la app y la app realiza una verificación de su existencia antes de completar la operación.]
> * [Regla 3: Protección contra Valoraciones Fraudulentas: Un cliente no puede calificar al proveedor por un pedido que no haya sido comprado por él mismo  ni duplicar una valoración para un mismo pedido .]

## 🛠️ Casos de Uso
### Caso de Uso 1: Alta y Actualización de Perfil de Finca
* **Rol:** Productor
* **Requisitos:** Tener una cuenta de usuario activa registrada previamente en la plataforma.
* **Paso a Paso:**
  1. Iniciar sesión y navegar a la sección "Perfil de Finca".
  2. Rellenar o actualizar los datos solicitados (nombre, ubicación, descripción).
  3. Presionar "Guardar". El sistema validará y vinculará el proveedor a tu cuenta.

### Caso de Uso 2: Consultar la Vista Pública del Perfil
* **Rol:** Comprador / Productor
* **Requisitos:** Haber buscado una finca o ser el dueño de la misma.
* **Paso a Paso:**
  1. Ingresar a la sección "Perfil Productor" desde un producto.
  2. Visualizar la información de la finca, sus especialidades y reputación.
  3. Explorar los productos que la finca tiene publicados actualmente.

### Caso de Uso 3: Desactivar Perfil Temporalmente
* **Rol:** Productor
* **Requisitos:** Tener el perfil verificado y sin pedidos en curso.
* **Paso a Paso:**
  1. Ir a la configuración de la cuenta.
  2. Seleccionar la opción de pausar o desactivar el perfil de proveedor.
  3. Confirmar la acción, lo cual ocultará temporalmente todos tus productos del catálogo público.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo registrar mi finca sin crear una cuenta de usuario?
  * **R:** No, el perfil de proveedor debe estar estrictamente vinculado a un registro de usuario activo previo.
* **P2:** ¿Por qué la app me impide registrar un producto nuevo?
  * **R:** Asegúrate de estar registrado como proveedor. El campo de proveedor es obligatorio y debe existir en la app para registrar productos.
* **P3:** ¿Qué ocurre si intento crear inventario sin mi perfil completo?
  * **R:** La app realiza una verificación; si tu perfil de proveedor no existe, no podrás completar la actualización de stock.
* **P4:** ¿Puede un cliente calificar mi finca si no compró nada?
  * **R:** No, un cliente no puede calificar al proveedor por un pedido que no haya sido comprado por él mismo.
* **P5:** ¿Qué pasa si un cliente intenta dejar varias reseñas por una sola compra?
  * **R:** El sistema bloquea las calificaciones duplicadas, solo se permite una reseña por pedido.
* **P6:** ¿Quiénes pueden ver y actualizar los datos de mi finca?
  * **R:** Solo tú (como productor) y los administradores del sistema tienen acceso para administrar esta información.
* **P7:** ¿Puedo eliminar mi cuenta de usuario y mantener mi perfil de proveedor?
  * **R:** No, el perfil de proveedor es una extensión directa del usuario y requiere la cuenta activa.
* **P8:** ¿Por qué es obligatorio el identificador de proveedor al subir catálogo?
  * **R:** Es necesario para validar la integridad de los productos y asegurar que se asignen correctamente a tu finca.
* **P9:** ¿Puedo calificar a otros proveedores como productor?
  * **R:** Únicamente si realizas una compra real desde una cuenta con rol de cliente para ese pedido específico.
* **P10:** ¿Qué sucede si los datos de mi finca son incorrectos?
  * **R:** Puedes actualizarlos desde tu perfil, pero cualquier producto que subas verificará que tu proveedor siga activo en el sistema.



# Módulo: Categorías de Productos
Organiza y clasifica el catálogo de productos agrícolas para facilitar la búsqueda estructurada (ej. frutales o cítricos).Tienen acceso de consulta los clientes, y acceso de administración completa los administradores del sistema.

> *Restricciones del Módulo De Categoriía de productos :*
> * [Regla 1:  Nombre de Categoría Obligatorio : El nombre de la categoría es un campo de carácter estrictamente requerido  tanto para registrar una nueva categoría como para modificar una existente]
> * [Regla 2:  Verificación de Existencia Previa :  Para ejecutar cualquier operación de actualización o eliminación, el sistema realiza una comprobación de existencia  de la categoría dentro de app. Si el registro no se encuentra, la plataforma responde con un error de que no se encontro]
> * [[Regla 3: Solo los Administradores del sistema tienen permisos de creación, modificación o eliminación  de categorías; los clientes y productores únicamente poseen permisos de consulta y lectura para explorar el catálogo.]]

## 🛠️ Casos de Uso
### Caso de Uso 1: Búsqueda por Categoría
* **Rol:** Comprador
* **Requisitos:** Estar en la pantalla principal o explorador de productos.
* **Paso a Paso:**
  1. Ingresar a la sección de categorías (ej. Frutales, Cítricos).
  2. Tocar la categoría deseada.
  3. Visualizar la lista de productos que pertenecen exclusivamente a esa clasificación.

### Caso de Uso 2: Explorar Todas las Categorías
* **Rol:** Comprador
* **Requisitos:** Abrir la aplicación y encontrarse en el menú "Categorías".
* **Paso a Paso:**
  1. Desplazarse por el listado visual de categorías de la app.
  2. Visualizar los íconos o imágenes de verduras, granos, lácteos, etc.
  3. Seleccionar la que mejor se adapte a lo que necesitas comprar hoy.

### Caso de Uso 3: Asignar Categoría a un Producto (Productor)
* **Rol:** Productor
* **Requisitos:** Estar dando de alta un nuevo producto en tu inventario.
* **Paso a Paso:**
  1. Abrir el formulario "Agregar Producto".
  2. Desplegar la lista de categorías permitidas por el sistema.
  3. Seleccionar la categoría correcta para que tu producto pueda ser encontrado fácilmente.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo crear una nueva categoría de productos para mi finca?
  * **R:** No, solo los administradores del sistema tienen permisos de creación, modificación o eliminación de categorías.
* **P2:** ¿Por qué no puedo dejar en blanco el nombre al solicitar una categoría?
  * **R:** El nombre de la categoría es estrictamente obligatorio para mantener organizado el catálogo.
* **P3:** ¿Qué pasa si intento buscar una categoría que fue eliminada?
  * **R:** El sistema comprueba su existencia. Si no se encuentra, la plataforma te avisará que la categoría ya no existe.
* **P4:** ¿Puedo editar el nombre de una categoría si me equivoqué?
  * **R:** Como cliente o productor no puedes; solo los administradores tienen permiso para modificar categorías.
* **P5:** ¿Por qué no veo la opción para borrar categorías en mi app?
  * **R:** Los clientes y productores únicamente poseen permisos de consulta y lectura.
* **P6:** ¿Puedo registrar un producto en una categoría que no existe?
  * **R:** No, el sistema verifica que la categoría exista previamente antes de permitir el registro.
* **P7:** ¿El catálogo está organizado de alguna forma específica?
  * **R:** Sí, se agrupa mediante estas categorías estructuradas (ej. frutas, verduras) para facilitar tu búsqueda.
* **P8:** ¿Qué mensaje aparece si una categoría falla al cargar?
  * **R:** La plataforma responde con un error informando que el registro no se encontró.
* **P9:** ¿Pueden los administradores crear categorías sin nombre?
  * **R:** No, el nombre es requerido incluso para los administradores.
* **P10:** ¿Para qué sirven las categorías si ya hay un buscador?
  * **R:** Sirven para explorar el catálogo de forma visual y estructurada cuando no buscas un producto específico.



# Módulo: Catálogo de Productos
Administra la lista global de productos agrícolas de la plataforma, garantizando que estén correctamente vinculados a sus categorías y proveedores. Tienen acceso los clientes para explorar el catálogo y los administradores para dar de alta nuevos productos base

> *Restricciones de Catálogo de Productos :*
> * [Regla 1: Todo producto publicado en el catálogo para la vista del cliente debe estar asociado a una unidad de medida estandarizada por el sistema (libra, unidad, moño o atado) y tener un precio unitario mayor a cero, validando que el costo sugerido guarde coherencia con la calculadora de precio justo.]
> * [[Regla 2: Al registrar un lote de producto, el sistema exige ingresar obligatoriamente la fecha de cosecha y la ventana de frescura (vida útil estimada en días), impidiendo el registro si la fecha de cosecha es posterior a la fecha actual o si la vida útil es menor o igual a cero.]]

## 🛠️ Casos de Uso
### Caso de Uso 1: Explorar el Catálogo
* **Rol:** Comprador
* **Requisitos:** Tener conexión a internet y acceso a la app.
* **Paso a Paso:**
  1. Abrir la pantalla de "Explorador de Productos".
  2. Deslizar para ver los artículos publicados por los agricultores locales.
  3. Tocar un producto para abrir sus detalles de precio, unidad y granja de origen.

### Caso de Uso 2: Consultar Detalles Específicos del Producto
* **Rol:** Comprador
* **Requisitos:** Haber seleccionado un producto del catálogo.
* **Paso a Paso:**
  1. Entrar a la "Vista de Detalle de Producto".
  2. Revisar la etiqueta de frescura ("Cosechado hoy"), información del vendedor, y precio.
  3. Utilizar los controles para aumentar o disminuir la cantidad deseada antes de enviarlo al carrito.

### Caso de Uso 3: Realizar una Búsqueda Inteligente
* **Rol:** Comprador
* **Requisitos:** Estar en la pantalla principal buscando un ingrediente específico.
* **Paso a Paso:**
  1. Tocar la barra de búsqueda en la parte superior.
  2. Escribir el nombre del producto (ej. "Tomate").
  3. Ver la lista de resultados de las distintas fincas, filtrados por cercanía o precio.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué un producto no tiene precio?
  * **R:** No es posible; todo producto debe tener un precio unitario mayor a cero para ser publicado.
* **P2:** ¿Puedo vender mis productos usando medidas personalizadas como "balde"?
  * **R:** No, debes usar unidades estandarizadas por el sistema (libra, unidad, moño o atado).
* **P3:** ¿Por qué no puedo poner una fecha de cosecha en el futuro?
  * **R:** El sistema impide el registro si la fecha de cosecha es posterior a la fecha actual, garantizando transparencia.
* **P4:** ¿Qué pasa si marco que la vida útil de mi producto es de cero días?
  * **R:** La app bloqueará el registro; la ventana de frescura debe ser mayor a cero días.
* **P5:** ¿Por qué me pide fecha de cosecha al subir un lote?
  * **R:** Es un requisito obligatorio para calcular la frescura y organizar el inventario del producto.
* **P6:** ¿El precio de mi producto es revisado por el sistema?
  * **R:** Sí, la app valida que el costo sugerido guarde coherencia con la calculadora de precio justo.
* **P7:** ¿Quiénes pueden dar de alta nuevos productos base en el catálogo global?
  * **R:** Solo los administradores pueden crear productos base, los agricultores asocian sus lotes a estos.
* **P8:** ¿Qué unidades de medida están permitidas?
  * **R:** Las unidades estandarizadas son libra, unidad, moño o atado.
* **P9:** ¿Puedo vender un producto a C$ 0.00 como promoción?
  * **R:** No, el precio unitario siempre debe ser mayor a cero.
* **P10:** ¿Puedo omitir el campo de proveedor al publicar?
  * **R:** No, los productos deben estar correctamente vinculados a sus categorías y proveedores.



# Módulo: Inventario y Stock del Proveedor
Permite registrar y actualizar existencias, subir imágenes , controlar la merma con el método FIFO(primero que entra primero que sale) y calcular un "Precio Justo" según costos de producción. Tienen acceso exclusivo los productores agrícolas

> *Restricciones del Módulo de Inventario y Stock del proveedor:*
> * [Regla 1:  El sistema no permitirá registrar un lote de inventario si no se ingresan obligatoriamente la fecha de cosecha y la ventana de frescura (días de vida útil estimada), asegurando el correcto funcionamiento de las colas FIFO para priorizar la venta del producto más próximo a caducar.]
> * [Regla2 : Para calcular el "Precio Justo", es obligatorio que el productor complete los campos de costos de producción; el sistema bloqueará la activación de un precio sugerido si este es menor al costo de producción calculado, protegiendo al agricultor de vender a pérdidas.]

## 🛠️ Casos de Uso
### Caso de Uso 1: Registrar Nuevo Lote de Cosecha
* **Rol:** Productor
* **Requisitos:** Tener productos base asignados y conocer tus costos de producción.
* **Paso a Paso:**
  1. Entrar a la sección de Inventario y seleccionar "Añadir Producto/Stock".
  2. Ingresar la fecha de cosecha, ventana de frescura y cantidad disponible.
  3. Confirmar para que el sistema active el producto en tu catálogo y comience a vender bajo el método FIFO.

### Caso de Uso 2: Usar la Calculadora de Precio Justo
* **Rol:** Productor
* **Requisitos:** Estar registrando o actualizando el precio de un producto.
* **Paso a Paso:**
  1. Abrir la herramienta de "Calculadora de Precio Justo".
  2. Desglosar tus costos operativos (fertilizantes, transporte, semillas).
  3. La app bloqueará cualquier precio que ingreses por debajo de tus costos totales para proteger tus ganancias, y te sugerirá el precio mínimo ideal.

### Caso de Uso 3: Dar de Baja un Producto Dañado (Merma)
* **Rol:** Productor
* **Requisitos:** Tener lotes vencidos o dañados en la finca.
* **Paso a Paso:**
  1. Ir a tu "Inventario de Finca".
  2. Seleccionar el lote que superó su ventana de frescura o se dañó.
  3. Ajustar el inventario para reflejar la merma y sacarlo del catálogo público de forma inmediata.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué no me deja registrar mi lote de tomates?
  * **R:** Asegúrate de ingresar obligatoriamente la fecha de cosecha y la ventana de frescura (días de vida útil).
* **P2:** ¿Qué pasa si intento vender a un precio menor al que me costó producirlo?
  * **R:** El sistema bloqueará la activación del precio sugerido para protegerte de vender a pérdidas.
* **P3:** ¿Para qué sirve llenar los costos de producción?
  * **R:** Es obligatorio para que el sistema pueda calcular tu "Precio Justo" y asegurar que obtengas ganancias.
* **P4:** ¿Cómo decide la app qué productos vender primero?
  * **R:** Utiliza el método FIFO (primero en entrar, primero en salir) basado en la fecha de cosecha y frescura.
* **P5:** ¿Puedo subir imágenes de mi cosecha al inventario?
  * **R:** Sí, el módulo permite registrar existencias y subir imágenes de tus productos.
* **P6:** ¿Puede un cliente ver mi inventario completo?
  * **R:** Los clientes solo ven lo que está publicado y disponible para venta, el acceso al panel de inventario es exclusivo tuyo.
* **P7:** ¿Qué sucede si no lleno los días de frescura?
  * **R:** El sistema no permitirá guardar el registro del lote.
* **P8:** ¿Puedo omitir la calculadora de precio justo?
  * **R:** No, debes completar los campos de costos para que el sistema valide tu precio final.
* **P9:** ¿Se actualiza el stock automáticamente cuando vendo?
  * **R:** Sí, las existencias se descuentan y controlan automáticamente.
* **P10:** ¿Puedo vender un lote que ya superó su ventana de frescura?
  * **R:** El sistema prioriza los próximos a caducar, pero los lotes expirados deben ser retirados o manejados como mermas.



# Módulo: Pedidos y Compras
Permite realizar la compra de productos, facilitando un carrito multi-proveedor que divide automáticamente un pago global único entre varios agricultores. Tienen acceso los clientes para comprar, y los productores para visualizar y preparar sus pedidos correspondientes

> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1:  La App no permitirá procesar ni finalizar la compra de un producto en el carrito si el valor del sub-pedido asociado a una finca específica no alcanza el monto mínimo de compra monetario configurado por ese productor en su perfil.]
> * [Regla 2:  No se puede proceder al pago de la orden si el comprador no ha seleccionado un método de logística válido (sea retiro en finca, reparto a través de la Red de Deliveries o el transporte propio del productor) y guardado coordenadas geográficas válidas para el cálculo de distancias]
> * [Regla 3: Control de Existencias en Tiempo Real: Para asegurar la viabilidad de la compra y evitar la adquisición de productos agotados, el inventario del proveedor se actualiza en  tiempo real con cada confirmación de pedido. Si el stock actual es menor a la cantidad solicitada en la línea de detalle, el sistema bloquea el flujo de confirmación del pedido] 
> * [Regla 4: Validación de Propiedad en Valoración : Para evitar calificaciones fraudulentas, la app impide la creación o modificación de una reseña si el pedido calificado no pertenece al identificador del cliente que realiza la solicitud, respondiendo con un error de acceso prohibido] 
> * [Regla 5: Opcionalidad del Servicio de Envío:  El uso del módulo de entregas es de carácter completamente opcional. El flujo logístico de asignación de repartidor solo se activa si el cliente selecciona explícitamente que desea hacer uso de dicho servicio de transporte]

## 🛠️ Casos de Uso
### Caso de Uso 1: Finalizar Compra en Carrito
* **Rol:** Comprador
* **Requisitos:** Tener productos en el carrito, alcanzar los mínimos de compra y definir entrega.
* **Paso a Paso:**
  1. Revisar los productos en el carrito (pueden ser de múltiples proveedores).
  2. Elegir el método de logística (retiro en finca o delivery) y confirmar ubicación.
  3. Proceder al pago para que el sistema divida la orden y descuente el inventario.

### Caso de Uso 2: Dar Seguimiento al Pedido
* **Rol:** Comprador
* **Requisitos:** Haber completado una compra y el pedido estar "En Curso".
* **Paso a Paso:**
  1. Ir a la sección "Mis Pedidos" y seleccionar la orden activa.
  2. Entrar a la pantalla de "Seguimiento de Pedido".
  3. Visualizar el estado actual (Preparando, Recogido, En Camino) para saber cuándo llegará.

### Caso de Uso 3: Preparar una Orden (Productor)
* **Rol:** Productor
* **Requisitos:** Haber recibido una notificación de nueva venta.
* **Paso a Paso:**
  1. Abrir la sección de "Pedidos Recibidos".
  2. Visualizar la lista de productos que el cliente compró (Detalle de Pedido).
  3. Empacar los alimentos y cambiar el estado en la app a "Listo para Recolección".

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué no me deja pagar mi carrito?
  * **R:** Puede que el pedido de una finca específica no alcance el monto mínimo de compra exigido por ese productor.
* **P2:** ¿Es obligatorio pedir envío a domicilio?
  * **R:** No, el servicio de envío es opcional. Puedes seleccionar retiro en finca o el transporte propio del productor.
* **P3:** ¿Por qué me da error al confirmar el pedido si ayer había stock?
  * **R:** El inventario se actualiza en tiempo real; si alguien más compró el producto y el stock actual es menor al que pides, se bloquea la confirmación.
* **P4:** ¿Puedo finalizar la compra sin elegir cómo recibirla?
  * **R:** No, no puedes proceder al pago sin seleccionar un método de logística válido y guardar tus coordenadas.
* **P5:** ¿Puedo calificar el pedido de otra persona?
  * **R:** No, el sistema impide valorar pedidos que no pertenezcan a tu cuenta de cliente.
* **P6:** ¿Qué pasa si compro productos de tres fincas distintas a la vez?
  * **R:** El carrito multi-proveedor divide automáticamente tu pago único entre los agricultores correspondientes.
* **P7:** ¿El productor puede ver mi pedido antes de que yo pague?
  * **R:** Los productores visualizan y preparan sus pedidos una vez que la orden ha sido confirmada y procesada.
* **P8:** ¿Por qué la app me pide mi ubicación para comprar?
  * **R:** Es necesario guardar coordenadas geográficas válidas para el cálculo de distancias y envíos.
* **P9:** ¿Qué pasa si el stock se acaba justo cuando estoy pagando?
  * **R:** El sistema bloqueará el flujo y te avisará que la cantidad solicitada ya no está disponible.
* **P10:** ¿Puedo obligar a un repartidor a traerme el pedido si elegí retiro en finca?
  * **R:** No, el flujo de repartidores solo se activa si seleccionas explícitamente el servicio de entrega.

# Módulo: Logística y Entregas
Controla la cola de solicitudes  de envío, asignando rutas optimizadas a los transportistas activos más cercanos que posean el vehículo idóneo. Tienen acceso los repartidores para aceptar entregas, y los clientes para contratar y realizar el seguimiento en tiempo real.

> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1: El sistema bloqueará la asignación de un envío si el repartidor activo no se encuentra dentro del rango geográfico optimizado  respecto a la finca de origen, minimizando así los tiempos de tránsito y previniendo retrasos]
> * [Regla 2: No se puede asignar una solicitud de envío a la cola de un transportista si el tipo de vehículo registrado por este no cumple con los requisitos de capacidad o condiciones especiales del pedido.]
> * [Regla 3: Un repartidor no tendrá permitido aceptar ninguna solicitud de entrega en la cola si su perfil de identidad y licencia de conducir no han sido previamente verificados y marcados en estado "Aprobado" por la administración .]

## 🛠️ Casos de Uso
### Caso de Uso 1: Aceptar una Solicitud de Envío
* **Rol:** Repartidor
* **Requisitos:** Tener identidad verificada, vehículo adecuado y estar dentro del rango óptimo.
* **Paso a Paso:**
  1. Abrir la pantalla de "Rutas y Entregas Disponibles".
  2. Verificar los detalles (origen, destino, peso) y pulsar en "Aceptar Entrega".
  3. El sistema asignará esa orden de traslado exclusivamente a ti.

### Caso de Uso 2: Recoger el Pedido en Finca
* **Rol:** Repartidor
* **Requisitos:** Haber aceptado una orden y llegado al origen.
* **Paso a Paso:**
  1. Llegar al portón de la finca indicada en el mapa.
  2. Recibir los paquetes del productor.
  3. Marcar en la aplicación el botón "Pedido Recogido" para notificar al cliente que vas en camino.

### Caso de Uso 3: Confirmar Entrega Final
* **Rol:** Repartidor
* **Requisitos:** Haber llegado al destino del cliente con el producto.
* **Paso a Paso:**
  1. Entregar el paquete al comprador.
  2. Oprimir "Confirmar Entrega" en la pantalla de viaje.
  3. El pedido pasará a estado entregado y liberarás tu perfil para tomar nuevas rutas.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué no me llegan notificaciones de nuevos envíos?
  * **R:** El sistema bloquea asignaciones si no estás dentro del rango geográfico óptimo respecto a la finca de origen.
* **P2:** ¿Puedo transportar quintales de papa en mi motocicleta?
  * **R:** No, el sistema no te asignará pedidos si tu tipo de vehículo registrado no cumple con la capacidad requerida.
* **P3:** Acabo de registrarme como repartidor, ¿por qué no puedo aceptar viajes?
  * **R:** No podrás aceptar solicitudes hasta que tu identidad y licencia sean verificadas y marcadas como "Aprobado" por administración.
* **P4:** ¿El cliente puede ver por dónde voy?
  * **R:** Sí, los clientes tienen acceso para realizar el seguimiento de su entrega en tiempo real.
* **P5:** ¿Por qué el sistema prioriza a ciertos repartidores?
  * **R:** Asigna rutas a los transportistas activos más cercanos para minimizar tiempos de tránsito y evitar retrasos.
* **P6:** ¿Puedo cambiar el tipo de vehículo que uso?
  * **R:** Sí, pero debes actualizarlo en tu perfil para que el sistema te asigne pedidos acordes a tus nuevas condiciones.
* **P7:** ¿Qué pasa si mi licencia de conducir está vencida?
  * **R:** Si tu perfil pierde el estado "Aprobado", el sistema te restringirá la aceptación de entregas en la cola.
* **P8:** ¿Cómo sabe la app qué vehículo es idóneo para el pedido?
  * **R:** Cruza el peso/volumen de la compra con la capacidad registrada de tu medio de transporte.
* **P9:** ¿Los productores pueden usar esta red de deliveries?
  * **R:** Sí, los envíos se generan desde la finca origen hacia el cliente utilizando los repartidores activos.
* **P10:** ¿Puedo aceptar entregas desde otra ciudad?
  * **R:** No, la geolocalización impide asignaciones fuera de la zona optimizada para garantizar la frescura.


# Módulo: Chat Integrado (Conversaciones)
Facilita la mensajería interna y directa en tiempo real asociada de manera estricta a un pedido activo. Tienen acceso el cliente, el productor y el repartidor involucrados en la entrega de esa orden específica

> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1: No se puede iniciar una conversación ni enviar mensajes si el chat no está vinculado estrictamente a un pedido activo en la plataforma; el canal se cerrará y pasará automáticamente a modo "Solo lectura" una vez que el estado del pedido cambie a "Entregado" o "Cancelado".]
> * [Regla 2: Debido a las limitaciones de conectividad en las zonas rurales, el tamaño de cada mensaje de texto en tiempo real estaará limitado a un máximo de 500 caracteres para asegurar la rapidez del envío bajo redes móviles de baja velocidad.]
> * [Regla 3: El sistema restringirá el acceso a la sala de chat de manera que únicamente el comprador, el productor y el repartidor asignado de forma oficial a esa orden específica tengan permisos para leer o escribir mensajes, bloqueando a cualquier usuario externo.]

## 🛠️ Casos de Uso
### Caso de Uso 1: Coordinar Horario de Entrega
* **Rol:** Cliente (o Repartidor/Productor)
* **Requisitos:** Tener un pedido activo en curso.
* **Paso a Paso:**
  1. Entrar al detalle del pedido activo (En Curso).
  2. Abrir el "Chat Mensajes" de esa orden.
  3. Enviar un texto (menor a 500 caracteres) para coordinar con el repartidor si estás o no en casa.

### Caso de Uso 2: Consultar al Productor por Instrucciones
* **Rol:** Cliente
* **Requisitos:** El pedido debe estar en preparación o pendiente de recogida.
* **Paso a Paso:**
  1. Dirigirse al menú Mis Pedidos y entrar a la pantalla del pedido.
  2. Seleccionar el botón de "Mensaje".
  3. Pedir al productor detalles, como solicitar que empaquen las frutas con cuidado extra.

### Caso de Uso 3: Consultar un Chat Histórico
* **Rol:** Comprador / Productor / Repartidor
* **Requisitos:** Tener un pedido ya finalizado ("Entregado" o "Cancelado").
* **Paso a Paso:**
  1. Encontrar la orden en el historial de pedidos finalizados.
  2. Acceder a la sala de chat de esa orden antigua.
  3. Leer los mensajes de forma pasiva, ya que el teclado estará bloqueado en modo "Solo lectura".

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo escribirle a un productor si no le he comprado nada?
  * **R:** No, no puedes iniciar conversaciones si el chat no está estrictamente vinculado a un pedido activo.
* **P2:** ¿Por qué no se envía mi mensaje tan largo?
  * **R:** Por limitaciones de conectividad rural, cada mensaje está limitado a un máximo de 500 caracteres.
* **P3:** ¿Qué pasa con el chat cuando me entregan el pedido?
  * **R:** El canal se cierra automáticamente y pasa a modo "Solo lectura".
* **P4:** ¿Si cancelo un pedido puedo seguir chateando?
  * **R:** No, al pasar a estado "Cancelado", el chat también se bloquea y queda en solo lectura.
* **P5:** ¿Puede otro comprador ver mis mensajes con el productor?
  * **R:** De ninguna manera. El sistema restringe el acceso bloqueando a cualquier usuario externo a esa orden.
* **P6:** ¿Quiénes exactamente están en el chat de mi pedido?
  * **R:** Únicamente tú (comprador), el productor y el repartidor oficial asignado tienen acceso.
* **P7:** ¿Puedo enviar fotos o audios pesados por el chat?
  * **R:** El enfoque principal es mensajería de texto ligera para garantizar rapidez bajo redes de baja velocidad.
* **P8:** ¿Cómo sé si el repartidor leyó mi instrucción?
  * **R:** La mensajería es directa y en tiempo real para todos los involucrados en la orden.
* **P9:** ¿El chat consume muchos datos móviles?
  * **R:** No, está optimizado mediante la restricción de caracteres para funcionar bien en zonas de baja cobertura.
* **P10:** ¿Puedo eliminar un mensaje después de que el chat se cerró?
  * **R:** No, el chat queda guardado permanentemente en estado de "Solo lectura" como registro de la orden.


# Módulo: Valoraciones y Reseñas
Permite emitir calificaciones y comentarios sobre los pedidos recibidos, recalculando de manera automática el promedio de reputación de los productores. Tienen acceso los clientes para calificar, y los productores para visualizar su reputación

> *Restricciones del Módulo de Valoraciones y Reseñas:*
> * [Regla 1: El sistema no permitirá a un cliente registrar una valoración o reseña si esta no está vinculada de manera obligatoria a un pedido con estado "Entregado" y que haya sido comprado por ese mismo usuario, previniendo calificaciones falsas o manipulación de reputación.]
> * [Regla 2: Debido a la naturaleza perecedera de los alimentos, el cliente tendrá un límite de tiempo máximo de 7 días calendario a partir de la entrega del pedido para emitir su valoración; una vez vencido este plazo, la opción de calificar quedará inhabilitada automáticamente por el sistema.]
> * [Regla 3: La app bloqueará de forma absoluta cualquier intento de autovaloración (es decir, que un productor intente calificarse a sí mismo o a sus propios productos utilizando cuentas alternativas de comprador), garantizando la transparencia del mercado.]

## 🛠️ Casos de Uso
### Caso de Uso 1: Calificar una Compra Exitosa
* **Rol:** Comprador
* **Requisitos:** Haber recibido un pedido en los últimos 7 días con estado "Entregado".
* **Paso a Paso:**
  1. Ir a la pantalla de "Valorar Pedido".
  2. Seleccionar la cantidad de estrellas y escribir una reseña descriptiva.
  3. Presionar Enviar; el promedio del productor se recalculará instantáneamente.

### Caso de Uso 2: Revisar la Reputación (Cliente)
* **Rol:** Comprador
* **Requisitos:** Explorar un producto o granja antes de comprar.
* **Paso a Paso:**
  1. Entrar al "Perfil del Productor" en el explorador.
  2. Verificar el promedio de estrellas y la cantidad de reseñas.
  3. Leer los comentarios pasados de otros compradores para ganar confianza en la finca.

### Caso de Uso 3: Consultar Mi Reputación (Productor)
* **Rol:** Productor
* **Requisitos:** Haber realizado ventas y recibido comentarios.
* **Paso a Paso:**
  1. Abrir la pantalla principal o el tablero (Dashboard).
  2. Revisar la insignia de "Valoración" junto con el número de estrellas.
  3. Esto te ayudará a saber qué piensan los clientes de la calidad de tus alimentos.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo dejar una reseña de un pedido que aún viene en camino?
  * **R:** No, la valoración debe estar vinculada obligatoriamente a un pedido con estado "Entregado".
* **P2:** ¿Puedo calificar una compra que hice el mes pasado?
  * **R:** No, tienes un límite máximo de 7 días calendario tras la entrega. Después, la opción se inhabilita.
* **P3:** Como productor, ¿puedo comprarme mis propios productos para subir mi calificación?
  * **R:** La app bloquea de forma absoluta cualquier intento de autovaloración con cuentas alternativas para garantizar la transparencia.
* **P4:** ¿Por qué me da error al intentar reseñar el pedido de un amigo?
  * **R:** Solo puedes reseñar los pedidos que hayan sido comprados oficialmente desde tu propia cuenta.
* **P5:** ¿El productor puede borrar mi mala calificación?
  * **R:** Los productores solo tienen acceso para visualizar su reputación, no pueden borrar reseñas de clientes reales.
* **P6:** ¿Qué pasa con la reputación de la finca cuando dejo estrellas?
  * **R:** El sistema recalcula de manera automática el promedio de reputación del productor.
* **P7:** ¿Por qué solo tengo 7 días para opinar?
  * **R:** Debido a la naturaleza perecedera de los alimentos, se requiere que la valoración refleje la calidad real al momento de entrega.
* **P8:** ¿Las calificaciones son anónimas?
  * **R:** Las calificaciones están vinculadas a la cuenta del comprador que realizó el pedido para mantener la veracidad.
* **P9:** ¿Puedo cambiar mi reseña después de los 7 días?
  * **R:** Una vez vencido el plazo, la opción de modificar o crear calificaciones queda inhabilitada automáticamente.
* **P10:** ¿Un productor falso puede inflar sus estrellas?
  * **R:** Es imposible, ya que requiere compras reales completadas, y el fraude por autovaloración está estrictamente bloqueado.



# Módulo: Suscripciones de la App
Controla los planes de pago de los productores asociados, impidiendo duplicidad de planes activos y calculando automáticamente la vigencia de sus servicios. Tienen acceso los productores para suscribirse y los administradores para configurar tarifas

> *Restricciones del Módulo de Suscripcciones:*
> * [Regla 1: El sistema bloqueará de forma absoluta cualquier intento de suscripción a un nuevo plan de pago si el perfil del productor ya cuenta con un plan de suscripción activo y vigente en su cuenta, impidiendo estrictamente la duplicidad de planes concurrentes.]
> * [Regla 2: El sistema no admitirá reembolsos automáticos ni cancelaciones con devolución de dinero si el productor ya ha realizado la publicación de al menos un lote de productos agrícolas o de origen animal durante el ciclo de facturación actual del plan contratado.]
> * [Regla 3: El sistema calculará de manera automática la fecha de vigencia y vencimiento del servicio en el instante preciso de la confirmación del pago, programando un servicio en segundo plano para suspender automáticamente las publicaciones del catálogo del proveedor si la suscripción llega a su fecha de expiración sin haber sido renovada.]

## 🛠️ Casos de Uso
### Caso de Uso 1: Contratar un Plan Inicial
* **Rol:** Productor
* **Requisitos:** Haber completado el perfil de finca y no tener planes vigentes.
* **Paso a Paso:**
  1. Acceder a la pantalla de "Suscripciones".
  2. Elegir el plan tarifario que mejor se adapte al volumen de tu finca y proceder a pagar.
  3. El sistema habilitará inmediatamente tu permiso para publicar productos al mundo.

### Caso de Uso 2: Consultar Vigencia del Plan
* **Rol:** Productor
* **Requisitos:** Tener un plan de suscripción activo.
* **Paso a Paso:**
  1. Ir a los ajustes de cuenta o panel de control.
  2. Tocar en "Mi Plan Actual".
  3. Ver los días restantes o la fecha de corte exacta calculada por el sistema.

### Caso de Uso 3: Renovar Suscripción Vencida
* **Rol:** Productor
* **Requisitos:** Tu catálogo está oculto porque la suscripción expiró.
* **Paso a Paso:**
  1. Entrar de nuevo a la sección de "Suscripciones".
  2. Seleccionar el plan a renovar.
  3. Completar el pago para reactivar y que la app vuelva a mostrar tu inventario automáticamente.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo comprar dos planes de suscripción al mismo tiempo para sumar meses?
  * **R:** No, el sistema bloquea cualquier intento de duplicidad de planes activos concurrentes en tu cuenta.
* **P2:** ¿Me devuelven mi dinero si cancelo mi suscripción a la mitad del mes?
  * **R:** No se admiten reembolsos si ya has realizado al menos la publicación de un lote de productos en ese ciclo.
* **P3:** ¿Qué pasa si mi suscripción vence hoy?
  * **R:** Si llega a su fecha de expiración sin renovación, un servicio automático suspenderá tus publicaciones del catálogo.
* **P4:** ¿Cómo se calcula mi fecha de corte?
  * **R:** El sistema calcula la vigencia y vencimiento exactamente en el instante de la confirmación del pago.
* **P5:** ¿Pierdo mi cuenta si se vence mi suscripción?
  * **R:** No pierdes tu cuenta, pero tus productos se ocultarán del catálogo público hasta que renueves.
* **P6:** ¿Puedo probar publicando un producto y luego pedir reembolso?
  * **R:** Al publicar al menos un lote de productos agrícolas o animales, renuncias al derecho de cancelación con reembolso automático.
* **P7:** ¿Quién define los precios de los planes?
  * **R:** Los administradores de la plataforma son los únicos con acceso para configurar las tarifas de los planes.
* **P8:** ¿Puedo suscribirme si soy comprador o repartidor?
  * **R:** Este módulo de planes de pago está diseñado exclusivamente para los productores asociados.
* **P9:** ¿Tengo que ocultar mis productos manualmente si no voy a renovar?
  * **R:** No es necesario, la plataforma lo hace en segundo plano de manera automática al vencer el plan.
* **P10:** ¿Qué pasa si intento pagar un plan nuevo teniendo uno vigente?
  * **R:** La plataforma rechazará el cobro de forma absoluta para protegerte de pagos dobles.



# Módulo: Impacto Social
Calcula, acumula y visualiza estadísticas en tiempo real sobre las libras , quintales o de comida salvada del desperdicio y las ganancias extras generadas por ofertas de excedentes. Tienen acceso de visualización los clientes y productores, y acceso administrativo el equipo de la plataforma

> *Restricciones del Módulo de Impacto Social:*
> * [Regla 1: Los productores y clientes tendrán acceso únicamente en modo de lectura a las estadísticas del tablero de impacto; cualquier modificación, recalibración de fórmulas de desperdicio o corrección de datos históricos queda restringida de forma exclusiva para el equipo administrativo de la plataforma.]
> * [Regla 2: Las actualizaciones del tablero de impacto es en  tiempo real , garantizando que el recálculo constante de datos masivos no afecte la velocidad de carga de la aplicación para los usuarios activos.]
> * [Regla 3: El sistema únicamente sumará las libras o quintales de comida salvada al acumulador del tablero de impacto cuando el estado del pedido asociado cambie formalmente a "Entregado", impidiendo estrictamente que órdenes canceladas alteren las métricas de sostenibilidad.]
> * 

## 🛠️ Casos de Uso
### Caso de Uso 1: Visualizar Estadísticas Globales de Desperdicio
* **Rol:** Comprador / Productor
* **Requisitos:** Tener cuenta en la app y pedidos completados en la plataforma.
* **Paso a Paso:**
  1. Ir a la pantalla de inicio y buscar el módulo "Tablero de Impacto".
  2. Leer las métricas globales de libras de comida salvada en toda la comunidad.
  3. Visualizar cómo la red colabora en la sostenibilidad del entorno.

### Caso de Uso 2: Consultar Impacto Personal
* **Rol:** Comprador / Productor
* **Requisitos:** Haber finalizado compras o ventas de excedentes.
* **Paso a Paso:**
  1. Entrar al "Perfil del Usuario" o "Perfil Finca".
  2. Buscar la insignia o apartado de impacto.
  3. Leer la contribución personal exacta al ecosistema, en base a tus pedidos entregados.

### Caso de Uso 3: Ver Ganancias por Ofertas
* **Rol:** Productor
* **Requisitos:** Haber logrado vender excedentes bajo oferta que de otro modo se desperdiciarían.
* **Paso a Paso:**
  1. Abrir las estadísticas de tu panel de control de finca.
  2. Navegar a las métricas de impacto de tus ventas.
  3. Consultar las ganancias extras generadas gracias al rescate de alimentos.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué no suben mis libras salvadas si acabo de hacer un pedido?
  * **R:** El sistema solo suma las libras al acumulador cuando el pedido cambia formalmente a estado "Entregado".
* **P2:** ¿Puedo corregir mis datos históricos del tablero?
  * **R:** No, los productores y clientes solo tienen acceso de lectura; las modificaciones son exclusivas del equipo administrativo.
* **P3:** ¿Los pedidos cancelados suman al impacto social?
  * **R:** De ninguna manera, se impide estrictamente que órdenes canceladas alteren las métricas de sostenibilidad.
* **P4:** ¿El tablero hace que la app se ponga lenta?
  * **R:** No, aunque las actualizaciones son en tiempo real, el recálculo está optimizado para no afectar la velocidad de carga.
* **P5:** ¿Quién decide cómo se calcula la comida salvada?
  * **R:** La calibración de las fórmulas de desperdicio es gestionada únicamente por la administración.
* **P6:** ¿Puedo borrar mis estadísticas de impacto?
  * **R:** Como usuario final, tu acceso es únicamente en modo de lectura.
* **P7:** ¿Qué mide exactamente el tablero de impacto?
  * **R:** Acumula las libras/quintales de comida rescatada y ganancias generadas por ofertar excedentes agrícolas.
* **P8:** ¿Veo las estadísticas de todos o solo las mías?
  * **R:** Puedes visualizar tanto el impacto global de la comunidad como tu contribución personal.
* **P9:** ¿Debo ingresar manualmente lo que salvé del desperdicio?
  * **R:** Todo se calcula de manera automática a través de las ventas de excedentes completadas.
* **P10:** ¿Los repartidores pueden ver el tablero de impacto?
  * **R:** El acceso de visualización está diseñado principalmente para las partes comerciales: clientes y productores.


# Módulo: Gestión de Usuarios e Identidad
Este módulo se encarga de administrar el control de acceso basado en roles (RBAC) para Compradores, Productores y Repartidores, gestionando  un flujo obligatorio de verificación de identidad con documentos oficiales. Tienen acceso a él todos los usuarios del sistema

> *Restricciones del Módulo de Gestión de Usuarios e Identidad*
> * [Regla 1: Para el registro de Repartidores, el sistema exigirá de forma obligatoria la carga de una licencia de conducir vigente y la especificación del tipo de vehículo, impidiendo el envío de la solicitud de onboarding si faltan estos datos.]
> * [Regla 2: La app restringirá de forma estricta las vistas y operaciones de la plataforma mediante un control de acceso basado en roles , impidiendo que un usuario con rol "Comprador" visualice el panel de inventario del "Productor", o que un "Repartidor" acceda al flujo de compras.]
> * 

## 🛠️ Casos de Uso
### Caso de Uso 1: Registro como Repartidor
* **Rol:** Repartidor
* **Requisitos:** Descargar la app, tener documentos a mano.
* **Paso a Paso:**
  1. Iniciar el flujo de registro o Role Selection y escoger "Repartidor".
  2. Tomar una fotografía a la licencia de conducir y seleccionar el tipo de transporte.
  3. Enviar formulario, que se bloqueará si faltan adjuntos obligatorios.

### Caso de Uso 2: Iniciar Sesión con el Rol Correcto
* **Rol:** Comprador / Productor
* **Requisitos:** Cuenta previamente aprobada.
* **Paso a Paso:**
  1. Colocar las credenciales en la pantalla de "Login".
  2. El sistema validará tu RBAC (Control de Acceso basado en Roles).
  3. Te redirigirá al inicio de "Productor" (si vendes) o "Comprador" (si compras).

### Caso de Uso 3: Recuperar o Editar Datos de Identidad
* **Rol:** Todos los usuarios
* **Requisitos:** Haber iniciado sesión.
* **Paso a Paso:**
  1. Ingresar a "Editar Perfil".
  2. Cambiar tu foto de usuario o datos de contacto.
  3. El sistema aplicará los cambios protegiendo tus campos de rol bloqueados.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Puedo registrarme como repartidor sin licencia de conducir?
  * **R:** No, es obligatorio cargar una licencia vigente. Si falta este dato, no podrás enviar la solicitud.
* **P2:** ¿Puedo como comprador ver el inventario interno de un productor?
  * **R:** La app restringe el acceso; un usuario con rol "Comprador" no puede visualizar el panel administrativo del productor.
* **P3:** ¿Un repartidor puede comprar productos desde su misma cuenta?
  * **R:** No, el control de acceso impide que un "Repartidor" acceda al flujo de compras. Debes usar una cuenta de comprador.
* **P4:** ¿Por qué me piden los datos de mi vehículo?
  * **R:** Es obligatorio para que el sistema sepa qué tipo de carga puedes transportar y asignarte pedidos correctos.
* **P5:** ¿Qué pasa si mi cuenta de comprador intenta abrir la vista de entregas?
  * **R:** El sistema aplica un control estricto de roles (RBAC) y bloqueará la pantalla por permisos insuficientes.
* **P6:** ¿Quién revisa mis documentos de identidad?
  * **R:** El equipo de administración revisa y aprueba tus documentos oficiales.
* **P7:** ¿Puedo saltarme el paso de subir la foto de la licencia?
  * **R:** El sistema impedirá el envío de tu formulario de registro si omites los adjuntos obligatorios.
* **P8:** ¿Puedo ser productor y comprador a la vez?
  * **R:** Se manejan roles separados en la plataforma para garantizar la seguridad de los flujos de cada usuario.
* **P9:** ¿Es seguro subir mi documento oficial?
  * **R:** Sí, el flujo de verificación es obligatorio para proteger a la comunidad y tus datos están seguros.
* **P10:** ¿Cuándo podré empezar a trabajar como repartidor?
  * **R:** Inmediatamente después de que administración verifique tu identidad y apruebe tu solicitud.


# Módulo: Geofencing y Cadena de Suministro
Calcula en tiempo real la distancia geográfica entre el comprador y el productor utilizando coordenadas para priorizar a los comercios más cercanos, permitiendo además configurar agendas y modos de entrega logísticos donde el agricultor permanece estático en su finca. Tienen acceso los Compradores para buscar ofertas locales, los Repartidores para optimizar rutas de traslado y los Productores para definir zonas de distribución

> *Restricciones del Módulo de Geofencing y Cadena de Suministro*
> * [Regla 1: El sistema no permitirá realizar búsquedas de productos por cercanía ni mostrar ofertas locales en el mapa si el comprador no tiene activos los permisos de geolocalización en su dispositivo o no ha guardado una dirección con coordenadas espaciales válidas ]
> * [Regla 2: El productor no podrá modificar dinámicamente las coordenadas geográficas de su finca mientras existan sub-pedidos activos en estado "Pendiente" o "Preparando", garantizando que los cálculos de ruta estática para los repartidores y clientes no sufran alteraciones inesperadas .]

## 🛠️ Casos de Uso
### Caso de Uso 1: Búsqueda de Ofertas en el Mapa
* **Rol:** Comprador
* **Requisitos:** GPS activado y dirección guardada en el perfil.
* **Paso a Paso:**
  1. Entrar a la pantalla de "Productores Cercanos" o "Mapa de Calor".
  2. Validar que los permisos de ubicación están otorgados a la app.
  3. Verás instantáneamente los comercios más cercanos gracias al cálculo de distancia en tiempo real.

### Caso de Uso 2: Fijar Coordenadas de la Finca
* **Rol:** Productor
* **Requisitos:** Estar en la configuración de la granja y no tener pedidos activos.
* **Paso a Paso:**
  1. Entrar al apartado "Perfil Finca" y ubicar el mapa interno.
  2. Arrastrar el pin al punto exacto (estático) de la propiedad agrícola.
  3. Guardar, asegurando la ruta de extracción para clientes y repartidores.

### Caso de Uso 3: Optimización de Ruta en Tiempo Real
* **Rol:** Repartidor
* **Requisitos:** Haber aceptado una orden.
* **Paso a Paso:**
  1. Abrir la pantalla de "Ruta de Entrega Repartidor".
  2. La app leerá las coordenadas fijadas por el productor y el comprador.
  3. Se calculará el trazado más eficiente en el mapa logístico de la aplicación.

## ❓ Top 10 Preguntas Frecuentes
* **P1:** ¿Por qué no me aparecen ofertas locales en el mapa?
  * **R:** El sistema no buscará por cercanía si no tienes activos los permisos de GPS o no has guardado una dirección válida.
* **P2:** Soy productor, ¿puedo cambiar la ubicación de mi finca a diario?
  * **R:** No podrás modificar tus coordenadas si tienes pedidos pendientes o en preparación, para no afectar las rutas.
* **P3:** ¿Por qué la app necesita mis coordenadas espaciales?
  * **R:** Para calcular en tiempo real la distancia entre tú y las fincas, priorizando los alimentos más cercanos y frescos.
* **P4:** ¿Qué pasa si el productor se muda mientras mi pedido va en camino?
  * **R:** El sistema bloquea el cambio de ubicación del agricultor si tiene órdenes activas, garantizando tu entrega.
* **P5:** ¿Puedo buscar comercios de otros departamentos o países?
  * **R:** La prioridad del geofencing es mostrarte comercios cercanos, pero depende de las ubicaciones registradas.
* **P6:** ¿Los repartidores usan este módulo?
  * **R:** Sí, utilizan estas coordenadas estáticas para optimizar sus rutas de traslado.
* **P7:** ¿Qué significa que el agricultor permanece estático?
  * **R:** Que las fincas operan desde un punto fijo establecido, facilitando la logística y retiro en origen.
* **P8:** ¿Qué hago si el mapa dice que no tengo ubicación válida?
  * **R:** Debes ir a tu perfil y guardar una dirección exacta usando el pin del mapa para activar las funciones locales.
* **P9:** ¿Me cobrarán más envío si el productor cambia sus coordenadas?
  * **R:** Las coordenadas se bloquean durante tu compra, por lo que las distancias y costos pactados no sufrirán alteraciones inesperadas.
* **P10:** ¿Funciona la app si apago mi GPS?
  * **R:** Podrás usar funciones básicas, pero se deshabilitarán las búsquedas de productos por cercanía y cálculo de rutas.

</documentacion_AgroTrade>