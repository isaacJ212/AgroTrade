# ----------------------------------------------------
# ETAPA 1: Build (Compilación)
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos .csproj para restaurar dependencias
COPY ["src/Meseta_Verde/Meseta_Verde.csproj", "src/Meseta_Verde/"]
COPY ["src/Meseta_Verda.Domain/Meseta_Verda.Domain.csproj", "src/Meseta_Verda.Domain/"]
COPY ["src/Meseta_Verde.Application/Meseta_Verde.Application.csproj", "src/Meseta_Verde.Application/"]
COPY ["src/Meseta_Verde.Infrastructure/Meseta_Verde.Infrastructure.csproj", "src/Meseta_Verde.Infrastructure/"]

# Restaurar paquetes NuGet (incluyendo Npgsql, EF Core y NamingConventions)
RUN dotnet restore "src/Meseta_Verde/Meseta_Verde.csproj"

# Copiar todo el código fuente del backend
COPY . .

# Compilar proyecto en Release
WORKDIR "/src/src/Meseta_Verde"
RUN dotnet build "Meseta_Verde.csproj" -c Release -o /app/build

# ----------------------------------------------------
# ETAPA 2: Publish
# ----------------------------------------------------
FROM build AS publish
RUN dotnet publish "Meseta_Verde.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ----------------------------------------------------
# ETAPA 3: Final Runtime
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

EXPOSE 8080
EXPOSE 8081

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Meseta_Verde.dll"]