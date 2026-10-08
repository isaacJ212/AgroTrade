using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddUbicacionPedido : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "direccion_envio",
                table: "pedidos",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "latitud",
                table: "pedidos",
                type: "double precision",
                nullable: true);

            migrationBuilder.AddColumn<double>(
                name: "longitud",
                table: "pedidos",
                type: "double precision",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 7, 2, 0, 24, 325, DateTimeKind.Utc).AddTicks(7742));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 7, 1, 5, 24, 325, DateTimeKind.Utc).AddTicks(7753));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 7, 0, 5, 24, 325, DateTimeKind.Utc).AddTicks(7758));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 2, 5, 24, 325, DateTimeKind.Utc).AddTicks(7761));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "direccion_envio",
                table: "pedidos");

            migrationBuilder.DropColumn(
                name: "latitud",
                table: "pedidos");

            migrationBuilder.DropColumn(
                name: "longitud",
                table: "pedidos");

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 3, 43, 41, 586, DateTimeKind.Utc).AddTicks(2965));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 2, 48, 41, 586, DateTimeKind.Utc).AddTicks(2979));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 6, 1, 48, 41, 586, DateTimeKind.Utc).AddTicks(2984));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 5, 3, 48, 41, 586, DateTimeKind.Utc).AddTicks(2986));
        }
    }
}
