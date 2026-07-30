using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddCheckoutSplitPayouts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "banco",
                table: "proveedores",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "cuenta_bancaria",
                table: "proveedores",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

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

            migrationBuilder.CreateIndex(
                name: "ix_registros_transferencia_mock_id_pedido",
                table: "registros_transferencia_mock",
                column: "id_pedido");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "registros_transferencia_mock");

            migrationBuilder.DropColumn(
                name: "banco",
                table: "proveedores");

            migrationBuilder.DropColumn(
                name: "cuenta_bancaria",
                table: "proveedores");
        }
    }
}
