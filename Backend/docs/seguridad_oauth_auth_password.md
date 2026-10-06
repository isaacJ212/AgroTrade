# Seguridad: OAuth, Autenticación y Contraseñas

> **Alcance**: Este documento cubre los flujos implementados en el código actual:
> - Inicio de sesión con Google OAuth (`POST /api/auth/google-signin`)
> - Autenticación tradicional email/contraseña (`POST /api/auth/login`)
> - Registro y verificación OTP de cuenta (`POST /api/users` + `POST /api/auth/verify-code`)
> - Completar información de perfil OAuth (`PUT /api/auth/complete-info`)
> - Envío, verificación OTP y restablecimiento de contraseña desde `UsersController` (`POST /api/users/password/*`)

---

## 1. Componentes Revisados

| Capa | Archivos / Clases Principales |
|------|------------------------------|
| **Controladores** | `AuthController.cs`, `UsersController.cs` |
| **Handlers (CQRS)** | `GoogleSignInHandler.cs`, `LoginHandler.cs`, `VerifyCodeHandler.cs`, `GoogleSignInCaptureDataHandler.cs`, `AddUserHandler.cs`, `SendChangePasswordCodeHandler.cs`, `VerifyChangePasswordOtpHandler.cs`, `ResetPasswordAfterOtpHandler.cs` |
| **Servicios de Infraestructura** | `TokenServices.cs` (JWT), `SmtpEmailService.cs` (correo), `InMemoryVerificationCodeRepository.cs` (códigos de registro), `IMemoryCache` (códigos de cambio de contraseña) |
| **DTOs** | `OAuthSignInDto`, `LoginDto`, `LoginResponse`, `VerifyCodeDto`, `GoogleCatchDataDto`, `CreateUserDto`, `VerifyChangePasswordOtpDto`, `ResetPasswordAfterOtpDto` |
| **Configuración** | `Program.cs` (JWT Bearer, CORS, Swagger), `appsettings.json` (claves Google, JWT, Gmail SMTP) |
| **Entidades** | `Usuario.cs` (campos: `OAuthProvider`, `OAuthProviderId`, `IdentidadVerificada`, `PasswordHash`, `Departamento`, `DireccionBase`, `Telefono`) |

---

## 2. Descripción de Flujos

### 2.1 Google Sign-In (`POST /api/auth/google-signin`)

| Paso | Descripción |
|------|-------------|
| 1. Cliente envía `idToken` de Google | El frontend obtiene el `idToken` tras el consentimiento del usuario en Google. |
| 2. Backend valida `idToken` | `GoogleJsonWebSignature.ValidateAsync(idToken, ValidationSettings { Audience = [Google:ClientId] })`. Verifica firma, audiencia (`aud`), expiración (`exp`), emisor (`iss`). |
| 3. Buscar/crear usuario | Busca por `payload.Email`. Si no existe, crea `Usuario` con `OAuthProvider="Google"`, `OAuthProviderId=payload.Subject`, `IdentidadVerificada=false`. |
| 4. Asignar rol | Si `dto.idRol` no viene, asigna rol por defecto `IdRol=1` (Cliente). |
| 5. Generar JWT propio | `TokenServices.GenerateTokenAsync(usuario)` → JWT firmado con `Jwt:Key`, expiración 1 día, claims: `sub` (userId), `email`, `name`, `jti`, `role[]`. |
| 6. Respuesta | `LoginResponse { Token, UserName, Roles[], RequiereCompletarInformacion }`. `RequiereCompletarInformacion=true` si faltan `Departamento`, `DireccionBase` o `Telefono`. |

> **Distinción clave**: El `idToken` de Google se usa **solo** para el intercambio inicial en `/google-signin`. El JWT de AgroTrade es el token de sesión propio que debe usarse como Bearer en endpoints protegidos.

### 2.2 Login Tradicional (`POST /api/auth/login`)

| Paso | Descripción |
|------|-------------|
| 1. Cliente envía `email` + `password` | Validación `[EmailAddress]`, `[Required]`. |
| 2. Backend busca usuario por email | `UserRepository.GetByEmailAsync`. |
| 3. Verifica hash | `BCrypt.Net.BCrypt.Verify(password, user.PasswordHash)`. |
| 4. Genera JWT propio | Mismo proceso que en Google Sign-In. |
| 5. Devuelve `LoginResponse` | Incluye `Token`, `UserName`, `Roles[]`. |

