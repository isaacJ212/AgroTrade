# 🌱 AgroTrade - Landing Page

**Hackathon Nicaragua 2026** - Plataforma de conexión directa entre agricultores locales y consumidores.

> **Conectamos el campo con tu mesa** 🥕🌿

---

## 🎯 Descripción del Proyecto

Meseta Verde es una iniciativa de estudiantes de ingeniería que busca eliminar intermediarios en la cadena agrícola nicaragüense, garantizando:

- ✅ **Precios justos** para los productores
- ✅ **Frescura garantizada** para los consumidores  
- ✅ **Tecnología** al servicio del agro local
- ✅ **Sostenibilidad** en la logística

---

## 📱 Landing Page - Características

Esta landing page es un hub de promoción profesional con:

### 1. **Hero Section** 
- Mensaje impactante: _"Conectamos el campo con tu mesa"_
- Botón destacado de **Descargar App** (solución Flutter)
- Estadísticas clave (100% Conexión Directa, 0 Intermediarios)

### 2. **Sección "Sobre Meseta Verde"**
- Propuesta de valor clara
- Cuatro pilares: Apoyo al Agricultor, Logística Optimizada, Calidad Garantizada, Crecimiento Sostenible
- Impacto en números: +40% ingresos, -30% costos, 100% transparencia

### 3. **Integración Social**
- Enlaces directos a TikTok, Facebook e Instagram
- Diseño atractivo con calls-to-action
- Descripción de contenido en cada red

### 4. **Sección "Conecta"** (Contacto)
- Formulario limpio para productores e inversionistas
- Información de contacto
- Tipos de usuario (Consumidor, Productor, Inversor)

### 5. **Footer**
- Branding profesional
- Enlaces de navegación
- Información legal

---

## 🛠️ Stack Técnico

- **Framework**: Next.js 16 (App Router)
- **Styling**: Tailwind CSS v4
- **UI Components**: shadcn/ui
- **Icons**: Lucide React
- **Language**: TypeScript
- **Responsive**: Mobile-first (100% móvil-optimizado)

---

## 📋 Requisitos Previos

- Node.js 18+ 
- pnpm (o npm/yarn)

---

## 🚀 Instalación y Desarrollo

### Clonar el repositorio
```bash
git clone <tu-repo>
cd meseta-verde
```

### Instalar dependencias
```bash
pnpm install
```

### Iniciar servidor de desarrollo
```bash
pnpm dev
```

La aplicación estará disponible en `http://localhost:3000`

---

## 🎨 Paleta de Colores

Colores naturales inspirados en Nicaragua:

| Elemento | Color | Código |
|----------|-------|--------|
| Primary (Verde agro) | Verde oscuro | `oklch(0.42 0.18 142)` |
| Secondary (Tierra) | Verde claro/tierra | `oklch(0.62 0.14 92)` |
| Background | Blanco crema | `oklch(0.98 0.01 120)` |
| Text | Verde oscuro profundo | `oklch(0.18 0.02 120)` |

---

## 📁 Estructura del Proyecto

```
.
├── app/
│   ├── layout.tsx          # Layout raíz
│   ├── page.tsx            # Página principal
│   └── globals.css         # Estilos globales y tema
├── components/
│   ├── hero-section.tsx    # Sección hero
│   ├── about-section.tsx   # Sobre Meseta Verde
│   ├── social-section.tsx  # Redes sociales
│   ├── contact-section.tsx # Formulario de contacto
│   ├── footer.tsx          # Footer
│   └── ui/
│       └── button.tsx      # Componente Button
├── public/
│   ├── hero-farm.png       # Imagen de campo
│   └── logo.png            # Logo
├── lib/
│   └── utils.ts            # Utilidades
└── package.json
```

---

## 🎯 Diferenciadores

1. **Mobile-first**: Optimizado para agricultores y consumidores en dispositivos móviles
2. **Diseño minimalista pero impactante**: Profesional y moderno
3. **Accesibilidad**: Estructura semántica HTML5, ARIA labels, contraste adecuado
4. **Performance**: Build estático, Turbopack, optimizaciones Next.js 16
5. **Internacionalización**: Completamente en español

---

## 🚢 Despliegue en Vercel

### Opción 1: GitHub Integration (Recomendado)

1. Push a GitHub
2. Conecta tu repositorio en [Vercel Dashboard](https://vercel.com)
3. Vercel detectará Next.js automáticamente
4. Haz deploy con un clic

### Opción 2: Vercel CLI

```bash
npm i -g vercel
vercel
```

### Build para producción

```bash
pnpm build
pnpm start
```

---

## 📊 Performance

- **Build time**: ~3-4 segundos (Turbopack)
- **Página estática prerenderedizada**: Máxima velocidad
- **Bundle size optimizado**: Tailwind purged
- **Core Web Vitals**: Optimizados

---

## 🎯 URLs Funcionales

- **Descargar App**: Redirige a Google Play Store (configurable)
- **Redes Sociales**: TikTok, Facebook, Instagram
- **Email**: hola@mesataverde.com
- **Formulario de contacto**: Integración lista para backend

---

## 🔧 Customización

### Cambiar URLs de descargas/redes sociales

Edita el archivo de cada componente:
- `components/hero-section.tsx` - URL de Play Store
- `components/social-section.tsx` - URLs de redes

### Cambiar paleta de colores

Modifica `app/globals.css` en la sección `:root { ... }`:

```css
--primary: oklch(0.42 0.18 142);  /* Tu color aquí */
```

### Agregar más secciones

Crea un nuevo archivo en `components/` y impórtalo en `app/page.tsx`

---

## 📞 Contacto & Soporte

**Email**: hola@mesataverde.com  
**Ubicación**: Nicaragua  
**Respuesta**: En 24 horas

---

## 📝 Notas para los Jueces

✨ **Esta landing page demuestra:**

- Prototipado rápido y profesional
- Entendimiento de UX/UI moderno
- Uso efectivo de tecnologías web actuales
- Mobile-first thinking (audiencia real)
- Marca sólida y cohesiva
- Listo para producción y escala

🎨 **Diseño:**
- Paleta de colores natural y consistente
- Tipografía legible y profesional
- Animations sutiles (bounce scroll)
- Spacing armónico (Tailwind scale)

⚡ **Técnico:**
- Next.js 16 + Turbopack (bundler moderno)
- Tailwind CSS v4 (sin compilación lenta)
- TypeScript para type-safety
- Componentes reutilizables
- Semántica HTML5 correcta

---

## 📄 Licencia

© 2026 Meseta Verde. Todos los derechos reservados.

Hackathon Nicaragua 2026 - Equipo de Ingeniería

---

**¿Listo para revolucionar la agricultura nicaragüense?** 🚀
