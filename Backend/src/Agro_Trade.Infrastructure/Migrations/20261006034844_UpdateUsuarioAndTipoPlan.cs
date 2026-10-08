using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Agro_Trade.Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class UpdateUsuarioAndTipoPlan : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "nombre_completo",
                table: "usuarios");

            migrationBuilder.AddColumn<string>(
                name: "apellidos",
                table: "usuarios",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "estado_cuenta",
                table: "usuarios",
                type: "text",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "municipio",
                table: "usuarios",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "nombres",
                table: "usuarios",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "activo",
                table: "productos",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.CreateTable(
                name: "actividades",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    icon_type = table.Column<string>(type: "text", nullable: true),
                    icon_class = table.Column<string>(type: "text", nullable: true),
                    created_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_actividades", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "tipo_planes",
                columns: table => new
                {
                    id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    nombre_plan = table.Column<string>(type: "text", nullable: false),
                    descripcion = table.Column<string>(type: "text", nullable: true),
                    beneficios = table.Column<string>(type: "text", nullable: false),
                    precio = table.Column<decimal>(type: "numeric", nullable: false),
                    coste = table.Column<decimal>(type: "numeric", nullable: false),
                    is_active = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_tipo_planes", x => x.id);
                });

            migrationBuilder.InsertData(
                table: "actividades",
                columns: new[] { "id", "created_at", "icon_class", "icon_type", "title" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 10, 6, 3, 43, 41, 586, DateTimeKind.Utc).AddTicks(2965), "icon-green-bg", "user", "El productor 'Finca Los Pinos' se ha registrado en la plataforma" },
                    { 2, new DateTime(2026, 10, 6, 2, 48, 41, 586, DateTimeKind.Utc).AddTicks(2979), "icon-blue-bg", "check-circle", "Verificación aprobada para 'Transportes El Rápido'" },
                    { 3, new DateTime(2026, 10, 6, 1, 48, 41, 586, DateTimeKind.Utc).AddTicks(2984), "icon-orange-bg", "alert-circle", "Se ha reportado un problema con el pedido #1045" },
                    { 4, new DateTime(2026, 10, 5, 3, 48, 41, 586, DateTimeKind.Utc).AddTicks(2986), "icon-purple-bg", "layers", "Nueva categoría 'Frutas Tropicales' creada" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "actividades");

            migrationBuilder.DropTable(
                name: "tipo_planes");

            migrationBuilder.DropColumn(
                name: "apellidos",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "estado_cuenta",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "municipio",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "nombres",
                table: "usuarios");

            migrationBuilder.DropColumn(
                name: "activo",
                table: "productos");

            migrationBuilder.AddColumn<string>(
                name: "nombre_completo",
                table: "usuarios",
                type: "character varying(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");
        }
    }
}
