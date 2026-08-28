l<instrucciones_sistema>
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

## En los titutos dos irian los caso de uso de la app o acciones , ya sean los flujo o reglas de negocios indinpensables 

///*En este formaot irian las limitaciones de sistema o sus restricciones de la misma*

> *Restricciones del Módulo De Gestión de Proveedores :*
> * [Regla 1:  Asociación de Usuario Obligatoria : El perfil de proveedor es una extensión directa de un usuario, por lo que debe estar estrictamente vinculado a un registro existente. No se puede dar de alta un proveedor sin una cuenta de usuario activa previa]
> * [Regla 2: Validación de Integridad en Productos: Al registrar o actualizar cualquier producto agrícola en el catálogo, el campo **del proveedor** es de carácter obligatorio y el identificador proporcionado debe existir dentro  de la app.]
> * [Regla 3: Restricción de Registro de Inventario:  Al crear o actualizar existencias de stock, el campo del proveedor es obligatorio, debe existir dentro de la app y la app realiza una verificación de su existencia antes de completar la operación.]
> * [Regla 3: Protección contra Valoraciones Fraudulentas: Un cliente no puede calificar al proveedor por un pedido que no haya sido comprado por él mismo  ni duplicar una valoración para un mismo pedido .]



# Módulo: Categorías de Productos
Organiza y clasifica el catálogo de productos agrícolas para facilitar la búsqueda estructurada (ej. frutales o cítricos).Tienen acceso de consulta los clientes, y acceso de administración completa los administradores del sistema.


> *Restricciones del Módulo De Categoriía de productos :*
> * [Regla 1:  Nombre de Categoría Obligatorio : El nombre de la categoría es un campo de carácter estrictamente requerido  tanto para registrar una nueva categoría como para modificar una existente]
> * [Regla 2:  Verificación de Existencia Previa :  Para ejecutar cualquier operación de actualización o eliminación, el sistema realiza una comprobación de existencia  de la categoría dentro de app. Si el registro no se encuentra, la plataforma responde con un error de que no se encontro]
> * [[Regla 3: Solo los Administradores del sistema tienen permisos de creación, modificación o eliminación  de categorías; los clientes y productores únicamente poseen permisos de consulta y lectura para explorar el catálogo.]]





# Módulo: Catálogo de Productos
Administra la lista global de productos agrícolas de la plataforma, garantizando que estén correctamente vinculados a sus categorías 
y proveedores. Tienen acceso los clientes para explorar el catálogo y los administradores para dar de alta nuevos productos base


> *Restricciones de Catálogo de Productos :*
> * [Regla 1: Todo producto publicado en el catálogo para la vista del cliente debe estar asociado a una unidad de medida estandarizada por el sistema (libra, unidad, moño o atado) y tener un precio unitario mayor a cero, validando que el costo sugerido guarde coherencia con la calculadora de precio justo.]
>  [[Regla 2: Al registrar un lote de producto, el sistema exige ingresar obligatoriamente la fecha de cosecha y la ventana de frescura (vida útil estimada en días), impidiendo el registro si la fecha de cosecha es posterior a la fecha actual o si la vida útil es menor o igual a cero.]]




# Módulo: Inventario y Stock del Proveedor
Permite registrar y actualizar existencias, subir imágenes , controlar la merma con el método FIFO(primero que entra primero que sale) y calcular un "Precio Justo" según costos de producción. Tienen acceso exclusivo los productores agrícolas



> *Restricciones del Módulo de Inventario y Stock del proveedor:*
> * [Regla 1:  El sistema no permitirá registrar un lote de inventario si no se ingresan obligatoriamente la fecha de cosecha y la ventana de frescura (días de vida útil estimada), asegurando el correcto funcionamiento de las colas FIFO para priorizar la venta del producto más próximo a caducar.]
> * [Regla2 : Para calcular el "Precio Justo", es obligatorio que el productor complete los campos de costos de producción; el sistema bloqueará la activación de un precio sugerido si este es menor al costo de producción calculado, protegiendo al agricultor de vender a pérdidas.]


# Módulo: Pedidos y Compras
Permite realizar la compra de productos, facilitando un carrito multi-proveedor que divide automáticamente un pago global único entre varios agricultores. Tienen acceso los clientes para comprar, y los productores para visualizar y preparar sus pedidos correspondientes



> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1:  La App no permitirá procesar ni finalizar la compra de un producto en el carrito si el valor del sub-pedido asociado a una finca específica no alcanza el monto mínimo de compra monetario configurado por ese productor en su perfil.]
> * [Regla 2:  No se puede proceder al pago de la orden si el comprador no ha seleccionado un método de logística válido (sea retiro en finca, reparto a través de la Red de Deliveries o el transporte propio del productor) y guardado coordenadas geográficas válidas para el cálculo de distancias]
> * [Regla 3: Control de Existencias en Tiempo Real: Para asegurar la viabilidad de la compra y evitar la adquisición de productos agotados, el inventario del proveedor se actualiza en  tiempo real con cada confirmación de pedido. Si el stock actual es menor a la cantidad solicitada en la línea de detalle, el sistema bloquea el flujo de confirmación del pedido] 
> * [Regla 4: Validación de Propiedad en Valoración : Para evitar calificaciones fraudulentas, la app impide la creación o modificación de una reseña si el pedido calificado no pertenece al identificador del cliente que realiza la solicitud, respondiendo con un error de acceso prohibido] 
> * [Regla 5: Opcionalidad del Servicio de Envío:  El uso del módulo de entregas es de carácter completamente opcional. El flujo logístico de asignación de repartidor solo se activa si el cliente selecciona explícitamente que desea hacer uso de dicho servicio de transporte]

# Módulo: Logística y Entregas
Controla la cola de solicitudes  de envío, asignando rutas optimizadas a los transportistas activos más cercanos que posean el vehículo idóneo. Tienen acceso los repartidores para aceptar entregas, y los clientes para contratar y realizar el seguimiento en tiempo real.


> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1: El sistema bloqueará la asignación de un envío si el repartidor activo no se encuentra dentro del rango geográfico optimizado  respecto a la finca de origen, minimizando así los tiempos de tránsito y previniendo retrasos]
> * [Regla 2: No se puede asignar una solicitud de envío a la cola de un transportista si el tipo de vehículo registrado por este no cumple con los requisitos de capacidad o condiciones especiales del pedido.]
> * [Regla 3: Un repartidor no tendrá permitido aceptar ninguna solicitud de entrega en la cola si su perfil de identidad y licencia de conducir no han sido previamente verificados y marcados en estado "Aprobado" por la administración .]


# Módulo: Chat Integrado (Conversaciones)
Facilita la mensajería interna y directa en tiempo real asociada de manera estricta a un pedido activo. Tienen acceso el cliente, el productor y el repartidor involucrados en la entrega de esa orden específica


> *Restricciones del Módulo de Pedidos Y Compras:*
> * [Regla 1: No se puede iniciar una conversación ni enviar mensajes si el chat no está vinculado estrictamente a un pedido activo en la plataforma; el canal se cerrará y pasará automáticamente a modo "Solo lectura" una vez que el estado del pedido cambie a "Entregado" o "Cancelado".]
> * [Regla 2: Debido a las limitaciones de conectividad en las zonas rurales, el tamaño de cada mensaje de texto en tiempo real estaará limitado a un máximo de 500 caracteres para asegurar la rapidez del envío bajo redes móviles de baja velocidad.]
> * [Regla 3: El sistema restringirá el acceso a la sala de chat de manera que únicamente el comprador, el productor y el repartidor asignado de forma oficial a esa orden específica tengan permisos para leer o escribir mensajes, bloqueando a cualquier usuario externo.]


# Módulo: Valoraciones y Reseñas
Permite emitir calificaciones y comentarios sobre los pedidos recibidos, recalculando de manera automática el promedio de reputación de los productores. Tienen acceso los clientes para calificar, y los productores para visualizar su reputación



> *Restricciones del Módulo de Valoraciones y Reseñas:*
> * [Regla 1: El sistema no permitirá a un cliente registrar una valoración o reseña si esta no está vinculada de manera obligatoria a un pedido con estado "Entregado" y que haya sido comprado por ese mismo usuario, previniendo calificaciones falsas o manipulación de reputación.]
> * [Regla 2: Debido a la naturaleza perecedera de los alimentos, el cliente tendrá un límite de tiempo máximo de 7 días calendario a partir de la entrega del pedido para emitir su valoración; una vez vencido este plazo, la opción de calificar quedará inhabilitada automáticamente por el sistema.]
> * [Regla 3: La app bloqueará de forma absoluta cualquier intento de autovaloración (es decir, que un productor intente calificarse a sí mismo o a sus propios productos utilizando cuentas alternativas de comprador), garantizando la transparencia del mercado.]



