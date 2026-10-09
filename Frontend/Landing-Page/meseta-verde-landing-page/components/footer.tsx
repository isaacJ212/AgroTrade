'use client'

import { Leaf } from 'lucide-react'

export function Footer() {
  const currentYear = new Date().getFullYear()

  return (
    <footer className="relative bg-card border-t border-border text-foreground py-12 px-4">
      <div className="max-w-6xl mx-auto">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">
          {/* Brand section */}
          <div className="space-y-3">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-full bg-[#E6F4EA] flex items-center justify-center text-primary">
                <Leaf className="w-5 h-5" />
              </div>
              <span className="text-xl font-bold tracking-tight text-foreground">AgroTrade</span>
            </div>
            <p className="text-xs sm:text-sm text-muted-foreground font-normal leading-relaxed">
              Plataforma de conexión directa entre el campo y tu mesa desde Nicaragua.
            </p>
          </div>

          {/* Product */}
          <div>
            <h4 className="font-bold text-xs tracking-wider uppercase text-muted-foreground mb-3">Producto</h4>
            <ul className="space-y-2 text-sm text-foreground/80 font-medium">
              <li><a href="#" className="hover:text-primary transition-colors">Descargar App</a></li>
              <li><a href="#conecta" className="hover:text-primary transition-colors">Ser Productor</a></li>
              <li><a href="#" className="hover:text-primary transition-colors">Cómo funciona</a></li>
            </ul>
          </div>

          {/* Company */}
          <div>
            <h4 className="font-bold text-xs tracking-wider uppercase text-muted-foreground mb-3">Empresa</h4>
            <ul className="space-y-2 text-sm text-foreground/80 font-medium">
              <li><a href="#" className="hover:text-primary transition-colors">Acerca de</a></li>
              <li><a href="#" className="hover:text-primary transition-colors">Blog</a></li>
              <li><a href="#conecta" className="hover:text-primary transition-colors">Contacto</a></li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="font-bold text-xs tracking-wider uppercase text-muted-foreground mb-3">Legal</h4>
            <ul className="space-y-2 text-sm text-foreground/80 font-medium">
              <li><a href="#" className="hover:text-primary transition-colors">Privacidad</a></li>
              <li><a href="#" className="hover:text-primary transition-colors">Términos</a></li>
              <li><a href="#" className="hover:text-primary transition-colors">Cookies</a></li>
            </ul>
          </div>
        </div>

        {/* Divider */}
        <div className="border-t border-border pt-6">
          <div className="flex flex-col sm:flex-row justify-between items-center gap-3 text-xs text-muted-foreground">
            <p>© {currentYear} AgroTrade. Todos los derechos reservados.</p>
            <p className="font-semibold text-primary">Hackathon Nicaragua 2026 • Equipo de Ingeniería</p>
          </div>
        </div>
      </div>
    </footer>
  )
}
