using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class MigracionInicial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categorias",
                columns: table => new
                {
                    id_categoria = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_categorias", x => x.id_categoria);
                });

            migrationBuilder.CreateTable(
                name: "permisos",
                columns: table => new
                {
                    id_permiso = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_permiso = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_permisos", x => x.id_permiso);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    id_rol = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_rol = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_roles", x => x.id_rol);
                });

            migrationBuilder.CreateTable(
                name: "usuarios",
                columns: table => new
                {
                    id_usuario = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_completo = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    email = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    password_hash = table.Column<string>(type: "text", nullable: false),
                    identidad_verificada = table.Column<bool>(type: "boolean", nullable: false),
                    o_auth_provider = table.Column<string>(type: "text", nullable: true),
                    o_auth_provider_id = table.Column<string>(type: "text", nullable: true),
                    telefono = table.Column<string>(type: "text", nullable: true),
                    direccion_base = table.Column<string>(type: "text", nullable: true),
                    fecha_registro = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_usuarios", x => x.id_usuario);
                });

            migrationBuilder.CreateTable(
                name: "roles_permisos",
                columns: table => new
                {
                    id_rol = table.Column<int>(type: "integer", nullable: false),
                    id_permisos = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_roles_permisos", x => new { x.id_rol, x.id_permisos });
                    table.ForeignKey(
                        name: "fk_roles_permisos_permisos_id_permisos",
                        column: x => x.id_permisos,
                        principalTable: "permisos",
                        principalColumn: "id_permiso",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_roles_permisos_roles_id_rol",
                        column: x => x.id_rol,
                        principalTable: "Roles",
                        principalColumn: "id_rol",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "pedidos",
                columns: table => new
                {
                    id_pedido = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario_cliente = table.Column<int>(type: "integer", nullable: false),
                    fecha_pedido = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    total = table.Column<decimal>(type: "numeric", nullable: false),
                    metodo_pago = table.Column<string>(type: "text", nullable: true),
                    estado_pago = table.Column<string>(type: "text", nullable: true),
                    estado_envio = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_pedidos", x => x.id_pedido);
                    table.ForeignKey(
                        name: "fk_pedidos_usuarios_id_usuario_cliente",
                        column: x => x.id_usuario_cliente,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "proveedores",
                columns: table => new
                {
                    id_proveedor = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    nombre_proveedor = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    nombre_finca = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: true),
                    ubicacion_gps = table.Column<string>(type: "text", nullable: true),
                    biografia = table.Column<string>(type: "text", nullable: true),
                    calificacion_promedio = table.Column<float>(type: "real", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_proveedores", x => x.id_proveedor);
                    table.ForeignKey(
                        name: "fk_proveedores_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "suscripciones_app",
                columns: table => new
                {
                    id_suscripcion_app = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    tipo_plan = table.Column<string>(type: "text", nullable: false),
                    tarifa_pago = table.Column<decimal>(type: "numeric", nullable: false),
                    estado = table.Column<string>(type: "text", nullable: true),
                    fecha_inicio = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    fecha_fin = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    renovacion_automatica = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true),
                    creada_en = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_suscripciones_app", x => x.id_suscripcion_app);
                    table.ForeignKey(
                        name: "fk_suscripciones_app_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "usuarios_roles",
                columns: table => new
                {
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    id_rol = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_usuarios_roles", x => new { x.id_usuario, x.id_rol });
                    table.ForeignKey(
                        name: "fk_usuarios_roles_roles_id_rol",
                        column: x => x.id_rol,
                        principalTable: "Roles",
                        principalColumn: "id_rol",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_usuarios_roles_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "conversaciones",
                columns: table => new
                {
                    id_conversacion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    creada_en = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_conversaciones", x => x.id_conversacion);
                    table.ForeignKey(
                        name: "fk_conversaciones_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "logistica_entregas",
                columns: table => new
                {
                    id_entrega = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_usuario_repartidor = table.Column<int>(type: "integer", nullable: false),
                    estado_actual = table.Column<string>(type: "text", nullable: true),
                    ubicacion_actual = table.Column<string>(type: "text", nullable: true),
                    fecha_estimada = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    fecha_entrega_real = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_logistica_entregas", x => x.id_entrega);
                    table.ForeignKey(
                        name: "fk_logistica_entregas_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_logistica_entregas_usuarios_id_usuario_repartidor",
                        column: x => x.id_usuario_repartidor,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "valoraciones",
                columns: table => new
                {
                    id_valoracion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_usuario_cliente = table.Column<int>(type: "integer", nullable: false),
                    tipo_valoracion = table.Column<string>(type: "text", nullable: true),
                    puntuacion = table.Column<int>(type: "integer", nullable: false),
                    comentario = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_valoraciones", x => x.id_valoracion);
                    table.ForeignKey(
                        name: "fk_valoraciones_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_valoraciones_usuarios_id_usuario_cliente",
                        column: x => x.id_usuario_cliente,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "productos",
                columns: table => new
                {
                    id_producto = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_categoria = table.Column<int>(type: "integer", nullable: false),
                    id_proveedor = table.Column<int>(type: "integer", nullable: false),
                    nombre = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    descripcion = table.Column<string>(type: "text", nullable: true),
                    unidad_medida = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_productos", x => x.id_producto);
                    table.ForeignKey(
                        name: "fk_productos_categorias_id_categoria",
                        column: x => x.id_categoria,
                        principalTable: "categorias",
                        principalColumn: "id_categoria",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_productos_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "conversacion_participantes",
                columns: table => new
                {
                    id_conversacion = table.Column<int>(type: "integer", nullable: false),
                    id_usuario = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_conversacion_participantes", x => new { x.id_conversacion, x.id_usuario });
                    table.ForeignKey(
                        name: "fk_conversacion_participantes_conversaciones_id_conversacion",
                        column: x => x.id_conversacion,
                        principalTable: "conversaciones",
                        principalColumn: "id_conversacion",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_conversacion_participantes_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "mensajes",
                columns: table => new
                {
                    id_mensaje = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_conversacion = table.Column<int>(type: "integer", nullable: false),
                    id_emisor = table.Column<int>(type: "integer", nullable: false),
                    contenido = table.Column<string>(type: "text", nullable: false),
                    enviado_en = table.Column<DateTime>(type: "timestamp with time zone", nullable: false, defaultValueSql: "now()"),
                    leido = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_mensajes", x => x.id_mensaje);
                    table.ForeignKey(
                        name: "fk_mensajes_conversaciones_id_conversacion",
                        column: x => x.id_conversacion,
                        principalTable: "conversaciones",
                        principalColumn: "id_conversacion",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_mensajes_usuarios_id_emisor",
                        column: x => x.id_emisor,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "inventario_proveedor",
                columns: table => new
                {
                    id_inventario = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_proveedor = table.Column<int>(type: "integer", nullable: false),
                    id_producto = table.Column<int>(type: "integer", nullable: false),
                    foto_url = table.Column<string>(type: "text", nullable: true),
                    video_url = table.Column<string>(type: "text", nullable: true),
                    stock_actual = table.Column<float>(type: "real", nullable: false),
                    costo_produccion = table.Column<decimal>(type: "numeric", nullable: false),
                    precio_venta = table.Column<decimal>(type: "numeric", nullable: false),
                    es_oferta_excedente = table.Column<bool>(type: "boolean", nullable: false, defaultValue: false),
                    porcentaje_descuento = table.Column<float>(type: "real", nullable: true),
                    fecha_cosecha = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    disponible = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_inventario_proveedor", x => x.id_inventario);
                    table.ForeignKey(
                        name: "fk_inventario_proveedor_productos_id_producto",
                        column: x => x.id_producto,
                        principalTable: "productos",
                        principalColumn: "id_producto",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_inventario_proveedor_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "detalles_pedido",
                columns: table => new
                {
                    id_detalle_pedido = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_inventario = table.Column<int>(type: "integer", nullable: false),
                    cantidad = table.Column<float>(type: "real", nullable: false),
                    precio_unitario = table.Column<float>(type: "real", nullable: false),
                    subtotal = table.Column<decimal>(type: "numeric", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_detalles_pedido", x => x.id_detalle_pedido);
                    table.ForeignKey(
                        name: "fk_detalles_pedido_inventario_proveedor_id_inventario",
                        column: x => x.id_inventario,
                        principalTable: "inventario_proveedor",
                        principalColumn: "id_inventario",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_detalles_pedido_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "impacto_social",
                columns: table => new
                {
                    id_impacto = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_proveedor = table.Column<int>(type: "integer", nullable: false),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_detalle_pedido = table.Column<int>(type: "integer", nullable: false),
                    productos_salvados = table.Column<float>(type: "real", nullable: false),
                    beneficio_extra_productor = table.Column<float>(type: "real", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_impacto_social", x => x.id_impacto);
                    table.ForeignKey(
                        name: "fk_impacto_social_detalles_pedido_id_detalle_pedido",
                        column: x => x.id_detalle_pedido,
                        principalTable: "detalles_pedido",
                        principalColumn: "id_detalle_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_impacto_social_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_impacto_social_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_conversacion_participantes_id_usuario",
                table: "conversacion_participantes",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_conversaciones_id_pedido",
                table: "conversaciones",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_detalles_pedido_id_inventario",
                table: "detalles_pedido",
                column: "id_inventario");

            migrationBuilder.CreateIndex(
                name: "ix_detalles_pedido_id_pedido",
                table: "detalles_pedido",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_impacto_social_id_detalle_pedido",
                table: "impacto_social",
                column: "id_detalle_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_impacto_social_id_pedido",
                table: "impacto_social",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_impacto_social_id_proveedor",
                table: "impacto_social",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_inventario_proveedor_id_producto",
                table: "inventario_proveedor",
                column: "id_producto");

            migrationBuilder.CreateIndex(
                name: "ix_inventario_proveedor_id_proveedor",
                table: "inventario_proveedor",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_logistica_entregas_id_pedido",
                table: "logistica_entregas",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_logistica_entregas_id_usuario_repartidor",
                table: "logistica_entregas",
                column: "id_usuario_repartidor");

            migrationBuilder.CreateIndex(
                name: "ix_mensajes_id_conversacion",
                table: "mensajes",
                column: "id_conversacion");

            migrationBuilder.CreateIndex(
                name: "ix_mensajes_id_emisor",
                table: "mensajes",
                column: "id_emisor");

            migrationBuilder.CreateIndex(
                name: "ix_pedidos_id_usuario_cliente",
                table: "pedidos",
                column: "id_usuario_cliente");

            migrationBuilder.CreateIndex(
                name: "ix_productos_id_categoria",
                table: "productos",
                column: "id_categoria");

            migrationBuilder.CreateIndex(
                name: "ix_productos_id_proveedor",
                table: "productos",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_proveedores_id_usuario",
                table: "proveedores",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_roles_permisos_id_permisos",
                table: "roles_permisos",
                column: "id_permisos");

            migrationBuilder.CreateIndex(
                name: "ix_suscripciones_app_id_usuario",
                table: "suscripciones_app",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_usuarios_email",
                table: "usuarios",
                column: "email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_usuarios_roles_id_rol",
                table: "usuarios_roles",
                column: "id_rol");

            migrationBuilder.CreateIndex(
                name: "ix_valoraciones_id_pedido",
                table: "valoraciones",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_valoraciones_id_usuario_cliente",
                table: "valoraciones",
                column: "id_usuario_cliente");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "conversacion_participantes");

            migrationBuilder.DropTable(
                name: "impacto_social");

            migrationBuilder.DropTable(
                name: "logistica_entregas");

            migrationBuilder.DropTable(
                name: "mensajes");

            migrationBuilder.DropTable(
                name: "roles_permisos");

            migrationBuilder.DropTable(
                name: "suscripciones_app");

            migrationBuilder.DropTable(
                name: "usuarios_roles");

            migrationBuilder.DropTable(
                name: "valoraciones");

            migrationBuilder.DropTable(
                name: "detalles_pedido");

            migrationBuilder.DropTable(
                name: "conversaciones");

            migrationBuilder.DropTable(
                name: "permisos");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "inventario_proveedor");

            migrationBuilder.DropTable(
                name: "pedidos");

            migrationBuilder.DropTable(
                name: "productos");

            migrationBuilder.DropTable(
                name: "categorias");

            migrationBuilder.DropTable(
                name: "proveedores");

            migrationBuilder.DropTable(
                name: "usuarios");
        }
    }
}
