# Módulo de Bancos y Cuentas Bancarias

## Resumen
Módulo para gestión de cuentas bancarias de usuarios. Permite listar bancos disponibles, y CRUD completo de cuentas bancarias asociadas al usuario autenticado.

---

## Endpoints (Backend - ASP.NET Core)

### Bancos
| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/api/Bancos` | Lista todos los bancos disponibles |

### Cuentas Bancarias
| Método | Ruta | Descripción |
|--------|------|-------------|
| `GET` | `/api/CuentasBancarias` | Lista cuentas del usuario autenticado |
| `GET` | `/api/CuentasBancarias/{id}` | Obtiene una cuenta por ID (del usuario autenticado) |
| `POST` | `/api/CuentasBancarias` | Crea una nueva cuenta bancaria |
| `PUT` | `/api/CuentasBancarias/{id}` | Actualiza una cuenta bancaria existente |
| `DELETE` | `/api/CuentasBancarias/{id}` | Elimina una cuenta bancaria |

> **Autenticación:** Todos los endpoints requieren JWT válido (`[Authorize]`). El `userId` se extrae del token.

---

## Modelos (DTOs)

### Backend (C#)

```csharp
// Bancos
public class BancoDto
{
    public int IdBanco { get; set; }
    public string NombreBanco { get; set; }
}

// Cuentas Bancarias
public class CuentaBancariaDto
{
    public int IdCuentaBancaria { get; set; }
    public int IdBanco { get; set; }
    public string NumeroCuentaBancaria { get; set; }
    public string NombreBanco { get; set; }
    public string Titular { get; set; }
}

public record CreateCuentaBancariaDto(
    string NumeroCuentaBancaria,
    int IdBanco,
    string Titular
);

public record UpdateCuentaBancariaDto(
    string NumeroCuentaBancaria,
    int IdBanco,
    string Titular
);
```

### Frontend (Dart/Flutter)

```dart
// Bancos
class BankDto {
  final int idBanco;
  final String nombreBanco;
}

// Cuentas Bancarias
class BankAccountDto {
  final int idCuentaBancaria;
  final int idBanco;
  final String numeroCuentaBancaria;
  final String nombreBanco;
  final String titular;
}

// Input para crear/actualizar
class BankAccountInput {
  final String numeroCuentaBancaria;
  final int idBanco;
  final String titular;

  Map<String, dynamic> toJson() => {
    'numeroCuentaBancaria': numeroCuentaBancaria,
    'idBanco': idBanco,
    'titular': titular,
  };
}
```

---

## Uso en Frontend

### Servicio: `BankAccountApiService` (Singleton)

```dart
final service = BankAccountApiService.instance;

// Obtener cuentas del usuario
List<BankAccountDto> accounts = await service.getAccounts();

// Obtener lista de bancos
List<BankDto> banks = await service.getBanks();

// Crear cuenta
await service.createAccount(BankAccountInput(
  numeroCuentaBancaria: '1234567890',
  idBanco: 1,
  titular: 'Juan Pérez',
));

// Actualizar cuenta
await service.updateAccount(accountId, BankAccountInput(...));

// Eliminar cuenta
await service.deleteAccount(accountId);
```

### Pantalla: `BankAccountsScreen`
- Lista cuentas con número enmascarado (•••• 1234)
- Acciones: Agregar, Editar, Eliminar (con confirmación)
- Pull-to-refresh para recargar
- Estados vacíos y de error manejados

---

## Flujo Típico

1. Usuario abre "Cuentas bancarias" → `GET /api/CuentasBancarias`
2. Para agregar: `GET /api/Bancos` → muestra dropdown → `POST /api/CuentasBancarias`
3. Editar: `PUT /api/CuentasBancarias/{id}`
4. Eliminar: `DELETE /api/CuentasBancarias/{id}` (con confirmación UI)