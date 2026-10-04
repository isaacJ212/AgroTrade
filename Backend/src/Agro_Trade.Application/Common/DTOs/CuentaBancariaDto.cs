namespace Agro_Trade.Application.Common.DTOs;

public class CuentaBancariaDto
{
    public int IdCuentaBancaria { get; set; }
    public int IdBanco { get; set; }
    public string NumeroCuentaBancaria { get; set; }
    public string NombreBanco { get; set; }
    public string Titular {get; set;}
}

public record CreateCuentaBancariaDto
(
    string NumeroCuentaBancaria,
    int IdBanco,
    string Titular
    );

public record UpdateCuentaBancariaDto(
    string NumeroCuentaBancaria,
    int IdBanco,
    string Titular
);


        