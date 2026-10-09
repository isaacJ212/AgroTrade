# =============================================================================
# Dockerfile para API Backend (ASP.NET Core 8.0) - Producción
# Multi-stage build: Build -> Publish -> Runtime
# =============================================================================

# -----------------------------------------------------------------------------
# ETAPA 1: Build (Compilación)
# -----------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build

WORKDIR /src

# Copiar archivos .csproj para restaurar dependencias (cache layer)
COPY ["src/Agro_Trade/Agro_Trade.csproj", "src/Agro_Trade/"]
COPY ["src/Agro_Trade.Domain/Agro_Trade.Domain.csproj", "src/Agro_Trade.Domain/"]
COPY ["src/Agro_Trade.Application/Agro_Trade.Application.csproj", "src/Agro_Trade.Application/"]
COPY ["src/Agro_Trade.Infrastructure/Agro_Trade.Infrastructure.csproj", "src/Agro_Trade.Infrastructure/"]

# Restaurar paquetes NuGet
RUN dotnet restore "src/Agro_Trade/Agro_Trade.csproj"

# Copiar todo el código fuente
COPY . .

# Compilar en Release
WORKDIR "/src/src/Agro_Trade"
RUN dotnet build "Agro_Trade.csproj" -c Release -o /app/build 

# -----------------------------------------------------------------------------
# ETAPA 2: Publish
# -----------------------------------------------------------------------------
FROM build AS publish
RUN dotnet publish "Agro_Trade.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore

# -----------------------------------------------------------------------------
# ETAPA 3: Final Runtime (Imagen ligera alpine)
# -----------------------------------------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS final

# Instalar dependencias del sistema necesarias (curl para healthcheck, tzdata para zona horaria)
RUN apk add --no-cache curl tzdata

# Configurar zona horaria
ENV TZ=America/Managua


# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Copiar aplicación publicada
COPY --from=publish --chown=appuser:appgroup /app/publish .

# Cambiar a usuario no-root
USER appuser

# Exponer puertos (HTTP y HTTPS)
EXPOSE 8080
EXPOSE 8081

# Variables de entorno por defecto
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:8080
ENV DOTNET_RUNNING_IN_CONTAINER=true

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Comando de inicio
ENTRYPOINT ["dotnet", "Agro_Trade.dll"]