# Módulo: Suscripciones de la App
Controla los planes de pago de los productores asociados, impidiendo duplicidad de planes activos y calculando automáticamente la vigencia de sus servicios. Tienen acceso los productores para suscribirse y los administradores para configurar tarifas



> *Restricciones del Módulo de Suscripcciones:*
> * [Regla 1: El sistema bloqueará de forma absoluta cualquier intento de suscripción a un nuevo plan de pago si el perfil del productor ya cuenta con un plan de suscripción activo y vigente en su cuenta, impidiendo estrictamente la duplicidad de planes concurrentes.]
> * [Regla 2: El sistema no admitirá reembolsos automáticos ni cancelaciones con devolución de dinero si el productor ya ha realizado la publicación de al menos un lote de productos agrícolas o de origen animal durante el ciclo de facturación actual del plan contratado.]
> * [Regla 3: El sistema calculará de manera automática la fecha de vigencia y vencimiento del servicio en el instante preciso de la confirmación del pago, programando un servicio en segundo plano para suspender automáticamente las publicaciones del catálogo del proveedor si la suscripción llega a su fecha de expiración sin haber sido renovada.]



# Módulo: Impacto Social
Calcula, acumula y visualiza estadísticas en tiempo real sobre las libras , quintales o de comida salvada del desperdicio y las ganancias extras generadas por ofertas de excedentes. Tienen acceso de visualización los clientes y productores, y acceso administrativo el equipo de la plataforma



> *Restricciones del Módulo de Impacto Social:*
> * [Regla 1: Los productores y clientes tendrán acceso únicamente en modo de lectura a las estadísticas del tablero de impacto; cualquier modificación, recalibración de fórmulas de desperdicio o corrección de datos históricos queda restringida de forma exclusiva para el equipo administrativo de la plataforma.]
> * [Regla 2: Las actualizaciones del tablero de impacto es en  tiempo real , garantizando que el recálculo constante de datos masivos no afecte la velocidad de carga de la aplicación para los usuarios activos.]
> * [Regla 3: El sistema únicamente sumará las libras o quintales de comida salvada al acumulador del tablero de impacto cuando el estado del pedido asociado cambie formalmente a "Entregado", impidiendo estrictamente que órdenes canceladas alteren las métricas de sostenibilidad.]
> * 

# Módulo: Gestión de Usuarios e Identidad
Este módulo se encarga de administrar el control de acceso basado en roles (RBAC) para Compradores, Productores y Repartidores, gestionando  un flujo obligatorio de verificación de identidad con documentos oficiales. Tienen acceso a él todos los usuarios del sistema


> *Restricciones del Módulo de Gestión de Usuarios e Identidad*
> * [Regla 1: Para el registro de Repartidores, el sistema exigirá de forma obligatoria la carga de una licencia de conducir vigente y la especificación del tipo de vehículo, impidiendo el envío de la solicitud de onboarding si faltan estos datos.]
> * [Regla 2: La app restringirá de forma estricta las vistas y operaciones de la plataforma mediante un control de acceso basado en roles , impidiendo que un usuario con rol "Comprador" visualice el panel de inventario del "Productor", o que un "Repartidor" acceda al flujo de compras.]
> * 

# Módulo: Geofencing y Cadena de Suministro
Calcula en tiempo real la distancia geográfica entre el comprador y el productor utilizando coordenadas para priorizar a los comercios más cercanos, permitiendo además configurar agendas y modos de entrega logísticos donde el agricultor permanece estático en su finca. Tienen acceso los Compradores para buscar ofertas locales, los Repartidores para optimizar rutas de traslado y los Productores para definir zonas de distribución


> *Restricciones del Módulo de Geofencing y Cadena de Suministro*
> * [Regla 1: El sistema no permitirá realizar búsquedas de productos por cercanía ni mostrar ofertas locales en el mapa si el comprador no tiene activos los permisos de geolocalización en su dispositivo o no ha guardado una dirección con coordenadas espaciales válidas ]
> * [Regla 2: El productor no podrá modificar dinámicamente las coordenadas geográficas de su finca mientras existan sub-pedidos activos en estado "Pendiente" o "Preparando", garantizando que los cálculos de ruta estática para los repartidores y clientes no sufran alteraciones inesperadas .]

</documentacion_AgroTrade>