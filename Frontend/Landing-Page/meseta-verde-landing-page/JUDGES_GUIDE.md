# 🏆 MESETA VERDE - Guía para Jueces

## Bienvenida

Gracias por evaluar **Meseta Verde**, una plataforma que conecta agricultores locales con consumidores en Nicaragua.

Esta es nuestra **Landing Page profesional** - el hub de promoción, captura de leads y branding del proyecto.

---

## ⚡ INICIO RÁPIDO (1 minuto)

### Ver la página en vivo
```bash
# Opción 1: Online (después de deploy)
https://meseta-verde.vercel.app

# Opción 2: Local
git clone <repo>
cd meseta-verde
pnpm install
pnpm dev
# Abre http://localhost:3000
```

---

## 🎯 QUÉ EVALUAR

### 1. 🎨 DISEÑO & UX
- [ ] **Visual Impact**: ¿El hero section es impactante?
- [ ] **Mobile-First**: Prueba en móvil (la audiencia real)
- [ ] **Color System**: Paleta verde natural cohesiva
- [ ] **Typography**: Legible, jerárquico, profesional
- [ ] **Spacing**: Uso armónico de espacios en blanco
- [ ] **CTA Clarity**: ¿El botón "Descargar App" destaca?

### 2. ⚙️ FUNCIONALIDAD
- [ ] **Navegación**: Smooth scrolling, fácil de navegar
- [ ] **Responsive**: Desktop, Tablet, Mobile funcionan
- [ ] **Formulario**: Campos validados, UI feedback
- [ ] **Social Links**: Enlaces a redes activos
- [ ] **Botón Descarga**: Redirige correctamente

### 3. 💻 CÓDIGO & ARQUITECTURA
- [ ] **Tech Stack**: Next.js 16, React 19, Tailwind v4
- [ ] **Structure**: Componentes modulares (5 secciones)
- [ ] **TypeScript**: Type-safe, sin `any`
- [ ] **Performance**: Build rápido, static rendering
- [ ] **Clean Code**: Readable, maintainable

### 4. ♿ ACCESIBILIDAD
- [ ] **HTML Semantic**: main, section, heading correctos
- [ ] **Contrast**: Colores con suficiente contraste
- [ ] **Labels**: Inputs con labels asociados
- [ ] **Keyboard**: Navegación solo con teclado
- [ ] **ARIA**: Roles y atributos donde aplica

### 5. 📊 CONTENIDO & MESSAGING
- [ ] **Clarity**: ¿Se entiende la propuesta de Meseta Verde?
- [ ] **Value Prop**: Precios justos, cero intermediarios claro
- [ ] **CTA Hierarchy**: Descargar App es principal
- [ ] **Social Integration**: Comunidad visible
- [ ] **Contact**: Formulario accesible

---

## 📋 SECCIONES A REVISAR

### HERO SECTION
**Lo que ves**: Título "Conectamos el campo con tu mesa" + 2 botones
**Evalúa**:
- ¿Impacto visual? ¿Llama atención?
- ¿Botón verde destaca lo suficiente?
- ¿El subtítulo comunica la propuesta?
- ¿Stats (100%, 0, ♻️) son relevantes?

### SOBRE MESETA VERDE
**Lo que ves**: 4 tarjetas con pilares del proyecto
**Evalúa**:
- ¿Los 4 pilares son claros?
- ¿Las descripciones son concisas?
- ¿Existe cohesión visual?
- ¿Los iconos son relevantes?

### REDES SOCIALES
**Lo que ves**: 3 tarjetas TikTok, Facebook, Instagram
**Evalúa**:
- ¿Es motivador seguir esas redes?
- ¿Los links funcionan?
- ¿El diseño es atractivo?
- ¿Invita a la comunidad?

### FORMULARIO CONTACTO
**Lo que ves**: Form con 4 campos + info de contacto
**Evalúa**:
- ¿El form es intuitivo?
- ¿Validación funciona?
- ¿Los tipos de usuario son relevantes?
- ¿El layout es mobile-friendly?

### FOOTER
**Lo que ves**: Branding + links + copyright
**Evalúa**:
- ¿Se ve profesional?
- ¿Info relevante incluida?
- ¿Contraste de color es adecuado?

---

## 🔍 PRUEBAS SUGERIDAS

### Test 1: Mobile Experience (5 min)
```
1. Abre en mobile (375px) o emulador
2. Scrollea toda la página
3. Toca el botón "Descargar App"
4. Completa el formulario
5. Nota: ¿Es fácil? ¿Es rápido?
```

### Test 2: Desktop Experience (5 min)
```
1. Abre en desktop (1920px)
2. Prueba hover effects
3. Valida spacing y alignment
4. Nota: ¿Respeta golden ratio?
5. ¿Se siente profesional?
```

