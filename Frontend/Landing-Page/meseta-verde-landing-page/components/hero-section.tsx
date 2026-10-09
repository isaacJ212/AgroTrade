'use client'

import { useState } from 'react'
import { Leaf, Download, ArrowRight, ShieldCheck, X, AlertTriangle } from 'lucide-react'
import { Button } from '@/components/ui/button'

const APK_DRIVE_ID = '1OQlD8Hk8uxePmoq-1PgOnIyXlDhEz_qz'
const APK_DOWNLOAD_URL = `https://drive.google.com/uc?export=download&id=${APK_DRIVE_ID}`

function DisclaimerModal({ onClose, onAccept }: { onClose: () => void; onAccept: () => void }) {
  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ backgroundColor: 'rgba(17, 24, 39, 0.65)', backdropFilter: 'blur(8px)' }}
      onClick={onClose}
    >
      <div
        className="relative bg-white text-foreground border border-border rounded-2xl shadow-2xl max-w-md w-full p-6 sm:p-8 flex flex-col gap-5 animate-in fade-in zoom-in-95 duration-200"
        onClick={(e) => e.stopPropagation()}
      >
        <button
          onClick={onClose}
          className="absolute top-4 right-4 text-muted-foreground hover:text-foreground transition-colors p-1.5 rounded-full hover:bg-muted"
          aria-label="Cerrar"
        >
          <X className="w-5 h-5" />
        </button>

        <div className="flex justify-center pt-1">
          <div className="w-14 h-14 rounded-2xl bg-[#E6F4EA] flex items-center justify-center">
            <ShieldCheck className="w-7 h-7 text-[#006E2C]" />
          </div>
        </div>

        <div className="text-center">
          <h2 className="text-2xl font-extrabold text-foreground tracking-tight">Antes de descargar</h2>
          <p className="text-sm font-medium text-muted-foreground mt-1">AgroTrade APK para Android</p>
        </div>

        <div className="flex gap-3 rounded-xl p-4 bg-amber-50 border-2 border-amber-300">
          <AlertTriangle className="w-5 h-5 shrink-0 mt-0.5 text-amber-700" />
          <p className="text-xs sm:text-sm text-foreground leading-snug">
            <span className="font-bold text-amber-900">Google puede mostrarte una advertencia.</span>{' '}
            Es un aviso estándar al instalar APKs externos. Puedes continuar con total seguridad.
          </p>
        </div>

        <ul className="flex flex-col gap-2.5 bg-muted/60 p-4 rounded-xl border border-border text-xs sm:text-sm">
          {[
            '✓ Sin virus ni software malicioso',
            '✓ Desarrollada para Hackathon Nicaragua 2026',
            '✓ Únicamente solicita permisos esenciales',
            '✓ Privacidad garantizada de tus datos',
          ].map((item) => (
            <li key={item} className="text-foreground font-semibold flex items-center gap-2">
              {item}
            </li>
          ))}
        </ul>

        <div className="rounded-xl p-4 text-xs text-muted-foreground space-y-1 bg-muted border border-border">
          <p className="font-bold text-foreground mb-1">Pasos de instalación:</p>
          <p>1. Descarga el archivo APK.</p>
          <p>2. Si aparece aviso, presiona <strong>&quot;Descargar de todos modos&quot;</strong>.</p>
          <p>3. Abre el archivo y presiona <strong>&quot;Instalar&quot;</strong>.</p>
        </div>

        <div className="flex gap-3 pt-1">
          <Button
            variant="outline"
            className="flex-1 h-12 rounded-full border-border bg-muted hover:bg-muted/80 text-foreground font-bold text-sm"
            onClick={onClose}
          >
            Cancelar
          </Button>
          <Button
            className="flex-1 h-12 rounded-full bg-[#006E2C] hover:bg-[#00531F] text-white font-bold text-sm shadow-md"
            onClick={onAccept}
          >
            <Download className="w-4 h-4 mr-2" />
            Descargar APK
          </Button>
        </div>
      </div>
    </div>
  )
}

