using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddUnidadDeMedida : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "pk_unidad_de_medida",
                table: "unidad_de_medida");

            migrationBuilder.DropColumn(
                name: "unidad_medida",
                table: "productos");

            migrationBuilder.DropColumn(
                name: "url_foto_producto",
                table: "productos");

            migrationBuilder.RenameTable(
                name: "unidad_de_medida",
                newName: "unidades_de_medida");

            migrationBuilder.AddColumn<int>(
                name: "id_unidad_de_medida",
                table: "productos",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<string>(
                name: "nombre",
                table: "unidades_de_medida",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "codigo",
                table: "unidades_de_medida",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AddPrimaryKey(
                name: "pk_unidades_de_medida",
                table: "unidades_de_medida",
                column: "id");

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 4, 44, 28, 691, DateTimeKind.Utc).AddTicks(7271));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 3, 49, 28, 691, DateTimeKind.Utc).AddTicks(7286));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 2, 49, 28, 691, DateTimeKind.Utc).AddTicks(7292));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 5, 4, 49, 28, 691, DateTimeKind.Utc).AddTicks(7295));

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
                name: "ix_productos_id_unidad_de_medida",
                table: "productos",
                column: "id_unidad_de_medida");

            migrationBuilder.AddForeignKey(
                name: "fk_productos_unidad_de_medida_id_unidad_de_medida",
                table: "productos",
                column: "id_unidad_de_medida",
                principalTable: "unidades_de_medida",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_productos_unidad_de_medida_id_unidad_de_medida",
                table: "productos");

            migrationBuilder.DropIndex(
                name: "ix_productos_id_unidad_de_medida",
                table: "productos");

            migrationBuilder.DropPrimaryKey(
                name: "pk_unidades_de_medida",
                table: "unidades_de_medida");

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "unidades_de_medida",
                keyColumn: "id",
                keyValue: 10);

            migrationBuilder.DropColumn(
                name: "id_unidad_de_medida",
                table: "productos");

            migrationBuilder.RenameTable(
                name: "unidades_de_medida",
                newName: "unidad_de_medida");

            migrationBuilder.AddColumn<string>(
                name: "unidad_medida",
                table: "productos",
                type: "character varying(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "url_foto_producto",
                table: "productos",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AlterColumn<string>(
                name: "nombre",
                table: "unidad_de_medida",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "codigo",
                table: "unidad_de_medida",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(20)",
                oldMaxLength: 20);

            migrationBuilder.AddPrimaryKey(
                name: "pk_unidad_de_medida",
                table: "unidad_de_medida",
                column: "id");

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 5, 17, 31, 45, 338, DateTimeKind.Utc).AddTicks(8325));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 5, 16, 36, 45, 338, DateTimeKind.Utc).AddTicks(8335));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 5, 15, 36, 45, 338, DateTimeKind.Utc).AddTicks(8340));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 4, 17, 36, 45, 338, DateTimeKind.Utc).AddTicks(8343));
        }
    }
}