### Test 3: Accesibilidad (5 min)
```
1. Desactiva CSS (Tools > Disable Styles)
2. ¿Se lee bien el contenido?
3. Prueba Tab navigation
4. Zoom a 200%
5. ¿Sigue siendo usable?
```

### Test 4: Performance (2 min)
```
1. DevTools > Network > Throttle 3G
2. Reload página
3. Mide LCP (Largest Contentful Paint)
4. ¿Carga rápido?
5. Lighthouse score: esperar 90+
```

---

## 📁 ARCHIVOS IMPORTANTES

| Archivo | Propósito |
|---------|-----------|
| `README.md` | Documentación técnica |
| `PRESENTATION.md` | Presentación ejecutiva |
| `app/page.tsx` | Landing page |
| `components/` | 5 secciones modulares |
| `app/globals.css` | Sistema de colores |
| `vercel.json` | Config para deploy |

---

## 🎨 PALETA DE COLORES

**Inspirada en naturaleza nicaragüense** 🌿

```
🟢 Verde Oscuro (Primary): oklch(0.42 0.18 142)
🌾 Verde Tierra (Secondary): oklch(0.62 0.14 92)
⚪ Crema Blanca (Background): oklch(0.98 0.01 120)
```

**Por qué estos colores**:
- Evoca campo y agricultura
- Profesional y moderno
- Accesible (contraste WCAG AA)
- Consistente en toda la página

---

## ✅ CHECKLIST PARA JUECES

### Visual & Design
- [ ] Diseño es moderno y profesional
- [ ] Colores son coherentes y naturales
- [ ] Typography es legible
- [ ] Spacing es armónico
- [ ] Mobile experience es excelente
- [ ] Botón "Descargar App" destaca

### Functionality
- [ ] Todo funciona sin errores
- [ ] Formulario valida correctamente
- [ ] Enlaces a redes sociales funcionan
- [ ] Responsive en todas las resoluciones
- [ ] Animaciones son smooth (no laggy)

### Code Quality
- [ ] Componentes modulares
- [ ] TypeScript sin errores
- [ ] Código legible
- [ ] No hay console errors
- [ ] Build es exitoso

### User Experience
- [ ] Mensaje es claro
- [ ] Propuesta de valor es evidente
- [ ] Navegación es intuitiva
- [ ] Call-to-Actions están claros
- [ ] Formulario es fácil de completar

### Professional Standards
- [ ] Metadata SEO presente
- [ ] Accesibilidad básica cumplida
- [ ] Performance optimizado
- [ ] Deployment ready
- [ ] Documentación completa

---

## 🚀 DESPLIEGUE

### Para ver online:
1. El proyecto está configurado para Vercel
2. Con un `git push`, se deploya automáticamente
3. URL: `meseta-verde.vercel.app`

### Para probar localmente:
```bash
git clone <repo>
cd meseta-verde
pnpm install
pnpm dev
```

---

## 📞 CONTACTO

**Email**: hola@mesataverde.com
**Ubicación**: Nicaragua
**Respuesta**: En 24 horas

---

## 🎯 CRITERIOS DE ÉXITO

Esta landing page es exitosa si:

✅ **Comunica** claramente la propuesta de Meseta Verde
✅ **Impacta** visualmente (verdad de startup tech)
✅ **Funciona** perfectamente sin bugs
✅ **Se vende** profesionalmente a jueces
✅ **Es móvil** first (realidad de Nicaragua)
✅ **Usa tech** moderno (Next.js 16, React 19)
✅ **Es escalable** (arquitectura sólida)
✅ **Está lista** para producción

---

## 💡 NOTAS ESPECIALES

### ¿Por qué Next.js 16?
- Turbopack: 300% más rápido que webpack
- React 19: Hooks modernos, mejor performance
- Static rendering: Máxima velocidad
- Edge functions: Escalable globalmente

### ¿Por qué Tailwind v4?
- Utility-first: Rápido de desarrollar
- Customizable: Sistema de colores nativo
- Performance: No genera CSS no usado
- Moderno: Última versión

### ¿Por qué Mobile-First?
- Realidad en Nicaragua: 80%+ tráfico móvil
- Agricultores usan principalmente móvil
- Mejora SEO (Google prioriza mobile)
- Experiencia más natural

---

## 🏆 ESPERAMOS IMPACTE

Como equipo, creemos que esta landing page **demuestra**:

1. **Profesionalismo**: Diseño y código de calidad
2. **Viabilidad**: MVP listo para usar
3. **Escalabilidad**: Arquitectura pensada en crecimiento
4. **Comprensión del usuario**: Mobile-first, UX pensado
5. **Tecnología moderna**: Stack actual y eficiente

**Gracias por evaluar Meseta Verde** 🌿

---

**© 2026 Meseta Verde - Hackathon Nicaragua 2026**
