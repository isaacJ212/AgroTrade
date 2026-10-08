# =============================================================================
# Dockerfile para el Panel de Administración (AgroTrade Admin)
# Multi-stage build: Build -> Production
# =============================================================================

# -----------------------------------------------------------------------------
# ETAPA 1: Build / Install Dependencies
# -----------------------------------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Copiar package files primero para aprovechar cache de Docker
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production

# -----------------------------------------------------------------------------
# ETAPA 2: Production Runtime
# -----------------------------------------------------------------------------
FROM node:20-alpine AS production

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

WORKDIR /app

# Copiar dependencias desde builder
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules

# Copiar código fuente
COPY --chown=nextjs:nodejs . .

# Cambiar a usuario no-root
USER nextjs

# Exponer puerto
EXPOSE 3000

# Variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Comando de inicio
CMD ["node", "server.js"]