### 2.3 Registro Tradicional + Verificación OTP (`POST /api/users` → `POST /api/auth/verify-code`)

**Diseño orientado a seguridad**: El flujo de verificación de cuenta implementa múltiples controles para garantizar que solo el propietario del email pueda activar la cuenta.

| Paso | Descripción | Control de Seguridad |
|------|-------------|---------------------|
| 1. Cliente envía `CreateUserDto` | `NombreCompleto` (min 15), `Email`, `Password` (min 6), campos opcionales. | Validación DataAnnotations + unicidad de email. |
| 2. Backend crea `Usuario` | `IdentidadVerificada=false`, `PasswordHash=BCrypt.Hash(password)`, `FechaRegistro=UtcNow`. | Hash BCrypt (work factor 11), cuenta inactiva hasta verificación. |
| 3. Genera código 6 dígitos | `RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6")` — **CSPRNG criptográficamente seguro**. | Entropía criptográfica, impredecible. |
| 4. Guarda código con expiración | `IVerificationCodeRepository.SaveCodeAsync(userId, code, 10 min)`. Implementación thread-safe con `lock`. | Almacén aislado por `userId`, TTL automático, concurrencia segura. |
| 5. Envía email | `SmtpEmailService` (Gmail SMTP, TLS 587, StartTLS). | Canal fuera de banda, código no expuesto en logs. |
| 6. Cliente llama `POST /api/auth/verify-code` | Body: `{ "userId": int, "code": "123456" }`. | Validación de entrada obligatoria. |
| 7. Backend valida y consume | `ValidateAndRemoveAsync` → comparación ordinal + verificación expiración + **eliminación atómica**. | Un solo uso: éxito o fallo consumen el código (previene reutilización). |
| 8. Marca `IdentidadVerificada=true` | Persiste en BD. | Cambio de estado atómico tras validación exitosa. |
| 9. Genera y devuelve JWT | `LoginResponse` con `Token`, `UserName`, `Roles[]`, `RequiereCompletarInformacion=false`. | Sesión iniciada solo tras verificación completa. |

### 2.4 Completar Información Perfil OAuth (`PUT /api/auth/complete-info`)

| Requisito | Detalle |
|-----------|---------|
| **Autorización** | `[Authorize]` → requiere Bearer JWT válido de AgroTrade. |
| **Identidad** | `userId` extraído del claim `ClaimTypes.NameIdentifier` del JWT. |
| **Validación** | Usuario debe existir y `OAuthProvider.ToLower().Contains("google")`. |
| **Campos** | `Departamento` (normalizado a lista válida de Nicaragua), `Telefono` (8 dígitos, inicia 5/7/8), `DireccionBase`. |
| **Resultado** | Actualiza entidad, `204 No Content` con mensaje. |

### 2.5 Cambio de Contraseña por OTP (Usuario Autenticado)

**Todos los endpoints requieren `[Authorize]` y derivan `userId` del claim `NameIdentifier` del JWT.**

| Endpoint | Flujo | Controles de Seguridad |
|----------|-------|------------------------|
| `POST /api/users/password/send-code` | 1. Genera código: `RandomNumberGenerator.GetInt32` (CSPRNG) 6 dígitos.<br>2. Guarda en `IMemoryCache` clave `PWD_CODE_{userId}` (10 min).<br>3. Envía email. | CSPRNG, TTL 10 min, canal fuera de banda. |
| `POST /api/users/password/verify-code` | 1. Lee `PWD_CODE_{userId}`.<br>2. Compara con `CryptographicOperations.FixedTimeEquals` (timing-safe).<br>3. Si válido: elimina código y crea `PWD_ALLOWED_{userId}=true` (5 min). | Comparación timing-safe, consumo atómico, testigo de vida corta. |
| `POST /api/users/password/reset` | 1. Verifica `PWD_ALLOWED_{userId} == true`.<br>2. Valida `NewPassword.Length >= 8`.<br>3. `PasswordHash = BCrypt.Hash(newPassword)`.<br>4. Persiste en BD.<br>5. Elimina testigo. | Política de longitud, hash BCrypt, testigo de un solo uso. |

---

## 3. Validación del `idToken` de Google vs. JWT Propio de AgroTrade

