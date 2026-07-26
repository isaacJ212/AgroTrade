using System;
using Meseta_Verda.Domain.Events;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace Meseta_Verde.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class Cola_SOlicitudes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "repartidor",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    placa_vehiculo = table.Column<string>(type: "text", nullable: false),
                    estado = table.Column<string>(type: "text", nullable: false),
                    vehiculo = table.Column<string>(type: "text", nullable: false),
                    promedio_calificacion = table.Column<decimal>(type: "numeric", nullable: false),
                    cuenta_bancaria = table.Column<string>(type: "text", nullable: false),
                    url_foto_perfil = table.Column<string>(type: "text", nullable: false),
                    zona_operaciones = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_repartidor", x => x.id);
                    table.ForeignKey(
                        name: "fk_repartidor_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "solicitud_repartidor",
                columns: table => new
                {
                    id_solicitud = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    id_usuario = table.Column<int>(type: "integer", nullable: false),
                    datos_repartidor = table.Column<DatosRepartidorDto>(type: "jsonb", nullable: false),
                    estado = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    fecha_solicitud = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_solicitud_repartidor", x => x.id_solicitud);
                    table.ForeignKey(
                        name: "fk_solicitud_repartidor_usuarios_id_usuario",
                        column: x => x.id_usuario,
                        principalTable: "usuarios",
                        principalColumn: "id_usuario",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_repartidor_id_usuario",
                table: "repartidor",
                column: "id_usuario");

            migrationBuilder.CreateIndex(
                name: "ix_solicitud_repartidor_id_usuario",
                table: "solicitud_repartidor",
                column: "id_usuario");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "repartidor");

            migrationBuilder.DropTable(
                name: "solicitud_repartidor");
        }
    }
}
