'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Mail, MapPin, Clock, CheckCircle2 } from 'lucide-react'

export function ContactSection() {
  const [formData, setFormData] = useState({
    nombre: '',
    email: '',
    tipo: 'consumidor',
    mensaje: ''
  })
  const [submitted, setSubmitted] = useState(false)

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!formData.nombre.trim() || !formData.email.trim() || !formData.mensaje.trim()) {
      alert('Por favor completa todos los campos requeridos')
      return
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(formData.email)) {
      alert('Por favor ingresa un correo electrónico válido')
      return
    }

    setSubmitted(true)

    try {
      const response = await fetch('/api/contact', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData)
      })

      if (response.ok) {
        setTimeout(() => {
          setFormData({ nombre: '', email: '', tipo: 'consumidor', mensaje: '' })
          setSubmitted(false)
        }, 3000)
      } else {
        alert('Error al enviar el formulario. Por favor intenta de nuevo.')
        setSubmitted(false)
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Error al enviar el mensaje. Por favor intenta de nuevo.')
      setSubmitted(false)
    }
  }

  return (
    <section id="conecta" className="relative py-16 sm:py-24 px-4 bg-background border-t border-border">
      <div className="max-w-6xl mx-auto">
        <div className="text-left mb-10">
          <h2 className="text-3xl sm:text-4xl font-bold text-foreground mb-2 tracking-tight">
            Conecta con AgroTrade
          </h2>
          <p className="text-base text-muted-foreground max-w-2xl font-normal">
            Atención a productores, consumidores e inversionistas.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-1 space-y-4">
            <div className="p-6 rounded-2xl bg-card border border-border shadow-xs flex flex-col items-start">
              <div className="w-11 h-11 rounded-xl bg-[#E6F4EA] flex items-center justify-center mb-3.5 text-primary">
                <Mail className="w-5.5 h-5.5" />
              </div>
              <h3 className="text-sm font-bold text-foreground mb-0.5">Email Oficial</h3>
              <a href="mailto:AgroTradeStartup0@gmail.com" className="text-primary font-semibold hover:underline text-xs sm:text-sm">
                AgroTradeStartup0@gmail.com
              </a>
            </div>

            <div className="p-6 rounded-2xl bg-card border border-border shadow-xs flex flex-col items-start">
              <div className="w-11 h-11 rounded-xl bg-[#E6F4EA] flex items-center justify-center mb-3.5 text-primary">
                <MapPin className="w-5.5 h-5.5" />
              </div>
              <h3 className="text-sm font-bold text-foreground mb-0.5">Ubicación Central</h3>
              <p className="text-muted-foreground text-xs sm:text-sm">Managua, Nicaragua</p>
            </div>

            <div className="p-6 rounded-2xl bg-card border border-border shadow-xs flex flex-col items-start">
              <div className="w-11 h-11 rounded-xl bg-[#E6F4EA] flex items-center justify-center mb-3.5 text-primary">
                <Clock className="w-5.5 h-5.5" />
              </div>
              <h3 className="text-sm font-bold text-foreground mb-0.5">Tiempo de Respuesta</h3>
              <p className="text-muted-foreground text-xs sm:text-sm">Menos de 24 horas</p>
            </div>
          </div>

          <div className="lg:col-span-2">
            <form onSubmit={handleSubmit} className="space-y-4 sm:space-y-5 p-6 sm:p-8 rounded-2xl bg-card border border-border shadow-xs">
              <div>
                <label htmlFor="nombre" className="block text-xs sm:text-sm font-semibold text-foreground mb-1.5">
                  Nombre completo
                </label>
                <input
                  type="text"
                  id="nombre"
                  name="nombre"
                  value={formData.nombre}
                  onChange={handleChange}
                  required
                  placeholder="Tu nombre"
                  className="w-full px-4 py-3 rounded-xl border border-border bg-[#F1F5F9] text-foreground placeholder:text-muted-foreground/70 focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary focus:bg-card transition-all text-sm font-medium"
                />
              </div>

              <div>
                <label htmlFor="email" className="block text-xs sm:text-sm font-semibold text-foreground mb-1.5">
                  Correo electrónico
                </label>
                <input
                  type="email"
                  id="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  required
                  placeholder="tu@email.com"
                  className="w-full px-4 py-3 rounded-xl border border-border bg-[#F1F5F9] text-foreground placeholder:text-muted-foreground/70 focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary focus:bg-card transition-all text-sm font-medium"
                />
              </div>

              <div>
                <label htmlFor="tipo" className="block text-xs sm:text-sm font-semibold text-foreground mb-1.5">
                  Tipo de usuario
                </label>
                <select
                  id="tipo"
                  name="tipo"
                  value={formData.tipo}
                  onChange={handleChange}
                  className="w-full px-4 py-3 rounded-xl border border-border bg-[#F1F5F9] text-foreground focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary focus:bg-card transition-all text-sm font-medium"
                >
                  <option value="consumidor">Consumidor</option>
                  <option value="productor">Productor Agrícola</option>
                  <option value="inversor">Inversor</option>
                  <option value="otro">Otro</option>
                </select>
              </div>

              <div>
                <label htmlFor="mensaje" className="block text-xs sm:text-sm font-semibold text-foreground mb-1.5">
                  Mensaje o Solicitud
                </label>
                <textarea
                  id="mensaje"
                  name="mensaje"
                  value={formData.mensaje}
                  onChange={handleChange}
                  required
                  placeholder="Cuéntanos cómo podemos ayudarte..."
                  rows={4}
                  className="w-full px-4 py-3 rounded-xl border border-border bg-[#F1F5F9] text-foreground placeholder:text-muted-foreground/70 focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary focus:bg-card transition-all text-sm font-medium resize-none"
                />
              </div>

              <Button
                type="submit"
                disabled={submitted}
                className="w-full bg-primary hover:bg-secondary disabled:bg-primary/60 disabled:cursor-not-allowed text-white font-bold py-3 h-12 rounded-full transition-all active:scale-[0.99] shadow-xs text-sm"
              >
                {submitted ? (
                  <span className="flex items-center justify-center gap-2">
                    <CheckCircle2 className="w-4 h-4" /> Mensaje enviado correctamente
                  </span>
                ) : (
                  'Enviar mensaje'
                )}
              </Button>

              {submitted && (
                <p className="text-center text-primary text-xs sm:text-sm font-semibold pt-1">
                  ¡Gracias por tu interés! Nos contactaremos pronto.
                </p>
              )}
            </form>
          </div>
        </div>
      </div>
    </section>
  )
}