| Aspecto | `idToken` de Google | JWT de AgroTrade |
|---------|---------------------|------------------|
| **Emisor** | Google (`accounts.google.com`) | AgroTrade (`Jwt:Issuer = "https://api.Agroconnect.com"`) |
| **Audiencia** | `Google:ClientId` | `Jwt:Audience = "https://Agroconnect.com"` |
| **Validación** | `GoogleJsonWebSignature.ValidateAsync` | Middleware `AddJwtBearer` (HMAC SHA256) |
| **Claims principales** | `sub`, `email`, `name`, `picture`, `email_verified` | `sub` (userId), `email`, `name`, `jti`, `role[]` |
| **Uso** | Solo en `POST /api/auth/google-signin` | Bearer token en todos los endpoints `[Authorize]` |
| **Expiración** | Gestionada por Google (~1 hora) | 1 día (`AddDays(1)`) |

> **Regla para clientes**: Usa el `idToken` de Google **una sola vez** en `/google-signin` para obtener el JWT de AgroTrade. Después, usa **exclusivamente** el JWT de AgroTrade como `Authorization: Bearer <token>`.

---

## 4. Arquitectura del OTP de Verificación de Cuenta (Propuesta de Seguridad)

El flujo de verificación de cuenta está diseñado con **defensa en profundidad**:

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO OTP - VERIFICACIÓN CUENTA              │
├─────────────────────────────────────────────────────────────────┤
│  1. GENERACIÓN SEGURA                                           │
│     RandomNumberGenerator.GetInt32() → 6 dígitos (CSPRNG)       │
│     ✓ Entropía criptográfica, impredecible, resistente a brute  │
├─────────────────────────────────────────────────────────────────┤
│  2. ALMACENAMIENTO AISLADO Y THREAD-SAFE                        │
│     InMemoryVerificationCodeRepository                          │
│     • static Dictionary<int, (Code, ExpiresAt)>                 │
│     • lock (_lock) en todas las operaciones                     │
│     • Clave: userId (aislamiento por usuario)                   │
│     • TTL: 10 minutos (expiración automática)                   │
│     ✓ Sin colisiones, concurrencia segura, limpieza automática  │
├─────────────────────────────────────────────────────────────────┤
│  3. ENTREGA FUERA DE BANDA (EMAIL)                              │
│     SmtpEmailService → Gmail SMTP + StartTLS                    │
│     ✓ Código no viaja por el canal de la API                    │
├─────────────────────────────────────────────────────────────────┤
│  4. VALIDACIÓN Y CONSUMO ATÓMICO                                │
│     ValidateAndRemoveAsync(userId, code)                        │
│     • Verifica expiración (DateTime.UtcNow <= ExpiresAt)        │
│     • Comparación ordinal (StringComparison.Ordinal)            │
│     • ELIMINA la entrada SIEMPRE (éxito o fallo)                │
│     ✓ Un solo uso, previene replay, no deja residuos            │
├─────────────────────────────────────────────────────────────────┤
│  5. TRANSICIÓN DE ESTADO SEGURA                                 │
│     IdentidadVerificada = true → Persistencia → Emisión JWT     │
│     ✓ Solo cuentas verificadas obtienen token de sesión         │
└─────────────────────────────────────────────────────────────────┘
```

### Decisiones de Diseño Clave

| Decisión | Justificación |
|----------|---------------|
| **CSPRNG para códigos** | `RandomNumberGenerator` (no `Random`) evita predicción de códigos. |
| **TTL 10 minutos** | Ventana razonable para UX, límite estricto para exposición. |
| **Consumo atómico (eliminación garantizada)** | `ValidateAndRemoveAsync` borra SIEMPRE la entrada → un código = un intento. |
| **Aislamiento por `userId`** | Un usuario no puede validar códigos de otro (clave del diccionario). |
| **Interfaz `IVerificationCodeRepository`** | Abstracción lista para swap a Redis/BD distribuida sin cambiar handlers. |
| **Cuenta inactiva hasta verificación** | `IdentidadVerificada=false` bloquea login hasta OTP válido. |

---

## 5. Arquitectura OTP Cambio de Contraseña (Propuesta de Seguridad)

```
┌─────────────────────────────────────────────────────────────────┐
│                 FLUJO OTP - CAMBIO DE CONTRASEÑA                │
├─────────────────────────────────────────────────────────────────┤
│  REQUISITO PREVIO: Usuario autenticado (JWT válido, claim sub)  │
├─────────────────────────────────────────────────────────────────┤
│  1. SOLICITUD DE CÓDIGO (send-code)                             │
│     • CSPRNG: RandomNumberGenerator.GetInt32() → 6 dígitos      │
│     • IMemoryCache: PWD_CODE_{userId} → TTL 10 min              │
│     • Email con código (canal fuera de banda)                   │
├─────────────────────────────────────────────────────────────────┤
│  2. VERIFICACIÓN TIMING-SAFE (verify-code)                      │
│     • FixedTimeEquals: previene ataques de tiempo               │
│     • Longitud exacta 6 dígitos (validación estricta)           │
│     • Consumo atómico: Remove PWD_CODE_* → Set PWD_ALLOWED_*   │
│     • Testigo PWD_ALLOWED_{userId} = true → TTL 5 min           │
├─────────────────────────────────────────────────────────────────┤
│  3. RESET CON TESTIGO (reset)                                   │
│     • Verifica PWD_ALLOWED_{userId} == true (gate obligatorio)  │
│     • Política: NewPassword ≥ 8 caracteres                      │
│     • BCrypt.HashPassword (work factor 11)                      │
│     • Persistencia + eliminación testigo (un solo uso)          │
└─────────────────────────────────────────────────────────────────┘
```

### Controles de Seguridad Implementados

| Control | Implementación |
|---------|----------------|
| **Autenticación previa obligatoria** | `[Authorize]` + `TryGetAuthenticatedUserId` (claim `sub`). |
| **CSPRNG en ambos códigos** | `RandomNumberGenerator.GetInt32` (registro + cambio pwd). |
| **Timing-safe comparison** | `CryptographicOperations.FixedTimeEquals` (cambio pwd). |
| **Testigo de verificación efímero** | `PWD_ALLOWED` 5 min, un solo uso, gate obligatorio para reset. |
| **Política de contraseña reforzada** | Mínimo 8 chars en reset (vs 6 en registro inicial). |
| **Hash BCrypt** | Work factor por defecto (11), resistente a GPU/ASIC. |

---

## 6. Controles Implementados

| Control | Implementación |
|---------|----------------|
| **Autorización** | `[Authorize]` en controladores. `UsersController` verifica `userId` del JWT vs ruta (403 si no coincide, salvo Admin). |
| **Identidad del usuario** | Siempre del claim `ClaimTypes.NameIdentifier` (`sub`) del JWT validado. |
| **Validación de códigos OTP** | Registro: comparación ordinal + almacén thread-safe. Cambio pwd: `FixedTimeEquals` + `IMemoryCache`. |
| **Hashing de contraseñas** | `BCrypt.Net.BCrypt.HashPassword` / `Verify` (work factor 11). |
| **Expiraciones** | JWT: 1 día. OTP registro: 10 min. OTP cambio pwd: 10 min (código) + 5 min (testigo). |
| **Manejo de errores** | `Result<T>` pattern (éxito/fallo con `StatusCode` y `Message`). `ApiExceptions` en handlers → middleware global. |
| **Validación de datos** | Data Annotations en DTOs (`[Required]`, `[EmailAddress]`, `[MinLength]`, `[RegularExpression]`, `[Phone]`). Normalización de departamento. |

---

## 7. Roadmap de Evolución (Post-Hackathon)

> **Ideas para siguientes iteraciones** — la base actual es sólida y extensible.

| Mejora | Impacto | Esfuerzo |
|--------|---------|----------|
| **Swap a almacenamiento distribuido (Redis)** | Escala horizontal, sobrevive reinicios, multi-instancia | Bajo (implementar `IVerificationCodeRepository` con Redis) |
| **Rate limiting adaptativo** | Protege contra fuerza bruta y enumración de emails | Medio (middleware + políticas por endpoint) |
| **Refresh Tokens rotativos** | Reduce ventana de exposición de access tokens | Medio (nuevo handler + almacenamiento) |
| **Revocation list / token versioning** | Invalida sesiones tras cambio pwd o logout | Medio (claim `ver` + check en middleware) |
| **Validación `email_verified` en Google** | Asegura email verificado por Google antes de crear cuenta | Bajo (agregar check en `GoogleSignInHandler`) |
| **Bloqueo rol Admin en OAuth** | Consistencia con registro tradicional | Bajo (validar `idRol != 4` en `GoogleSignInHandler`) |
| **Auditoría de seguridad estructurada** | Trazabilidad de eventos sensibles (login fallidos, OTP, pwd changes) | Bajo (Serilog + sink estructurado) |
| **Validación certificado SMTP** | Hardening de canal email | Bajo (quitar callback permissivo) |
| **CORS restrictivo en prod** | Reduce superficie de ataque | Bajo (config por environment) |
| **Secretos en Key Vault / Env vars** | Elimina secretos de repo / imagen | Bajo (configuración de despliegue) |

---

## 8. Tabla Resumen: Estado Actual

| Característica | Estado | Detalle |
|----------------|--------|---------|
| Validación firma `idToken` Google | ✅ Implementado | `GoogleJsonWebSignature.ValidateAsync` con audiencia. |
| JWT propio firmado HMAC SHA256 | ✅ Implementado | `TokenServices.GenerateTokenAsync`. |
| Expiración JWT (1 día) | ✅ Implementado | Hardcoded `AddDays(1)`. |
| Refresh Tokens | 🔄 Roadmap | Solo access token actual. |
| Revocación tokens en cambio pwd | 🔄 Roadmap | Tokens previos válidos hasta `exp`. |
| Rate limiting | 🔄 Roadmap | Sin middleware actual. |
| **CSPRNG para OTP registro** | ✅ **Implementado** | `RandomNumberGenerator.GetInt32` (CSPRNG). |
| **CSPRNG para OTP cambio pwd** | ✅ **Implementado** | `RandomNumberGenerator.GetInt32`. |
| **Timing-safe comparison (cambio pwd)** | ✅ **Implementado** | `CryptographicOperations.FixedTimeEquals`. |
| **Almacén OTP thread-safe** | ✅ **Implementado** | `lock` + `Dictionary` / `IMemoryCache`. |
| Expiración OTP registro (10 min) | ✅ Implementado | `TimeSpan.FromMinutes(10)`. |
| Expiración OTP cambio pwd (10+5 min) | ✅ Implementado | `IMemoryCache` con TTL. |
| **Consumo único OTP (eliminación atómica)** | ✅ **Implementado** | `ValidateAndRemoveAsync` borra siempre. |
| Hashing contraseñas BCrypt | ✅ Implementado | Work factor 11. |
| Bloqueo rol Admin en registro tradicional | ✅ Implementado | `AddUserHandler` valida `IdRol != 4`. |
| Bloqueo rol Admin en registro OAuth | 🔄 Roadmap | Validación pendiente en `GoogleSignInHandler`. |
| UserId derivado del JWT (rutas protegidas) | ✅ Implementado | `TryGetAuthenticatedUserId` en `UsersController`. |
| Abstracción `IVerificationCodeRepository` | ✅ Implementado | Listo para Redis/BD sin romper handlers. |

---

## 9. Referencias de Código Clave

| Archivo | Líneas Relevantes |
|---------|-------------------|
| `AuthController.cs` | 22-83 (endpoints auth) |
| `UsersController.cs` | 126-176 (endpoints password OTP) |
| `GoogleSignInHandler.cs` | 31-77 (validación Google + creación usuario + JWT) |
| `LoginHandler.cs` | 28-55 (login tradicional + JWT) |
| `VerifyCodeHandler.cs` | 21-47 (validación OTP registro + JWT) |
| `GoogleSignInCaptureDataHandler.cs` | 15-37 (completar perfil OAuth) |
| `AddUserHandler.cs` | 19-93 (registro + **CSPRNG** + OTP + email) |
| `SendChangePasswordCodeHandler.cs` | 16-34 (CSPRNG + cache + email) |
| `VerifyChangePasswordOtpHandler.cs` | 14-30 (**timing-safe** + testigo) |
| `ResetPasswordAfterOtpHandler.cs` | 14-31 (verifica testigo + hash + persiste) |
| `TokenServices.cs` | 25-50 (generación JWT, claims, expiración) |
| `SmtpEmailService.cs` | 20-77 (envío email Gmail SMTP) |
| `InMemoryVerificationCodeRepository.cs` | 7-38 (**thread-safe**, TTL, consumo atómico) |
| `Program.cs` | 36-50 (JWT Bearer), 86-93 (CORS) |
| `appsettings.json` | 13-22 (Google, JWT, Gmail config) |

---

*Documento generado a partir de la implementación actual del backend. El diseño de OTP prioriza seguridad (CSPRNG, timing-safe, consumo atómico, abstracción para escalar) manteniendo simplicidad para hackathon. Base lista para evolucionar a producción.*