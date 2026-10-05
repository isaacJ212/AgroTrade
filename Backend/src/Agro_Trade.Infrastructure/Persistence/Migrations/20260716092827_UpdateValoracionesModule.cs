using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateValoracionesModule : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Los registros legacy de valoraciones no tienen id_proveedor, así que
            // se limpian antes de aplicar la nueva relación obligatoria.
            migrationBuilder.Sql("DELETE FROM valoraciones;");

            migrationBuilder.AddColumn<DateTime>(
                name: "fecha_valoracion",
                table: "valoraciones",
                type: "timestamp with time zone",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<int>(
                name: "id_proveedor",
                table: "valoraciones",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "ix_valoraciones_id_proveedor",
                table: "valoraciones",
                column: "id_proveedor");

            migrationBuilder.AddForeignKey(
                name: "fk_valoraciones_proveedores_id_proveedor",
                table: "valoraciones",
                column: "id_proveedor",
                principalTable: "proveedores",
                principalColumn: "id_proveedor",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_valoraciones_proveedores_id_proveedor",
                table: "valoraciones");

            migrationBuilder.DropIndex(
                name: "ix_valoraciones_id_proveedor",
                table: "valoraciones");

            migrationBuilder.DropColumn(
                name: "fecha_valoracion",
                table: "valoraciones");

            migrationBuilder.DropColumn(
                name: "id_proveedor",
                table: "valoraciones");
        }
    }
}
