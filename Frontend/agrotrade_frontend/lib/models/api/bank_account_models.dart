import 'json_helpers.dart';

class BankDto {
  final int idBanco;
  final String nombreBanco;

  const BankDto({required this.idBanco, required this.nombreBanco});

  factory BankDto.fromJson(Map<String, dynamic> json) => BankDto(
    idBanco: readInt(json, const ['IdBanco', 'idBanco']) ?? 0,
    nombreBanco: readString(json, const ['NombreBanco', 'nombreBanco']) ?? '',
  );
}

class BankAccountDto {
  final int idCuentaBancaria;
  final int idBanco;
  final String numeroCuentaBancaria;
  final String nombreBanco;
  final String titular;

  const BankAccountDto({
    required this.idCuentaBancaria,
    required this.idBanco,
    required this.numeroCuentaBancaria,
    required this.nombreBanco,
    required this.titular,
  });

  factory BankAccountDto.fromJson(Map<String, dynamic> json) => BankAccountDto(
    idCuentaBancaria:
        readInt(json, const ['IdCuentaBancaria', 'idCuentaBancaria']) ?? 0,
    idBanco: readInt(json, const ['IdBanco', 'idBanco']) ?? 0,
    numeroCuentaBancaria:
        readString(json, const [
          'NumeroCuentaBancaria',
          'numeroCuentaBancaria',
        ]) ??
        '',
    nombreBanco: readString(json, const ['NombreBanco', 'nombreBanco']) ?? '',
    titular: readString(json, const ['Titular', 'titular']) ?? '',
  );
}

class BankAccountInput {
  final String numeroCuentaBancaria;
  final int idBanco;
  final String titular;

  const BankAccountInput({
    required this.numeroCuentaBancaria,
    required this.idBanco,
    required this.titular,
  });

  Map<String, dynamic> toJson() => {
    'numeroCuentaBancaria': numeroCuentaBancaria,
    'idBanco': idBanco,
    'titular': titular,
  };
}
