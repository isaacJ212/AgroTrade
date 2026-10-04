using Agro_Trade.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Agro_Trade.Infrastructure.Migrations
{
    [DbContext(typeof(AgroTradeDbContext))]
    [Migration("20261003120000_ProveedorCuentaBancariaId")]
    public partial class ProveedorCuentaBancariaId : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "id_cuenta_bancaria",
                table: "proveedores",
                type: "integer",
                nullable: true);

            migrationBuilder.Sql("""
                WITH coincidencias AS (
                    SELECT p.id_proveedor, MIN(cb.id_cuenta) AS id_cuenta
                    FROM proveedores p
                    INNER JOIN cuenta_bancaria cb ON cb.id_usuario = p.id_usuario
                    INNER JOIN banco b ON b.id_banco = cb.id_banco
                                        WHERE LOWER(BTRIM(p.banco)) = LOWER(BTRIM(b.nombre_banco))
                                            AND REGEXP_REPLACE(BTRIM(p.cuenta_bancaria), '\s', '', 'g') =
                                                    REGEXP_REPLACE(BTRIM(cb.numero_cuenta), '\s', '', 'g')
                    GROUP BY p.id_proveedor
                    HAVING COUNT(*) = 1
                )
                UPDATE proveedores p
                SET id_cuenta_bancaria = coincidencias.id_cuenta
                FROM coincidencias
                WHERE p.id_proveedor = coincidencias.id_proveedor;
                """);

            migrationBuilder.DropColumn(name: "banco", table: "proveedores");
            migrationBuilder.DropColumn(name: "cuenta_bancaria", table: "proveedores");

            migrationBuilder.CreateIndex(
                name: "ix_proveedores_id_cuenta_bancaria",
                table: "proveedores",
                column: "id_cuenta_bancaria");

            migrationBuilder.AddForeignKey(
                name: "fk_proveedores_cuenta_bancaria_id_cuenta_bancaria",
                table: "proveedores",
                column: "id_cuenta_bancaria",
                principalTable: "cuenta_bancaria",
                principalColumn: "id_cuenta",
                onDelete: ReferentialAction.Restrict);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "fk_proveedores_cuenta_bancaria_id_cuenta_bancaria",
                table: "proveedores");

            migrationBuilder.DropIndex(
                name: "ix_proveedores_id_cuenta_bancaria",
                table: "proveedores");

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

            migrationBuilder.Sql("""
                UPDATE proveedores p
                SET banco = b.nombre_banco,
                    cuenta_bancaria = cb.numero_cuenta
                FROM cuenta_bancaria cb
                INNER JOIN banco b ON b.id_banco = cb.id_banco
                WHERE p.id_cuenta_bancaria = cb.id_cuenta;
                """);

            migrationBuilder.DropColumn(name: "id_cuenta_bancaria", table: "proveedores");
        }
    }
}