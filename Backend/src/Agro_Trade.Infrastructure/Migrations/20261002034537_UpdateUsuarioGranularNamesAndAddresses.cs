using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUsuarioGranularNamesAndAddresses : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "direccion_base",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "nombre_completo",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "tipo_plan",
                table: "suscripciones_app");

            migrationBuilder.AlterColumn<string>(
                name: "departamento",
                table: "usuarios",
                type: "character varying(30)",
                maxLength: 30,
                nullable: true,
                oldClrType: typeof(string),
                oldType: "text",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "direccion_exacta",
                table: "usuarios",
                type: "character varying(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "municipio",
                table: "usuarios",
                type: "character varying(30)",
                maxLength: 30,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "nombre",
                table: "usuarios",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "primer_apellido",
                table: "usuarios",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "segundo_apellido",
                table: "usuarios",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "id_plan",
                table: "suscripciones_app",
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

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 3, 40, 36, 589, DateTimeKind.Utc).AddTicks(797));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 2, 45, 36, 589, DateTimeKind.Utc).AddTicks(809));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 1, 45, 36, 589, DateTimeKind.Utc).AddTicks(814));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 1, 3, 45, 36, 589, DateTimeKind.Utc).AddTicks(816));

            migrationBuilder.CreateIndex(
                name: "ix_suscripciones_app_id_plan",
                table: "suscripciones_app",
                column: "id_plan");

            migrationBuilder.Sql("INSERT INTO tipo_plan (id, nombre_plan, precio, descripcion, is_active) VALUES (0, 'Legacy', 0, 'Legacy', true);");

            migrationBuilder.AddForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app",
                column: "id_plan",
                principalTable: "tipo_plan",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app");

            migrationBuilder.DropTable(
                name: "tipo_plan");

            migrationBuilder.DropTable(
                name: "unidad_de_medida");

            migrationBuilder.DropIndex(
                name: "ix_suscripciones_app_id_plan",
                table: "suscripciones_app");

            migrationBuilder.DropColumn(
                name: "direccion_exacta",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "municipio",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "nombre",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "primer_apellido",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "segundo_apellido",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "id_plan",
                table: "suscripciones_app");

            migrationBuilder.DropColumn(
                name: "url_foto_producto",
                table: "productos");

            migrationBuilder.AlterColumn<string>(
                name: "departamento",
                table: "usuarios",
                type: "text",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "character varying(30)",
                oldMaxLength: 30,
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "direccion_base",
                table: "usuarios",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "nombre_completo",
                table: "usuarios",
                type: "character varying(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "tipo_plan",
                table: "suscripciones_app",
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
