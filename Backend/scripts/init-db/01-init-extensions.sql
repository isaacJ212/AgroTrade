-- =============================================================================
-- Script de Inicialización de Base de Datos - AgroTrade
-- Se ejecuta automáticamente al crear el contenedor PostgreSQL por primera vez
-- =============================================================================

-- Extensiones útiles
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Configuración de zona horaria
SET timezone = 'America/Argentina/Buenos_Aires';

-- Comentario: Las tablas se crean automáticamente via Entity Framework Migrations
-- Este script solo configura extensiones y settings base

-- Verificar que la BD se creó correctamente
SELECT 'AgroTrade Database initialized successfully' AS status;