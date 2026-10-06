using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddImpactoSocialNavigationAndFechaRegistro : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_impacto_social_id_detalle_pedido",
                table: "impacto_social");

            // migrationBuilder.AddColumn<DateTime>(
            //     name: "fecha_registro",
            //     table: "impacto_social",
            //     type: "timestamp with time zone",
            //     nullable: false,
            //     defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "ix_impacto_social_id_detalle_pedido",
                table: "impacto_social",
                column: "id_detalle_pedido",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_impacto_social_id_detalle_pedido",
                table: "impacto_social");

            migrationBuilder.DropColumn(
                name: "fecha_registro",
                table: "impacto_social");

            migrationBuilder.CreateIndex(
                name: "ix_impacto_social_id_detalle_pedido",
                table: "impacto_social",
                column: "id_detalle_pedido");
        }
    }
}
