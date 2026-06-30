CREATE TABLE "usuarios" (
  "id_usuario" integer PRIMARY KEY,
  "nombre_completo" varchar,
  "email" varchar UNIQUE,
  "password_hash" varchar,
  "identidad_verificada" boolean DEFAULT false,
  "OAuthProvider" varchar,
  "OAuthProviderId" varchar,
  "telefono" varchar,
  "direccion_base" text,
  "fecha_registro" timestamp
);

CREATE TABLE "Roles" (
  "id_rol" integer PRIMARY KEY,
  "nombre_rol" varchar
);

CREATE TABLE "usuarios_roles" (
  "id_usuario" int,
  "id_rol" int,
  PRIMARY KEY ("id_usuario", "id_rol")
);

CREATE TABLE "permisos" (
  "id_permiso" int PRIMARY KEY,
  "nombre_permiso" varchar
);

CREATE TABLE "roles_permisos" (
  "id_rol" int,
  "id_permisos" int,
  PRIMARY KEY ("id_rol", "id_permisos")
);

CREATE TABLE "proveedores" (
  "id_proveedor" integer PRIMARY KEY,
  "nombre_proveedor" varchar,
  "id_usuario" integer,
  "nombre_finca" varchar,
  "ubicacion_gps" varchar,
  "biografia" text,
  "calificacion_promedio" float
);

CREATE TABLE "categorias" (
  "id_categoria" integer PRIMARY KEY,
  "nombre" varchar
);

CREATE TABLE "productos" (
  "id_producto" integer PRIMARY KEY,
  "id_categoria" integer,
  "id_proveedor" integer,
  "nombre" varchar,
  "descripcion" text,
  "unidad_medida" varchar
);

CREATE TABLE "inventario_proveedor" (
  "id_inventario" integer PRIMARY KEY,
  "id_proveedor" integer,
  "id_producto" integer,
  "foto_url" varchar,
  "video_url" varchar,
  "stock_actual" float,
  "costo_produccion" float,
  "precio_venta" float,
  "es_oferta_excedente" boolean DEFAULT false,
  "porcentaje_descuento" float,
  "fecha_cosecha" date,
  "disponible" boolean DEFAULT true
);

CREATE TABLE "suscripciones_app" (
  "id_suscripcion_app" integer PRIMARY KEY,
  "id_usuario" integer,
  "tipo_plan" varchar,
  "tarifa_pago" float,
  "estado" varchar,
  "fecha_inicio" date,
  "fecha_fin" date,
  "renovacion_automatica" boolean DEFAULT true,
  "creada_en" timestamp
);

CREATE TABLE "pedidos" (
  "id_pedido" integer PRIMARY KEY,
  "id_usuario_cliente" integer,
  "fecha_pedido" timestamp,
  "total" float,
  "metodo_pago" varchar,
  "estado_pago" varchar,
  "estado_envio" varchar
);

CREATE TABLE "detalles_pedido" (
  "id_detalle_pedido" integer PRIMARY KEY,
  "id_pedido" integer,
  "id_inventario" integer,
  "cantidad" float,
  "precio_unitario" float,
  "subtotal" float
);

CREATE TABLE "logistica_entregas" (
  "id_entrega" integer PRIMARY KEY,
  "id_pedido" integer,
  "id_usuario_repartidor" integer,
  "ruta_optimizada" text,
  "fecha_entrega_estimada" timestamp
);

CREATE TABLE "valoraciones" (
  "id_valoracion" integer PRIMARY KEY,
  "id_pedido" integer,
  "id_usuario_cliente" integer,
  "tipo_valoracion" varchar,
  "puntuacion" integer,
  "comentario" text
);

CREATE TABLE "impacto_social" (
  "id_impacto" integer PRIMARY KEY,
  "id_proveedor" integer,
  "id_pedido" integer,
  "id_detalle_pedido" integer,
  "productos_salvados" float,
  "beneficio_extra_productor" float
);

CREATE TABLE "conversaciones" (
  "id_conversacion" integer PRIMARY KEY,
  "id_pedido" integer,
  "creada_en" timestamp
);

CREATE TABLE "conversacion_participantes" (
  "id_conversacion" integer,
  "id_usuario" integer,
  PRIMARY KEY ("id_conversacion", "id_usuario")
);

CREATE TABLE "mensajes" (
  "id_mensaje" integer PRIMARY KEY,
  "id_conversacion" integer,
  "id_emisor" integer,
  "contenido" text,
  "enviado_en" timestamp,
  "leido" boolean DEFAULT false
);

ALTER TABLE "usuarios_roles" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "usuarios_roles" ADD FOREIGN KEY ("id_rol") REFERENCES "Roles" ("id_rol") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "roles_permisos" ADD FOREIGN KEY ("id_rol") REFERENCES "Roles" ("id_rol") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "roles_permisos" ADD FOREIGN KEY ("id_permisos") REFERENCES "permisos" ("id_permiso") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "proveedores" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "productos" ADD FOREIGN KEY ("id_categoria") REFERENCES "categorias" ("id_categoria") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "productos" ADD FOREIGN KEY ("id_proveedor") REFERENCES "proveedores" ("id_proveedor") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "inventario_proveedor" ADD FOREIGN KEY ("id_proveedor") REFERENCES "proveedores" ("id_proveedor") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "inventario_proveedor" ADD FOREIGN KEY ("id_producto") REFERENCES "productos" ("id_producto") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "suscripciones_app" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pedidos" ADD FOREIGN KEY ("id_usuario_cliente") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "detalles_pedido" ADD FOREIGN KEY ("id_pedido") REFERENCES "pedidos" ("id_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "detalles_pedido" ADD FOREIGN KEY ("id_inventario") REFERENCES "inventario_proveedor" ("id_inventario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "logistica_entregas" ADD FOREIGN KEY ("id_pedido") REFERENCES "pedidos" ("id_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "logistica_entregas" ADD FOREIGN KEY ("id_usuario_repartidor") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "valoraciones" ADD FOREIGN KEY ("id_pedido") REFERENCES "pedidos" ("id_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "valoraciones" ADD FOREIGN KEY ("id_usuario_cliente") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "impacto_social" ADD FOREIGN KEY ("id_proveedor") REFERENCES "proveedores" ("id_proveedor") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "impacto_social" ADD FOREIGN KEY ("id_pedido") REFERENCES "pedidos" ("id_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "impacto_social" ADD FOREIGN KEY ("id_detalle_pedido") REFERENCES "detalles_pedido" ("id_detalle_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "conversaciones" ADD FOREIGN KEY ("id_pedido") REFERENCES "pedidos" ("id_pedido") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "conversacion_participantes" ADD FOREIGN KEY ("id_conversacion") REFERENCES "conversaciones" ("id_conversacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "conversacion_participantes" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "mensajes" ADD FOREIGN KEY ("id_conversacion") REFERENCES "conversaciones" ("id_conversacion") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "mensajes" ADD FOREIGN KEY ("id_emisor") REFERENCES "usuarios" ("id_usuario") DEFERRABLE INITIALLY IMMEDIATE;
