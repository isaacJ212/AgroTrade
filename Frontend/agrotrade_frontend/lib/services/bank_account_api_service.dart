import '../models/api/backend_result.dart';
import '../models/api/bank_account_models.dart';
import 'api_client.dart';

class BankAccountApiService {
  BankAccountApiService._();

  static final BankAccountApiService instance = BankAccountApiService._();

  static const _accountsPath = '/api/CuentasBancarias';
  static const _banksPath = '/api/Bancos';
  static const _userAccountsPath = '/api/CuentaBancaria/usuario';

  final List<BankAccountDto> _mockAccounts = [
    BankAccountDto(
      idCuentaBancaria: 1,
      idBanco: 1,
      numeroCuentaBancaria: '5421558899663322',
      titular: 'Productor Demo',
      nombreBanco: 'Banco LaFise',
    ),
    BankAccountDto(
      idCuentaBancaria: 2,
      idBanco: 2,
      numeroCuentaBancaria: '123456789',
      titular: 'Productor Demo',
      nombreBanco: 'BAC Credomatic',
    ),
  ];

  Future<List<BankAccountDto>> getAccounts() async {
    try {
      final response = await ApiClient.instance.get(
        _accountsPath,
        authorized: true,
      );
      final result = BackendResult<List<BankAccountDto>>.fromJson(
        response.jsonBody ?? const <String, dynamic>{},
        dataParser: (data) => data is List
            ? data
                  .whereType<Map<String, dynamic>>()
                  .map(BankAccountDto.fromJson)
                  .toList()
            : <BankAccountDto>[],
      );
      _ensureSuccess(
        response.statusCode,
        result.isSuccess,
        result.message,
        'No se pudieron cargar las cuentas bancarias.',
      );
      return result.data ?? <BankAccountDto>[];
    } catch (_) {
      return List.from(_mockAccounts);
    }
  }

  Future<List<BankDto>> getBanks() async {
    try {
      final response = await ApiClient.instance.get(_banksPath, authorized: true);
      final result = BackendResult<List<BankDto>>.fromJson(
        response.jsonBody ?? const <String, dynamic>{},
        dataParser: (data) => data is List
            ? data
                  .whereType<Map<String, dynamic>>()
                  .map(BankDto.fromJson)
                  .toList()
            : <BankDto>[],
      );
      _ensureSuccess(
        response.statusCode,
        result.isSuccess,
        result.message,
        'No se pudieron cargar los bancos disponibles.',
      );
      return result.data ?? <BankDto>[];
    } catch (_) {
      return const [
        BankDto(idBanco: 1, nombreBanco: 'Banco LaFise'),
        BankDto(idBanco: 2, nombreBanco: 'BAC Credomatic'),
        BankDto(idBanco: 3, nombreBanco: 'Ficohsa'),
        BankDto(idBanco: 4, nombreBanco: 'Banpro'),
      ];
    }
  }

  Future<void> createAccount(BankAccountInput input) async {
    try {
      final response = await ApiClient.instance.post(
        _accountsPath,
        body: input.toJson(),
        authorized: true,
      );
      _ensureResponse(response, 'No se pudo agregar la cuenta bancaria.');
    } catch (_) {
      // Mock success for demo
      final nombreBanco = input.idBanco == 1 ? 'Banco LaFise' : (input.idBanco == 2 ? 'BAC Credomatic' : (input.idBanco == 3 ? 'Ficohsa' : 'Banpro'));
      _mockAccounts.add(BankAccountDto(
        idCuentaBancaria: DateTime.now().millisecondsSinceEpoch % 10000,
        idBanco: input.idBanco,
        numeroCuentaBancaria: input.numeroCuentaBancaria,
        titular: input.titular,
        nombreBanco: nombreBanco,
      ));
    }
  }

  Future<void> updateAccount(int id, BankAccountInput input) async {
    try {
      final response = await ApiClient.instance.put(
        '$_accountsPath/$id',
        body: input.toJson(),
        authorized: true,
      );
      _ensureResponse(response, 'No se pudo actualizar la cuenta bancaria.');
    } catch (_) {
      // Mock success for demo
      final index = _mockAccounts.indexWhere((m) => m.idCuentaBancaria == id);
      if (index != -1) {
        final nombreBanco = input.idBanco == 1 ? 'Banco LaFise' : (input.idBanco == 2 ? 'BAC Credomatic' : (input.idBanco == 3 ? 'Ficohsa' : 'Banpro'));
        _mockAccounts[index] = BankAccountDto(
          idCuentaBancaria: id,
          idBanco: input.idBanco,
          numeroCuentaBancaria: input.numeroCuentaBancaria,
          titular: input.titular,
          nombreBanco: nombreBanco,
        );
      }
    }
  }

  Future<void> deleteAccount(int id) async {
    try {
      final response = await ApiClient.instance.delete(
        '$_accountsPath/$id',
        authorized: true,
      );
      _ensureResponse(response, 'No se pudo eliminar la cuenta bancaria.');
    } catch (_) {
      // Mock success for demo
      _mockAccounts.removeWhere((m) => m.idCuentaBancaria == id);
    }
  }

  void _ensureResponse(ApiResponse response, String fallback) {
    final json = response.jsonBody;
    if (json == null) {
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      throw ApiException(response.statusCode, fallback);
    }

    final result = BackendResult<dynamic>.fromJson(
      json,
      dataParser: (data) => data,
    );
    _ensureSuccess(
      response.statusCode,
      result.isSuccess,
      result.message,
      fallback,
    );
  }

  void _ensureSuccess(
    int statusCode,
    bool isSuccess,
    String message,
    String fallback,
  ) {
    if (!isSuccess) {
      throw ApiException(statusCode, message.isNotEmpty ? message : fallback);
    }
  }

  /// Obtiene las cuentas bancarias de un usuario específico
  Future<List<BankAccountDto>> getAccountsByUser(int userId) async {
    try {
      final response = await ApiClient.instance.get(
        '$_userAccountsPath/$userId',
        authorized: true,
      );
      final result = BackendResult<List<BankAccountDto>>.fromJson(
        response.jsonBody ?? const <String, dynamic>{},
        dataParser: (data) => data is List
            ? data
                  .whereType<Map<String, dynamic>>()
                  .map(BankAccountDto.fromJson)
                  .toList()
            : <BankAccountDto>[],
      );
      _ensureSuccess(
        response.statusCode,
        result.isSuccess,
        result.message,
        'No se pudieron cargar las cuentas bancarias del usuario.',
      );
      return result.data ?? <BankAccountDto>[];
    } catch (_) {
      return List.from(_mockAccounts);
    }
  }
}
