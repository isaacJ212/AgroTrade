using System;
using Agro_Trade.Domain.Events;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "actividades",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    icon_type = table.Column<string>(type: "text", nullable: true),
                    icon_class = table.Column<string>(type: "text", nullable: true),
                    created_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_actividades", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "bancos",
                columns: table => new
                {
                    id_banco = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_banco = table.Column<string>(type: "text", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_bancos", x => x.id_banco);
                });

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
                name: "refresh_tokens",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_id = table.Column<int>(type: "integer", nullable: false),
                    hash = table.Column<string>(type: "text", nullable: false),
                    created_by_ip = table.Column<string>(type: "text", nullable: false),
                    expires_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    created_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    revoked_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_refresh_tokens", x => x.id);
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

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "id_rol", "nombre_rol" },
                values: new object[,]
                {
                    { 1, "Cliente" },
                    { 2, "Productor" },
                    { 3, "Repartidor" },
                    { 4, "Administrador" }
                });

            migrationBuilder.CreateTable(
                name: "tipos_planes",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_plan = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    descripcion = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    beneficios = table.Column<string>(type: "text", nullable: false),
                    precio = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    coste = table.Column<decimal>(type: "numeric(18,2)", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false, defaultValue: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tipos_planes", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "unidades_de_medida",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    codigo = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    factor = table.Column<int>(type: "integer", nullable: false),
                    id_base = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_unidades_de_medida", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "usuarios",
                columns: table => new
                {
                    id_usuario = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    primer_apellido = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    segundo_apellido = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    email = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    password_hash = table.Column<string>(type: "text", nullable: true),
                    identidad_verificada = table.Column<bool>(type: "boolean", nullable: false),
                    estado_cuenta = table.Column<string>(type: "text", nullable: false),
                    o_auth_provider = table.Column<string>(type: "text", nullable: true),
                    o_auth_provider_id = table.Column<string>(type: "text", nullable: true),
                    telefono = table.Column<string>(type: "text", nullable: true),
                    departamento = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true),
                    municipio = table.Column<string>(type: "character varying(30)", maxLength: 30, nullable: true),
                    direccion_exacta = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: true),
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
                name: "cuentas_bancarias",
                columns: table => new
                {
                    id_cuenta = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    id_banco = table.Column<int>(type: "integer", nullable: false),
                    numero_cuenta = table.Column<string>(type: "text", nullable: false),
                    created_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    titular = table.Column<string>(type: "text", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_cuentas_bancarias", x => x.id_cuenta);
                    table.ForeignKey(
                        name: "fk_cuentas_bancarias_bancos_id_banco",
                        column: x => x.id_banco,
                        principalTable: "bancos",
                        principalColumn: "id_banco",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_cuentas_bancarias_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
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
                    estado_envio = table.Column<string>(type: "text", nullable: true),
                    direccion_envio = table.Column<string>(type: "text", nullable: true),
                    latitud = table.Column<double>(type: "double precision", nullable: true),
                    longitud = table.Column<double>(type: "double precision", nullable: true)
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
                name: "solicitud_repartidor",
                columns: table => new
                {
                    id_solicitud = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    datos_repartidor = table.Column<DatosRepartidorDto>(type: "jsonb", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_solicitud = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_solicitud_repartidor", x => x.id_solicitud);
                    table.ForeignKey(
                        name: "fk_solicitud_repartidor_usuarios_id_usuario",
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
                    id_plan = table.Column<int>(type: "integer", nullable: false),
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
                        name: "fk_suscripciones_app_tipo_planes_id_plan",
                        column: x => x.id_plan,
                        principalTable: "tipos_planes",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
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
                    calificacion_promedio = table.Column<float>(type: "real", nullable: true),
                    id_cuenta_bancaria = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_proveedores", x => x.id_proveedor);
                    table.ForeignKey(
                        name: "fk_proveedores_cuentas_bancarias_id_cuenta_bancaria",
                        column: x => x.id_cuenta_bancaria,
                        principalTable: "cuentas_bancarias",
                        principalColumn: "id_cuenta",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "fk_proveedores_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "repartidor",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    placa_vehiculo = table.Column<string>(type: "text", nullable: false),
                    estado = table.Column<string>(type: "text", nullable: false),
                    vehiculo = table.Column<string>(type: "text", nullable: false),
                    promedio_calificacion = table.Column<decimal>(type: "numeric", nullable: false),
                    id_cuenta_bancaria = table.Column<int>(type: "integer", nullable: false),
                    url_foto_perfil = table.Column<string>(type: "text", nullable: false),
                    municipio = table.Column<string>(type: "text", nullable: false),
                    departamento = table.Column<string>(type: "text", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_repartidor", x => x.id);
                    table.ForeignKey(
                        name: "fk_repartidor_cuentas_bancarias_id_cuenta_bancaria",
                        column: x => x.id_cuenta_bancaria,
                        principalTable: "cuentas_bancarias",
                        principalColumn: "id_cuenta",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_repartidor_usuarios_id_usuario",
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
                name: "notificaciones_entrega",
                columns: table => new
                {
                    id_notificacion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_usuario_repartidor = table.Column<int>(type: "integer", nullable: false),
                    zona_entrega = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_notificaciones_entrega", x => x.id_notificacion);
                    table.ForeignKey(
                        name: "fk_notificaciones_entrega_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_notificaciones_entrega_usuarios_id_usuario_repartidor",
                        column: x => x.id_usuario_repartidor,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "registros_transferencia_mock",
                columns: table => new
                {
                    id_transferencia = table.Column<string>(type: "character varying(64)", maxLength: 64, nullable: false),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    proveedor = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    banco_destino = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    cuenta = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    monto_enviado = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    estado = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_registros_transferencia_mock", x => x.id_transferencia);
                    table.ForeignKey(
                        name: "fk_registros_transferencia_mock_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
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
                    activo = table.Column<bool>(type: "boolean", nullable: false),
                    descripcion = table.Column<string>(type: "text", nullable: true),
                    id_unidad_de_medida = table.Column<int>(type: "integer", nullable: false)
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
                    table.ForeignKey(
                        name: "fk_productos_unidad_de_medida_id_unidad_de_medida",
                        column: x => x.id_unidad_de_medida,
                        principalTable: "unidades_de_medida",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "valoraciones",
                columns: table => new
                {
                    id_valoracion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_usuario_cliente = table.Column<int>(type: "integer", nullable: false),
                    id_proveedor = table.Column<int>(type: "integer", nullable: false),
                    tipo_valoracion = table.Column<string>(type: "text", nullable: true),
                    puntuacion = table.Column<int>(type: "integer", nullable: false),
                    comentario = table.Column<string>(type: "text", nullable: true),
                    fecha_valoracion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    usuario_id_usuario = table.Column<int>(type: "integer", nullable: true)
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
                        name: "fk_valoraciones_proveedores_id_proveedor",
                        column: x => x.id_proveedor,
                        principalTable: "proveedores",
                        principalColumn: "id_proveedor",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_valoraciones_usuarios_id_usuario_cliente",
                        column: x => x.id_usuario_cliente,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_valoraciones_usuarios_usuario_id_usuario",
                        column: x => x.usuario_id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario");
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
                    fecha_registro = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
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

            migrationBuilder.InsertData(
                table: "actividades",
                columns: new[] { "id", "created_at", "icon_class", "icon_type", "title" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 10, 9, 4, 51, 8, 220, DateTimeKind.Utc).AddTicks(5274), "icon-green-bg", "user", "El productor 'Finca Los Pinos' se ha registrado en la plataforma" },
                    { 2, new DateTime(2026, 10, 9, 3, 56, 8, 220, DateTimeKind.Utc).AddTicks(5309), "icon-blue-bg", "check-circle", "Verificación aprobada para 'Transportes El Rápido'" },
                    { 3, new DateTime(2026, 10, 9, 2, 56, 8, 220, DateTimeKind.Utc).AddTicks(5322), "icon-orange-bg", "alert-circle", "Se ha reportado un problema con el pedido #1045" },
                    { 4, new DateTime(2026, 10, 8, 4, 56, 8, 220, DateTimeKind.Utc).AddTicks(5331), "icon-purple-bg", "layers", "Nueva categoría 'Frutas Tropicales' creada" }
                });

            migrationBuilder.InsertData(
                table: "tipos_planes",
                columns: new[] { "id", "beneficios", "coste", "descripcion", "is_active", "nombre_plan", "precio" },
                values: new object[,]
                {
                    { 1, "Acceso estándar, Soporte por email", 0m, "Plan gratuito con funciones básicas", true, "Básico", 0m },
                    { 2, "Prioridad en búsqueda, Soporte 24/7, Estadísticas avanzadas", 5.00m, "Plan avanzado para productores", true, "Premium", 29.99m }
                });

            migrationBuilder.InsertData(
                table: "unidades_de_medida",
                columns: new[] { "id", "codigo", "factor", "id_base", "nombre" },
                values: new object[,]
                {
                    { 1, "kg", 1, null, "Kilogramo" },
                    { 2, "g", 1000, 1, "Gramo" },
                    { 3, "lb", 1, null, "Libra" },
                    { 4, "qq", 1, null, "Quintal" },
                    { 5, "und", 1, null, "Unidad" },
                    { 6, "L", 1, null, "Litro" },
                    { 7, "mL", 1000, 6, "Mililitro" },
                    { 8, "dz", 1, null, "Docena" },
                    { 9, "cj", 1, null, "Caja" },
                    { 10, "t", 1, null, "Tonelada" }
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
                name: "ix_cuentas_bancarias_id_banco",
                table: "cuentas_bancarias",
                column: "id_banco");

            migrationBuilder.CreateIndex(
                name: "ix_cuentas_bancarias_id_usuario",
                table: "cuentas_bancarias",
                column: "id_usuario");

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
                column: "id_detalle_pedido",
                unique: true);

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
                column: "id_pedido",
                unique: true);

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
                name: "ix_notificaciones_entrega_id_pedido_id_usuario_repartidor",
                table: "notificaciones_entrega",
                columns: new[] { "id_pedido", "id_usuario_repartidor" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_notificaciones_entrega_id_usuario_repartidor",
                table: "notificaciones_entrega",
                column: "id_usuario_repartidor");

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
                name: "ix_productos_id_unidad_de_medida",
                table: "productos",
                column: "id_unidad_de_medida");

            migrationBuilder.CreateIndex(
                name: "ix_proveedores_id_cuenta_bancaria",
                table: "proveedores",
                column: "id_cuenta_bancaria");

            migrationBuilder.CreateIndex(
                name: "ix_proveedores_id_usuario",
                table: "proveedores",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_registros_transferencia_mock_id_pedido",
                table: "registros_transferencia_mock",
                column: "id_pedido");

            migrationBuilder.CreateIndex(
                name: "ix_repartidor_id_cuenta_bancaria",
                table: "repartidor",
                column: "id_cuenta_bancaria");

            migrationBuilder.CreateIndex(
                name: "ix_repartidor_id_usuario",
                table: "repartidor",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_roles_permisos_id_permisos",
                table: "roles_permisos",
                column: "id_permisos");

            migrationBuilder.CreateIndex(
                name: "ix_solicitud_repartidor_id_usuario",
                table: "solicitud_repartidor",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_suscripciones_app_id_plan",
                table: "suscripciones_app",
                column: "id_plan");

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
                name: "ix_valoraciones_id_proveedor",
                table: "valoraciones",
                column: "id_proveedor");

            migrationBuilder.CreateIndex(
                name: "ix_valoraciones_id_usuario_cliente",
                table: "valoraciones",
                column: "id_usuario_cliente");

            migrationBuilder.CreateIndex(
                name: "ix_valoraciones_usuario_id_usuario",
                table: "valoraciones",
                column: "usuario_id_usuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "actividades");

            migrationBuilder.DropTable(
                name: "conversacion_participantes");

            migrationBuilder.DropTable(
                name: "impacto_social");

            migrationBuilder.DropTable(
                name: "logistica_entregas");

            migrationBuilder.DropTable(
                name: "mensajes");

            migrationBuilder.DropTable(
                name: "notificaciones_entrega");

            migrationBuilder.DropTable(
                name: "refresh_tokens");

            migrationBuilder.DropTable(
                name: "registros_transferencia_mock");

            migrationBuilder.DropTable(
                name: "repartidor");

            migrationBuilder.DropTable(
                name: "roles_permisos");

            migrationBuilder.DropTable(
                name: "solicitud_repartidor");

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
                name: "tipos_planes");

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
                name: "unidades_de_medida");

            migrationBuilder.DropTable(
                name: "cuentas_bancarias");

            migrationBuilder.DropTable(
                name: "bancos");

            migrationBuilder.DropTable(
                name: "usuarios");
        }
    }
}
