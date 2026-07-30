using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class AddDeliveryNotifications : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "ix_logistica_entregas_id_pedido",
                table: "logistica_entregas");

            migrationBuilder.CreateTable(
                name: "notificaciones_entrega",
                columns: table => new
                {
                    id_notificacion = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_pedido = table.Column<int>(type: "integer", nullable: false),
                    id_usuario_repartidor = table.Column<int>(type: "integer", nullable: false),
                    zona_entrega = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_creacion = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_notificaciones_entrega", x => x.id_notificacion);
                    table.ForeignKey(
                        name: "fk_notificaciones_entrega_pedidos_id_pedido",
                        column: x => x.id_pedido,
                        principalTable: "pedidos",
                        principalColumn: "id_pedido",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "fk_notificaciones_entrega_usuarios_id_usuario_repartidor",
                        column: x => x.id_usuario_repartidor,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_logistica_entregas_id_pedido",
                table: "logistica_entregas",
                column: "id_pedido",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_notificaciones_entrega_id_pedido_id_usuario_repartidor",
                table: "notificaciones_entrega",
                columns: new[] { "id_pedido", "id_usuario_repartidor" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "ix_notificaciones_entrega_id_usuario_repartidor",
                table: "notificaciones_entrega",
                column: "id_usuario_repartidor");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "notificaciones_entrega");

            migrationBuilder.DropIndex(
                name: "ix_logistica_entregas_id_pedido",
                table: "logistica_entregas");

            migrationBuilder.CreateIndex(
                name: "ix_logistica_entregas_id_pedido",
                table: "logistica_entregas",
                column: "id_pedido");
        }
    }
}
