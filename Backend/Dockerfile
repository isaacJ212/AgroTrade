# ----------------------------------------------------
# ETAPA 1: Build (Compilación)
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos .csproj para restaurar dependencias
COPY ["src/Agro_Trade/Agro_Trade.csproj", "src/Agro_Trade/"]
COPY ["src/Agro_Trade.Domain/Agro_Trade.Domain.csproj", "src/Agro_Trade.Domain/"]
COPY ["src/Agro_Trade.Application/Agro_Trade.Application.csproj", "src/Agro_Trade.Application/"]
COPY ["src/Agro_Trade.Infrastructure/Agro_Trade.Infrastructure.csproj", "src/Agro_Trade.Infrastructure/"]

# Restaurar paquetes NuGet (incluyendo Npgsql, EF Core y NamingConventions)
RUN dotnet restore "src/Agro_Trade/Agro_Trade.csproj"

# Copiar todo el código fuente del backend
COPY . .

# Compilar proyecto en Release
WORKDIR "/src/src/Agro_Trade"
RUN dotnet build "Agro_Trade.csproj" -c Release -o /app/build

# ----------------------------------------------------
# ETAPA 2: Publish
# ----------------------------------------------------
FROM build AS publish
RUN dotnet publish "Agro_Trade.csproj" -c Release -o /app/publish /p:UseAppHost=false

# ----------------------------------------------------
# ETAPA 3: Final Runtime
# ----------------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

EXPOSE 8080
EXPOSE 8081

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Agro_Trade.dll"]