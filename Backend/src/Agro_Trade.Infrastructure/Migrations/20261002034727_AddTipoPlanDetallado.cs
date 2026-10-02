using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddTipoPlanDetallado : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app");

            migrationBuilder.DropPrimaryKey(
                name: "pk_tipo_plan",
                table: "tipo_plan");

            migrationBuilder.RenameTable(
                name: "tipo_plan",
                newName: "tipos_planes");

            migrationBuilder.AlterColumn<decimal>(
                name: "precio",
                table: "tipos_planes",
                type: "numeric(18,2)",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "numeric");

            migrationBuilder.AlterColumn<string>(
                name: "nombre_plan",
                table: "tipos_planes",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<bool>(
                name: "is_active",
                table: "tipos_planes",
                type: "boolean",
                nullable: false,
                defaultValue: true,
                oldClrType: typeof(bool),
                oldType: "boolean");

            migrationBuilder.AlterColumn<string>(
                name: "descripcion",
                table: "tipos_planes",
                type: "character varying(500)",
                maxLength: 500,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AddColumn<string>(
                name: "beneficios",
                table: "tipos_planes",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<decimal>(
                name: "coste",
                table: "tipos_planes",
                type: "numeric(18,2)",
                nullable: false,
                defaultValue: 0m);

            migrationBuilder.AddPrimaryKey(
                name: "pk_tipos_planes",
                table: "tipos_planes",
                column: "id");

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 3, 42, 26, 723, DateTimeKind.Utc).AddTicks(4559));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 2, 47, 26, 723, DateTimeKind.Utc).AddTicks(4572));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 1, 47, 26, 723, DateTimeKind.Utc).AddTicks(4578));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 1, 3, 47, 26, 723, DateTimeKind.Utc).AddTicks(4580));

            migrationBuilder.InsertData(
                table: "tipos_planes",
                columns: new[] { "id", "beneficios", "coste", "descripcion", "is_active", "nombre_plan", "precio" },
                values: new object[,]
                {
                    { 1, "Acceso estándar, Soporte por email", 0m, "Plan gratuito con funciones básicas", true, "Básico", 0m },
                    { 2, "Prioridad en búsqueda, Soporte 24/7, Estadísticas avanzadas", 5.00m, "Plan avanzado para productores", true, "Premium", 29.99m }
                });

            migrationBuilder.AddForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app",
                column: "id_plan",
                principalTable: "tipos_planes",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "pk_tipos_planes",
                table: "tipos_planes");

            migrationBuilder.DeleteData(
                table: "tipos_planes",
                keyColumn: "id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "tipos_planes",
                keyColumn: "id",
                keyValue: 2);

            migrationBuilder.DropColumn(
                name: "beneficios",
                table: "tipos_planes");

            migrationBuilder.DropColumn(
                name: "coste",
                table: "tipos_planes");

            migrationBuilder.DropForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app");

            migrationBuilder.RenameTable(
                name: "tipos_planes",
                newName: "tipo_plan");

            migrationBuilder.AlterColumn<decimal>(
                name: "precio",
                table: "tipo_plan",
                type: "numeric",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "numeric(18,2)");

            migrationBuilder.AlterColumn<string>(
                name: "nombre_plan",
                table: "tipo_plan",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<bool>(
                name: "is_active",
                table: "tipo_plan",
                type: "boolean",
                nullable: false,
                oldClrType: typeof(bool),
                oldType: "boolean",
                oldDefaultValue: true);

            migrationBuilder.AlterColumn<string>(
                name: "descripcion",
                table: "tipo_plan",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(500)",
                oldMaxLength: 500);

            migrationBuilder.AddPrimaryKey(
                name: "pk_tipo_plan",
                table: "tipo_plan",
                column: "id");

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

            migrationBuilder.AddForeignKey(
                name: "fk_suscripciones_app_tipo_plan_id_plan",
                table: "suscripciones_app",
                column: "id_plan",
                principalTable: "tipo_plan",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
