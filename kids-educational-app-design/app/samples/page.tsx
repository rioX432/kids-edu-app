"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, Sun, Moon } from "lucide-react"
import { ChoiceButton } from "@/components/choice-button"
import { CharacterAvatar } from "@/components/character-avatar"
import { ProgressIndicator } from "@/components/progress-indicator"

export default function SamplesPage() {
  const [nightMode, setNightMode] = useState(false)

  return (
    <main className="min-h-screen p-6 md:p-12">
      <div className="max-w-7xl mx-auto">
        <Link
          href="/"
          className="inline-flex items-center gap-2 text-[var(--color-text-secondary-light)] hover:text-[var(--color-text-primary-light)] mb-8 transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Home
        </Link>

        <h1 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">Sample Screens</h1>
        <p className="text-xl text-[var(--color-text-secondary-light)] mb-12 max-w-3xl">
          Complete screen examples showing the design system in action.
        </p>

        <div className="space-y-12">
          {/* Learning App - Quiz Screen */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Learning App - Quiz Screen
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Energetic, cheerful design for active learning (3-7 minute sessions)
            </p>

            <div className="bg-gradient-to-br from-[var(--color-learning-secondary)] to-[var(--color-learning-primary)] rounded-[var(--radius-xl)] p-8 md:p-12 shadow-xl">
              {/* Progress */}
              <div className="mb-8">
                <ProgressIndicator current={2} total={5} variant="stars" />
              </div>

              {/* Character & Question */}
              <div className="flex items-start gap-6 mb-8">
                <CharacterAvatar size="large" emotion="happy" characterColor="--color-character-1" />
                <div className="flex-1 bg-white rounded-[var(--radius-xl)] p-6 shadow-lg">
                  <h3 className="text-4xl font-display font-bold text-[var(--color-text-primary-light)] leading-tight">
                    Which one is a fruit?
                  </h3>
                  <p className="text-2xl text-[var(--color-text-secondary-light)] mt-2">(どれがくだもの?)</p>
                </div>
              </div>

              {/* Choices */}
              <div className="space-y-4">
                <ChoiceButton state="default" icon={<div className="text-5xl">🍎</div>}>
                  Apple (りんご)
                </ChoiceButton>
                <ChoiceButton state="default" icon={<div className="text-5xl">🚗</div>}>
                  Car (くるま)
                </ChoiceButton>
                <ChoiceButton state="default" icon={<div className="text-5xl">⭐</div>}>
                  Star (ほし)
                </ChoiceButton>
              </div>
            </div>
          </section>

          {/* Picture Book App - Reading Screen */}
          <section>
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)]">
                Picture Book App - Reading Screen
              </h2>
              <button
                onClick={() => setNightMode(!nightMode)}
                className="flex items-center gap-2 px-4 py-2 rounded-[var(--radius-lg)] bg-[var(--color-surface-light)] hover:bg-gray-100 transition-colors shadow-sm"
              >
                {nightMode ? (
                  <>
                    <Sun className="w-5 h-5" />
                    <span className="font-medium">Day Mode</span>
                  </>
                ) : (
                  <>
                    <Moon className="w-5 h-5" />
                    <span className="font-medium">Night Mode</span>
                  </>
                )}
              </button>
            </div>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Calm, relaxing design for bedtime reading (10-15 minute sessions)
            </p>

            <div
              className={`rounded-[var(--radius-xl)] p-8 md:p-12 shadow-xl transition-all duration-500 ${
                nightMode
                  ? "bg-[var(--color-book-night-bg)]"
                  : "bg-gradient-to-br from-[var(--color-book-tertiary)] to-[var(--color-book-primary)]"
              }`}
            >
              {/* Book Content */}
              <div
                className="bg-white/95 rounded-[var(--radius-xl)] p-8 md:p-12 mb-8 shadow-lg"
                style={
                  nightMode
                    ? {
                        backgroundColor: "var(--color-book-night-surface)",
                      }
                    : {}
                }
              >
                {/* Illustration Placeholder */}
                <div
                  className="w-full aspect-video rounded-[var(--radius-lg)] mb-6 flex items-center justify-center"
                  style={
                    nightMode
                      ? {
                          backgroundColor: "var(--color-book-night-bg)",
                        }
                      : {
                          backgroundColor: "var(--color-book-secondary)",
                        }
                  }
                >
                  <div className="text-8xl">🌙</div>
                </div>

                {/* Story Text */}
                <p
                  className="text-2xl md:text-3xl font-sans leading-relaxed text-center"
                  style={
                    nightMode
                      ? {
                          color: "var(--color-book-night-text)",
                        }
                      : {
                          color: "var(--color-text-primary-light)",
                        }
                  }
                >
                  The little rabbit looked up at the moon and smiled.
                </p>
                <p
                  className="text-xl md:text-2xl mt-4 text-center"
                  style={
                    nightMode
                      ? {
                          color: "var(--color-text-secondary-dark)",
                        }
                      : {
                          color: "var(--color-text-secondary-light)",
                        }
                  }
                >
                  小さなウサギは月を見上げてにっこり笑いました。
                </p>
              </div>

              {/* Navigation */}
              <div className="flex items-center justify-between">
                <button
                  className={`w-16 h-16 rounded-full flex items-center justify-center transition-all ${
                    nightMode
                      ? "bg-[var(--color-book-night-surface)] hover:bg-[var(--color-book-night-primary)]"
                      : "bg-white hover:bg-white/80"
                  } shadow-lg`}
                >
                  <svg
                    className={`w-8 h-8 ${nightMode ? "text-white" : "text-[var(--color-book-primary)]"}`}
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M15 19l-7-7 7-7" />
                  </svg>
                </button>

                <div className="flex items-center gap-6">
                  <CharacterAvatar size="medium" emotion="sleeping" characterColor="--color-character-4" />
                  <ProgressIndicator current={3} total={8} variant="dots" />
                </div>

                <button
                  className={`w-16 h-16 rounded-full flex items-center justify-center transition-all ${
                    nightMode
                      ? "bg-[var(--color-book-night-surface)] hover:bg-[var(--color-book-night-primary)]"
                      : "bg-white hover:bg-white/80"
                  } shadow-lg`}
                >
                  <svg
                    className={`w-8 h-8 ${nightMode ? "text-white" : "text-[var(--color-book-primary)]"}`}
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M9 5l7 7-7 7" />
                  </svg>
                </button>
              </div>
            </div>
          </section>

          {/* Character Selection (Shared) */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Character Selection (Shared Experience)
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">Onboarding flow shared between both apps</p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 md:p-12 shadow-xl">
              <div className="text-center mb-8">
                <h3 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
                  Choose Your Friend!
                </h3>
                <p className="text-2xl text-[var(--color-text-secondary-light)]">お友だちをえらぼう!</p>
              </div>

              <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
                {[
                  { color: "--color-character-1", emoji: "🦊", name: "Fox" },
                  { color: "--color-character-2", emoji: "🐧", name: "Penguin" },
                  { color: "--color-character-3", emoji: "🐻", name: "Bear" },
                  { color: "--color-character-4", emoji: "🐰", name: "Rabbit" },
                ].map((character, index) => (
                  <button
                    key={index}
                    className="flex flex-col items-center gap-4 p-6 rounded-[var(--radius-xl)] bg-[var(--color-bg-light)] hover:bg-gray-100 hover:scale-105 active:scale-95 transition-all"
                  >
                    <div
                      className="w-24 h-24 rounded-full flex items-center justify-center text-5xl border-4 border-white shadow-lg"
                      style={{ backgroundColor: `var(${character.color})` }}
                    >
                      {character.emoji}
                    </div>
                    <span className="text-xl font-display font-bold text-[var(--color-text-primary-light)]">
                      {character.name}
                    </span>
                  </button>
                ))}
              </div>
            </div>
          </section>
        </div>
      </div>
    </main>
  )
}
