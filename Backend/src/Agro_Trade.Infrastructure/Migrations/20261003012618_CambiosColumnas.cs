using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class CambiosColumnas : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "is_active",
                table: "repartidor",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 1,
                column: "created_at",
                value: new DateTime(2026, 10, 3, 1, 21, 18, 149, DateTimeKind.Utc).AddTicks(8877));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 2,
                column: "created_at",
                value: new DateTime(2026, 10, 3, 0, 26, 18, 149, DateTimeKind.Utc).AddTicks(8885));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 3,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 23, 26, 18, 149, DateTimeKind.Utc).AddTicks(8892));

            migrationBuilder.UpdateData(
                table: "actividades",
                keyColumn: "id",
                keyValue: 4,
                column: "created_at",
                value: new DateTime(2026, 10, 2, 1, 26, 18, 149, DateTimeKind.Utc).AddTicks(8894));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "is_active",
                table: "repartidor");

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
        }
    }
}
