'use client'

import { HeroSection } from '@/components/hero-section'
import { SocialSection } from '@/components/social-section'
import { AboutSection } from '@/components/about-section'
import { ContactSection } from '@/components/contact-section'
import { Footer } from '@/components/footer'

export default function Home() {
  return (
    <main className="min-h-screen bg-background">
      <HeroSection />
      <AboutSection />
      <SocialSection />
      <ContactSection />
      <Footer />
    </main>
  )
}