export function HeroSection() {
  const [showModal, setShowModal] = useState(false)

  const handleDownloadApp = () => setShowModal(true)

  const handleAcceptDownload = () => {
    setShowModal(false)
    window.open(APK_DOWNLOAD_URL, '_blank')
  }

  const handleProducerSignup = () => {
    const contactSection = document.getElementById('conecta')
    if (contactSection) {
      contactSection.scrollIntoView({ behavior: 'smooth' })
    }
  }

  return (
    <>
      {showModal && (
        <DisclaimerModal
          onClose={() => setShowModal(false)}
          onAccept={handleAcceptDownload}
        />
      )}

      <section className="relative min-h-[90vh] w-full flex items-center justify-center px-4 py-16 sm:py-24 bg-background">
        <div className="max-w-4xl mx-auto w-full text-center">
          <div className="mb-8 sm:mb-10">
            <img
              src="/AgroTrade.png"
              alt="AgroTrade Logo"
              className="h-28 sm:h-36 lg:h-40 w-auto mx-auto object-contain"
            />
          </div>

          {/* Pill Badge matching Sidebar Resumen pill style */}
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full mb-6 bg-[#E6F4EA] border border-[#006E2C]/20">
            <Leaf className="w-4 h-4 text-[#006E2C]" />
            <span className="text-xs sm:text-sm font-bold text-[#006E2C]">Hackathon Nicaragua 2026</span>
          </div>

          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-foreground mb-6 tracking-tight leading-[1.15]">
            Conectamos el campo<br />
            <span className="text-[#006E2C]">con tu mesa</span>
          </h1>

          <p className="text-base sm:text-lg lg:text-xl text-muted-foreground max-w-2xl mx-auto mb-10 font-normal leading-relaxed">
            Supervisá y conectá directamente a agricultores con consumidores. Precios justos, productos frescos y sin intermediarios.
          </p>

          <div className="flex flex-col sm:flex-row gap-3.5 justify-center mb-14">
            <Button
              onClick={handleDownloadApp}
              size="lg"
              className="bg-[#006E2C] hover:bg-[#00531F] text-white font-bold px-8 h-12 sm:h-13 rounded-full shadow-md hover:shadow-lg transition-all active:scale-[0.99] text-base"
            >
              <Download className="w-5 h-5 mr-2" />
              Descargar App
            </Button>
            <Button
              onClick={handleProducerSignup}
              size="lg"
              variant="outline"
              className="font-bold px-8 h-12 sm:h-13 rounded-full border-2 border-[#006E2C] text-[#006E2C] bg-white hover:bg-[#E6F4EA] active:scale-[0.99] transition-all text-base"
            >
              Ser Productor
              <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </div>

          {/* Cards matching exact Dashboard KPI cards style */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 max-w-2xl mx-auto">
            <div className="bg-white border border-border rounded-2xl p-5 shadow-sm text-left relative overflow-hidden">
              <div className="flex justify-between items-center mb-2">
                <span className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">CONEXIÓN DIRECTA</span>
                <span className="text-xs font-bold text-[#0284C7] bg-[#E0F2FE] px-2.5 py-0.5 rounded-md">+100%</span>
              </div>
              <div className="text-3xl font-extrabold text-foreground">100%</div>
            </div>

            <div className="bg-white border border-border rounded-2xl p-5 shadow-sm text-left relative overflow-hidden">
              <div className="flex justify-between items-center mb-2">
                <span className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">INTERMEDIARIOS</span>
                <span className="text-xs font-bold text-[#16A34A] bg-[#DCFCE7] px-2.5 py-0.5 rounded-md">Directo</span>
              </div>
              <div className="text-3xl font-extrabold text-foreground">0</div>
            </div>

            <div className="bg-white border-2 border-amber-400 rounded-2xl p-5 shadow-sm text-left relative overflow-hidden">
              <div className="flex justify-between items-center mb-2">
                <span className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">MODELO SOSTENIBLE</span>
                <span className="w-2.5 h-2.5 rounded-full bg-amber-400 inline-block"></span>
              </div>
              <div className="text-3xl font-extrabold text-foreground">Activo</div>
            </div>
          </div>
        </div>
      </section>
    </>
  )
}
