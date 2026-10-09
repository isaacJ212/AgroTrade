import { Analytics } from '@vercel/analytics/next'
import type { Metadata, Viewport } from 'next'
import { Raleway } from 'next/font/google'
import './globals.css'

const raleway = Raleway({
  subsets: ['latin'],
  weight: ['400', '500', '600', '700', '800'],
  display: 'swap',
  variable: '--font-raleway',
})

export const metadata: Metadata = {
  title: 'AgroTrade - Conectamos el campo con tu mesa',
  description: 'AgroTrade : Plataforma de conexión directa entre agricultores y consumidores. Precios justos, productos frescos, sin intermediarios. Hackathon Nicaragua 2026.',
  generator: 'v0.app',
  icons: {
    icon: '/LogoApp.png',
    shortcut: '/LogoApp.png',
    apple: '/LogoApp.png',
  },
}

export const viewport: Viewport = {
  colorScheme: 'light',
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#006E2C' },
  ],
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="es" className={`${raleway.variable} light bg-background`}>
      <body className="antialiased font-sans bg-background text-foreground">
        {children}
        {process.env.NODE_ENV === 'production' && <Analytics />}
      </body>
    </html>
  )
}
