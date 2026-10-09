'use client'

import { Leaf, Zap, Award, BarChart3, Check } from 'lucide-react'

const features = [
  {
    icon: Leaf,
    title: 'Apoyo al Agricultor',
    badge: '+12%',
    badgeBg: 'bg-[#E0F2FE] text-[#0284C7]',
    description: 'Precios justos que reconocen el valor del trabajo en el campo y el compromiso con la calidad.',
  },
  {
    icon: Zap,
    title: 'Logística Optimizada',
    badge: '+5%',
    badgeBg: 'bg-[#DCFCE7] text-[#16A34A]',
    description: 'Entregas rápidas y eficientes de productos frescos, directamente desde la cosecha a tu puerta.',
  },
  {
    icon: Award,
    title: 'Calidad Garantizada',
    badge: 'Verificado',
    badgeBg: 'bg-[#FEF3C7] text-[#D97706]',
    description: 'Productos frescos seleccionados por agricultores comprometidos con la excelencia.',
  },
  {
    icon: BarChart3,
    title: 'Crecimiento Sostenible',
    badge: 'Regional',
    badgeBg: 'bg-[#E0F2FE] text-[#0284C7]',
    description: 'Tecnología al servicio del agro nicaragüense, impulsando oportunidades económicas locales.',
  }
]

export function AboutSection() {
  return (
    <section id="mision" className="relative py-16 sm:py-24 px-4 bg-background border-t border-border">
      <div className="max-w-6xl mx-auto">
        {/* Section header */}
        <div className="text-left mb-10">
          <h2 className="text-3xl sm:text-4xl font-extrabold text-foreground mb-2 tracking-tight">
            Sobre AgroTrade
          </h2>
          <p className="text-base text-muted-foreground max-w-2xl font-normal">
            Supervisá la actividad principal y la misión de AgroTrade.
          </p>
        </div>

        {/* Big Card matching "Pendientes de revisión" card in Admin Dashboard screenshot */}
        <div className="bg-card border border-border rounded-2xl p-6 sm:p-8 mb-10 shadow-xs">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-xl sm:text-2xl font-extrabold text-foreground tracking-tight">
              Misión de la Plataforma
            </h3>
            <span className="text-xs sm:text-sm font-semibold text-primary bg-[#E6F4EA] px-3 py-1 rounded-full border border-[#006E2C]/15">
              Propósito Central
            </span>
          </div>

          {/* Inner box text is explicitly dark slate/black for high contrast readability */}
          <div className="bg-[#F8FAFC] border border-border rounded-xl p-5 sm:p-6 mb-6">
            <p className="text-base sm:text-lg font-medium text-slate-900 leading-relaxed">
              Nuestra misión es <span className="font-extrabold text-[#006E2C]">eliminar intermediarios innecesarios</span>, garantizando precios justos para los productores y productos frescos para los consumidores. Creemos que la tecnología puede ser un puente poderoso entre el campo y la mesa.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-full bg-[#E6F4EA] flex items-center justify-center text-primary shrink-0">
              <Check className="w-5 h-5" />
            </div>
            <div>
              <p className="text-sm font-bold text-foreground">Verificación directa en origen</p>
              <p className="text-xs text-muted-foreground">Cada productor registrado cuenta con seguimiento y alta certificada.</p>
            </div>
          </div>
        </div>

        {/* Features grid with dashboard KPI card style */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-5 mb-10">
          {features.map((feature) => {
            const Icon = feature.icon
            return (
              <div
                key={feature.title}
                className="p-6 rounded-2xl bg-card border border-border shadow-xs hover:shadow-sm transition-all duration-200"
              >
                <div className="flex justify-between items-start mb-4">
                  <div className="w-11 h-11 rounded-xl bg-[#E6F4EA] flex items-center justify-center text-primary">
                    <Icon className="w-5.5 h-5.5" />
                  </div>
                  <span className={`text-xs font-bold px-2.5 py-1 rounded-md ${feature.badgeBg}`}>
                    {feature.badge}
                  </span>
                </div>
                <h3 className="text-lg font-bold text-foreground mb-2">
                  {feature.title}
                </h3>
                <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed">
                  {feature.description}
                </p>
              </div>
            )
          })}
        </div>

        {/* Dashboard bottom summary cards */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5">
          <div className="bg-card border border-border rounded-2xl p-6 shadow-xs">
            <div className="text-3xl font-bold text-primary mb-1">→ 40%</div>
            <p className="text-sm font-medium text-muted-foreground">Más ingresos para productores</p>
          </div>
          <div className="bg-card border border-border rounded-2xl p-6 shadow-xs">
            <div className="text-3xl font-bold text-primary mb-1">↓ 30%</div>
            <p className="text-sm font-medium text-muted-foreground">Menor costo para consumidores</p>
          </div>
          <div className="bg-card border border-border rounded-2xl p-6 shadow-xs">
            <div className="text-3xl font-bold text-primary mb-1">100%</div>
            <p className="text-sm font-medium text-muted-foreground">Transparencia en cada transacción</p>
          </div>
        </div>
      </div>
    </section>
  )
}
