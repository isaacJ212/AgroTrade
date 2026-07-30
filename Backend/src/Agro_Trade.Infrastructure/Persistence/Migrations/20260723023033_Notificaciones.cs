using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Notificaciones : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "departamento",
                table: "usuarios",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "departamento",
                table: "repartidor",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "departamento",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "departamento",
                table: "repartidor");
        }
    }
}
