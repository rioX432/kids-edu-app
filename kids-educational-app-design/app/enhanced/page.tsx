"use client"

import * as React from "react"
import Link from "next/link"
import { EnhancedButton } from "@/components/enhanced-button"
import { CelebrationModal } from "@/components/celebration-modal"
import { CloudTransition } from "@/components/cloud-transition"
import { EyeFollower } from "@/components/eye-follower"
import { CaterpillarProgress } from "@/components/caterpillar-progress"

export default function EnhancedComponentsPage() {
  const [showModal, setShowModal] = React.useState(false)
  const [isTransitioning, setIsTransitioning] = React.useState(false)
  const [progress, setProgress] = React.useState(0)

  const handleTransition = () => {
    setIsTransitioning(true)
    setTimeout(() => setIsTransitioning(false), 800)
  }

  return (
    <CloudTransition isTransitioning={isTransitioning}>
      <div className="min-h-screen bg-[var(--color-background)] p-8">
        <div className="max-w-6xl mx-auto space-y-12">
          {/* Header */}
          <div className="text-center space-y-4">
            <h1 className="font-sans font-bold text-4xl text-[var(--color-text)]">Enhanced Components Showcase</h1>
            <p className="font-body text-lg text-[var(--color-text-secondary)]">
              Interactive components designed for kids aged 3-5
            </p>
            <Link href="/" className="inline-block text-[var(--color-learning-primary)] hover:underline">
              ← Back to Design System
            </Link>
          </div>

          {/* Enhanced Buttons */}
          <section className="space-y-6">
            <h2 className="font-sans font-bold text-3xl text-[var(--color-text)]">1. Enhanced Buttons</h2>
            <div className="bg-white rounded-3xl p-8 space-y-6">
              <div className="flex flex-wrap gap-4">
                <EnhancedButton variant="primary" icon="🎨" particles="stars">
                  Primary Button
                </EnhancedButton>
                <EnhancedButton variant="secondary" icon="🌈" particles="flowers">
                  Secondary Button
                </EnhancedButton>
                <EnhancedButton variant="ghost" particles="sparkles">
                  Ghost Button
                </EnhancedButton>
                <EnhancedButton variant="primary" loading>
                  Loading
                </EnhancedButton>
                <EnhancedButton variant="primary" disabled>
                  Disabled
                </EnhancedButton>
              </div>
              <div className="flex gap-4">
                <EnhancedButton variant="primary" size="large" icon="🚀" particles="stars">
                  Large Button
                </EnhancedButton>
              </div>
            </div>
          </section>

          {/* Celebration Modal */}
          <section className="space-y-6">
            <h2 className="font-sans font-bold text-3xl text-[var(--color-text)]">2. Celebration Modal</h2>
            <div className="bg-white rounded-3xl p-8">
              <EnhancedButton variant="primary" icon="🎉" onClick={() => setShowModal(true)}>
                Show Celebration
              </EnhancedButton>
            </div>
          </section>

          {/* Cloud Transition */}
          <section className="space-y-6">
            <h2 className="font-sans font-bold text-3xl text-[var(--color-text)]">3. Cloud Transition</h2>
            <div className="bg-white rounded-3xl p-8">
              <EnhancedButton variant="primary" icon="☁️" onClick={handleTransition}>
                Trigger Cloud Transition
              </EnhancedButton>
            </div>
          </section>

          {/* Eye Follower */}
          <section className="space-y-6">
            <h2 className="font-sans font-bold text-3xl text-[var(--color-text)]">4. Eye Follower</h2>
            <div className="bg-white rounded-3xl p-8 flex flex-col items-center gap-8">
              <p className="text-[var(--color-text-secondary)]">Move your mouse around to see the eyes follow!</p>
              <div className="relative">
                <div className="w-32 h-32 rounded-full bg-[var(--color-learning-primary)] flex items-center justify-center">
                  <EyeFollower size={40} />
                </div>
              </div>
              <div className="flex gap-8">
                <div className="w-24 h-24 rounded-full bg-[var(--color-picture-primary)] flex items-center justify-center">
                  <EyeFollower size={32} />
                </div>
                <div className="w-24 h-24 rounded-full bg-[var(--color-learning-secondary)] flex items-center justify-center">
                  <EyeFollower size={32} />
                </div>
              </div>
            </div>
          </section>

          {/* Caterpillar Progress */}
          <section className="space-y-6">
            <h2 className="font-sans font-bold text-3xl text-[var(--color-text)]">5. Caterpillar Progress Indicator</h2>
            <div className="bg-white rounded-3xl p-8 space-y-6">
              <CaterpillarProgress progress={progress} className="mb-8" />
              <div className="flex gap-4">
                <EnhancedButton variant="secondary" onClick={() => setProgress(Math.max(0, progress - 20))}>
                  -20%
                </EnhancedButton>
                <EnhancedButton variant="primary" onClick={() => setProgress(Math.min(100, progress + 20))}>
                  +20%
                </EnhancedButton>
                <EnhancedButton variant="ghost" onClick={() => setProgress(0)}>
                  Reset
                </EnhancedButton>
              </div>
            </div>
          </section>
        </div>

        {/* Celebration Modal Component */}
        <CelebrationModal
          open={showModal}
          onClose={() => setShowModal(false)}
          title="Amazing Work!"
          emoji="🌟"
          stars={3}
          badge="🏆"
        />
      </div>
    </CloudTransition>
  )
}
