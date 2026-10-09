'use client'

import { Music, Share2, ImageIcon } from 'lucide-react'

const socialLinks = [
  {
    name: 'TikTok',
    icon: Music,
    url: 'https://tiktok.com',
    badge: 'Diario',
    description: 'Síguenos en TikTok para contenido fresco y diario del campo'
  },
  {
    name: 'Facebook',
    icon: Share2,
    url: 'https://www.facebook.com/profile.php?id=61591870473550',
    badge: 'Comunidad',
    description: 'Conecta con nuestra comunidad agrícola en Facebook'
  },
  {
    name: 'Instagram',
    icon: ImageIcon,
    url: 'https://instagram.com',
    badge: 'Historias',
    description: 'Descubre historias de nuestros productores locales'
  }
]

export function SocialSection() {
  return (
    <section className="relative py-16 sm:py-24 px-4 bg-background border-t border-border">
      <div className="max-w-6xl mx-auto">
        {/* Section header */}
        <div className="text-left mb-10">
          <h2 className="text-3xl sm:text-4xl font-bold text-foreground mb-2 tracking-tight">
            Únete a Nuestra Comunidad
          </h2>
          <p className="text-base text-muted-foreground max-w-2xl font-normal">
            Sigue nuestras redes sociales para conocer novedades e historias del sector.
          </p>
        </div>

        {/* Social cards grid */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-5 mb-10">
          {socialLinks.map((social) => {
            const Icon = social.icon
            return (
              <a
                key={social.name}
                href={social.url}
                target="_blank"
                rel="noopener noreferrer"
                className="group p-6 rounded-2xl bg-card border border-border shadow-xs hover:shadow-sm transition-all duration-200 cursor-pointer flex flex-col justify-between"
              >
                <div>
                  <div className="flex justify-between items-start mb-4">
                    <div className="w-11 h-11 rounded-xl bg-[#E6F4EA] flex items-center justify-center text-primary">
                      <Icon className="w-5.5 h-5.5" />
                    </div>
                    <span className="text-xs font-bold text-[#0284C7] bg-[#E0F2FE] px-2.5 py-1 rounded-md">
                      {social.badge}
                    </span>
                  </div>
                  <h3 className="text-lg font-bold text-foreground mb-2">
                    {social.name}
                  </h3>
                  <p className="text-xs sm:text-sm text-muted-foreground leading-relaxed mb-4">
                    {social.description}
                  </p>
                </div>
                <div className="text-primary font-semibold text-xs sm:text-sm flex items-center gap-1 group-hover:gap-2 transition-all">
                  Visitar perfil <span className="text-sm">→</span>
                </div>
              </a>
            )
          })}
        </div>

        {/* Community CTA matching Admin Dashboard card style */}
        <div className="p-6 sm:p-8 rounded-2xl bg-card border border-border flex flex-col sm:flex-row items-center justify-between gap-6 shadow-xs">
          <div>
            <h3 className="text-lg font-bold text-foreground mb-1">Redes Oficiales AgroTrade</h3>
            <p className="text-xs sm:text-sm text-muted-foreground">Canales verificados de atención y difusión agrícola.</p>
          </div>
          <div className="flex flex-wrap gap-2.5 shrink-0">
            {socialLinks.map((social) => (
              <a
                key={social.name}
                href={social.url}
                target="_blank"
                rel="noopener noreferrer"
                className="px-5 py-2 rounded-full bg-[#E6F4EA] border border-[#006E2C]/15 text-primary font-semibold text-xs sm:text-sm hover:bg-primary hover:text-white transition-all duration-200 cursor-pointer"
              >
                {social.name}
              </a>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
