# ----------------------------------------------------
# ETAPA 1: Compilación (Build Stage)
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1. Copiar los archivos .csproj para restaurar dependencias y aprovechar el caché de Docker
COPY ["src/Meseta_Verde/Meseta_Verde.csproj", "src/Meseta_Verde/"]
COPY ["src/Meseta_Verde.Domain/Meseta_Verde.Domain.csproj", "src/Meseta_Verde.Domain/"]
COPY ["src/Meseta_Verde.Application/Meseta_Verde.Application.csproj", "src/Meseta_Verde.Application/"]
COPY ["src/Meseta_Verde.Infrastructure/Meseta_Verde.Infrastructure.csproj", "src/Meseta_Verde.Infrastructure/"]

# Restaurar paquetes NuGet
RUN dotnet restore "src/Meseta_Verde/Meseta_Verde.csproj"

# 2. Copiar todo el código fuente del proyecto
COPY . .

# 3. Compilar la aplicación en modo Release
WORKDIR "/src/src/Meseta_Verde"
RUN dotnet build "Meseta_Verde.csproj" -c Release -o /app/build

# ----------------------------------------------------
# ETAPA 2: Publicación (Publish Stage)
# ----------------------------------------------------
FROM build AS publish
RUN dotnet publish "Meseta_Verde.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ----------------------------------------------------
# ETAPA 3: Imagen Final de Ejecución (Runtime Stage)
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Copiar los binarios optimizados desde la etapa de publicación
COPY --from=publish /app/publish .

# Definir el comando de inicio
ENTRYPOINT ["dotnet", "Meseta_Verde.dll"]