using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class BancoAndCuentaBancaria : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "tipo_plan",
                table: "suscripciones_app");

            migrationBuilder.DropColumn(
                name: "cuenta_bancaria",
                table: "repartidor");

            migrationBuilder.RenameColumn(
                name: "zona_operaciones",
                table: "repartidor",
                newName: "municipio");

            migrationBuilder.AddColumn<int>(
                name: "id_tipo_plan",
                table: "suscripciones_app",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "id_cuenta_bancaria",
                table: "repartidor",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "url_foto_producto",
                table: "productos",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "banco",
                columns: table => new
                {
                    id_banco = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_banco = table.Column<string>(type: "text", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_banco", x => x.id_banco);
                });

            migrationBuilder.CreateTable(
                name: "tipo_plan",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_plan = table.Column<string>(type: "text", nullable: false),
                    precio = table.Column<decimal>(type: "numeric", nullable: false),
                    descripcion = table.Column<string>(type: "text", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tipo_plan", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "unidad_de_medida",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre = table.Column<string>(type: "text", nullable: false),
                    codigo = table.Column<string>(type: "text", nullable: false),
                    factor = table.Column<int>(type: "integer", nullable: false),
                    id_base = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_unidad_de_medida", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "cuenta_bancaria",
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
                    table.PrimaryKey("pk_cuenta_bancaria", x => x.id_cuenta);
                    table.ForeignKey(
                        name: "fk_cuenta_bancaria_banco_id_banco",
                        column: x => x.id_banco,
                        principalTable: "banco",
                        principalColumn: "id_banco",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_cuenta_bancaria_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 16, 38, 46, 671, DateTimeKind.Utc).AddTicks(6657));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 15, 43, 46, 671, DateTimeKind.Utc).AddTicks(6666));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 14, 43, 46, 671, DateTimeKind.Utc).AddTicks(6671));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 1, 16, 43, 46, 671, DateTimeKind.Utc).AddTicks(6673));

            migrationBuilder.CreateIndex(
                name: "ix_suscripciones_app_id_tipo_plan",
                table: "suscripciones_app",
                column: "id_tipo_plan");

            migrationBuilder.CreateIndex(
                name: "ix_repartidor_id_cuenta_bancaria",
                table: "repartidor",
                column: "id_cuenta_bancaria");

            migrationBuilder.CreateIndex(
                name: "ix_cuenta_bancaria_id_banco",
                table: "cuenta_bancaria",
                column: "id_banco");

            migrationBuilder.CreateIndex(
                name: "ix_cuenta_bancaria_id_usuario",
                table: "cuenta_bancaria",
                column: "id_usuario");

            migrationBuilder.AddForeignKey(
                name: "fk_repartidor_cuenta_bancaria_id_cuenta_bancaria",
                table: "repartidor",
                column: "id_cuenta_bancaria",
                principalTable: "cuenta_bancaria",
                principalColumn: "id_cuenta",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_tipo_plan",
                table: "suscripciones_app",
                column: "id_tipo_plan",
                principalTable: "tipo_plan",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_repartidor_cuenta_bancaria_id_cuenta_bancaria",
                table: "repartidor");

            migrationBuilder.DropForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_tipo_plan",
                table: "suscripciones_app");

            migrationBuilder.DropTable(
                name: "cuenta_bancaria");

            migrationBuilder.DropTable(
                name: "tipo_plan");

            migrationBuilder.DropTable(
                name: "unidad_de_medida");

            migrationBuilder.DropTable(
                name: "banco");

            migrationBuilder.DropIndex(
                name: "ix_suscripciones_app_id_tipo_plan",
                table: "suscripciones_app");

            migrationBuilder.DropIndex(
                name: "ix_repartidor_id_cuenta_bancaria",
                table: "repartidor");

            migrationBuilder.DropColumn(
                name: "id_tipo_plan",
                table: "suscripciones_app");

            migrationBuilder.DropColumn(
                name: "id_cuenta_bancaria",
                table: "repartidor");

            migrationBuilder.DropColumn(
                name: "url_foto_producto",
                table: "productos");

            migrationBuilder.RenameColumn(
                name: "municipio",
                table: "repartidor",
                newName: "zona_operaciones");

            migrationBuilder.AddColumn<string>(
                name: "tipo_plan",
                table: "suscripciones_app",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "cuenta_bancaria",
                table: "repartidor",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 9, 29, 3, 13, 30, 558, DateTimeKind.Utc).AddTicks(3548));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 9, 29, 2, 18, 30, 558, DateTimeKind.Utc).AddTicks(3557));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 9, 29, 1, 18, 30, 558, DateTimeKind.Utc).AddTicks(3561));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 9, 28, 3, 18, 30, 558, DateTimeKind.Utc).AddTicks(3562));
        }
    }
}
