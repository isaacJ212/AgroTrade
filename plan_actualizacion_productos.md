# Plan de Ejecución y Cambios Realizados

## 1. Actualización de los productos
### Backend:
- La funcionalidad ya existía en `ProductosController` (`[HttpPut]` y `[HttpPatch]`).

### Frontend:
- Se añadió el método `actualizarProductoInfo(Producto p)` en `ProductorApiService` (`lib/services/productor_api_service.dart`). Este método invoca `PUT /api/Productos/{id}` para actualizar la información básica del producto (nombre, descripción, unidad de medida, categoría) y actualiza el estado localmente si la petición es exitosa o la aplicación está en modo offline.

## 2. Dar de baja un producto (Soft Delete)
### Backend:
- **Entidad `Producto`**: Se añadió la propiedad booleana `Activo` (`Backend/src/Agro_Trade.Domain/Entities/Producto.cs`).
- **Configuración `ProductoConfiguration`**: Se añadió un filtro global `builder.HasQueryFilter(p => p.Activo);` para que las consultas de Entity Framework automáticamente excluyan los productos inactivos (`Backend/src/Agro_Trade.Infrastructure/Persistence/Configurations/ProductoConfiguration.cs`).
- **Comando `DeleteProductoCommand`**: Se modificó la lógica para que en lugar de usar `DeleteAsync` (hard delete), asigne `producto.Activo = false` y use `UpdateAsync` (soft delete) (`Backend/src/Agro_Trade.Application/Features/Productos/Commands/DeleteProductoCommand.cs`).
- **DTO `ProductoDto`**: Se añadió la propiedad `Activo` para reflejar el estado en las peticiones GET (`Backend/src/Agro_Trade.Application/Common/DTOs/ProductosDtos/ProductoDto.cs`).
- **Queries**: Se mapeó la propiedad `Activo` en `GetProductosQuery` y `GetProductoByIdQuery` (`Backend/src/Agro_Trade.Application/Features/Productos/Queries/...`).

### Frontend:
- **Modelos**: Se incorporó el campo `activo` a las dos definiciones del modelo `Producto` (`lib/models/Productor/catalogo/producto.dart` y `lib/models/productor_models.dart`).
- **Servicio `ProductorApiService`**: Se añadió el método `darDeBajaProducto(int idProducto)` que invoca `DELETE /api/Productos/{id}` en el backend para dar de baja lógica al producto. En caso de no tener red, asume el cambio localmente actualizando `activo = false` en el caché (`lib/services/productor_api_service.dart`).

---

## Archivos Modificados y Commits Sugeridos

Podrás ejecutar los siguientes commits (recuerda agregar previamente `git add .` o los archivos específicos):

### Commit 1: Backend - Soporte para baja lógica de Productos (Soft Delete)
```bash
git commit -m "feat(backend): agregar soft delete a Producto y filtros globales"
```
**Archivos involucrados:**
- `Backend/src/Agro_Trade.Domain/Entities/Producto.cs`
- `Backend/src/Agro_Trade.Infrastructure/Persistence/Configurations/ProductoConfiguration.cs`
- `Backend/src/Agro_Trade.Application/Features/Productos/Commands/DeleteProductoCommand.cs`
- `Backend/src/Agro_Trade.Application/Common/DTOs/ProductosDtos/ProductoDto.cs`
- `Backend/src/Agro_Trade.Application/Features/Productos/Queries/GetProductosQuery.cs`
- `Backend/src/Agro_Trade.Application/Features/Productos/Queries/GetProductoByIdQuery.cs`

*Nota para ti*: Como agregamos un campo `Activo` en la base de datos, te sugiero crear una migración de base de datos ejecutando en tu consola de Entity Framework (o CLI) `dotnet ef migrations add AddProductoActivo` y luego `dotnet ef database update` antes de continuar probando.

### Commit 2: Frontend - Servicios de actualización y baja de productos
```bash
git commit -m "feat(frontend): añadir métodos de actualización y baja lógica de productos"
```
**Archivos involucrados:**
- `Frontend/agrotrade_frontend/lib/models/Productor/catalogo/producto.dart`
- `Frontend/agrotrade_frontend/lib/models/productor_models.dart`
- `Frontend/agrotrade_frontend/lib/services/productor_api_service.dart`
