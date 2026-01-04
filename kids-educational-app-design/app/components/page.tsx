"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, Heart, Book, Music, Palette } from "lucide-react"
import { ChoiceButton } from "@/components/choice-button"
import { CharacterAvatar } from "@/components/character-avatar"
import { ProgressIndicator } from "@/components/progress-indicator"
import { RewardModal } from "@/components/reward-modal"
import { ParentGate } from "@/components/parent-gate"
import { ActivityCard } from "@/components/activity-card"

export default function ComponentsPage() {
  const [choiceState, setChoiceState] = useState<"default" | "selected" | "correct" | "incorrect">("default")
  const [showReward, setShowReward] = useState(false)
  const [showParentGate, setShowParentGate] = useState(false)
  const [progress, setProgress] = useState(3)

  return (
    <main className="min-h-screen p-6 md:p-12">
      <div className="max-w-6xl mx-auto">
        <Link
          href="/"
          className="inline-flex items-center gap-2 text-[var(--color-text-secondary-light)] hover:text-[var(--color-text-primary-light)] mb-8 transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Home
        </Link>

        <h1 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">Components</h1>
        <p className="text-xl text-[var(--color-text-secondary-light)] mb-12 max-w-3xl">
          Interactive UI components with all states designed for children ages 3-5.
        </p>

        <div className="space-y-16">
          {/* Choice Buttons */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Choice Buttons
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              For quiz options and selections. Large touch targets (64dp+) with clear visual feedback.
            </p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 space-y-8">
              <div className="space-y-4">
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)]">
                  Interactive Demo
                </h3>
                <div className="flex gap-4 mb-4">
                  <button
                    onClick={() => setChoiceState("default")}
                    className="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm font-medium"
                  >
                    Default
                  </button>
                  <button
                    onClick={() => setChoiceState("selected")}
                    className="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm font-medium"
                  >
                    Selected
                  </button>
                  <button
                    onClick={() => setChoiceState("correct")}
                    className="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm font-medium"
                  >
                    Correct
                  </button>
                  <button
                    onClick={() => setChoiceState("incorrect")}
                    className="px-4 py-2 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm font-medium"
                  >
                    Incorrect
                  </button>
                </div>
                <ChoiceButton
                  state={choiceState}
                  icon={<Heart className="w-10 h-10 text-[var(--color-learning-tertiary)]" />}
                >
                  Apple (りんご)
                </ChoiceButton>
              </div>

              <div className="space-y-4">
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)]">
                  All States
                </h3>
                <ChoiceButton
                  state="default"
                  icon={<Heart className="w-10 h-10 text-[var(--color-learning-tertiary)]" />}
                >
                  Default State
                </ChoiceButton>
                <ChoiceButton state="selected" icon={<Book className="w-10 h-10 text-[var(--color-book-primary)]" />}>
                  Selected State
                </ChoiceButton>
                <ChoiceButton state="correct" icon={<Music className="w-10 h-10 text-white" />}>
                  Correct Answer! (正解!)
                </ChoiceButton>
                <ChoiceButton state="incorrect" icon={<Palette className="w-10 h-10 text-white" />}>
                  Try Again (もう一度)
                </ChoiceButton>
              </div>
            </div>
          </section>

          {/* Character Avatars */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Character Avatars
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Circular displays for animal characters with emotion indicators. Multiple sizes available.
            </p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
              <div className="space-y-8">
                <div>
                  <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)] mb-4">
                    Sizes
                  </h3>
                  <div className="flex items-end gap-6">
                    <div className="text-center">
                      <CharacterAvatar size="small" characterColor="--color-character-1" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Small</p>
                    </div>
                    <div className="text-center">
                      <CharacterAvatar size="medium" characterColor="--color-character-2" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Medium</p>
                    </div>
                    <div className="text-center">
                      <CharacterAvatar size="large" characterColor="--color-character-3" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Large</p>
                    </div>
                  </div>
                </div>

                <div>
                  <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)] mb-4">
                    Emotions
                  </h3>
                  <div className="flex items-center gap-6">
                    <div className="text-center">
                      <CharacterAvatar emotion="happy" characterColor="--color-character-1" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Happy</p>
                    </div>
                    <div className="text-center">
                      <CharacterAvatar emotion="excited" characterColor="--color-character-2" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Excited</p>
                    </div>
                    <div className="text-center">
                      <CharacterAvatar emotion="thinking" characterColor="--color-character-3" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Thinking</p>
                    </div>
                    <div className="text-center">
                      <CharacterAvatar emotion="sleeping" characterColor="--color-character-4" />
                      <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Sleeping</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </section>

          {/* Progress Indicators */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Progress Indicators
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Visual progress through activities. Rewarding feedback without feeling like loading bars.
            </p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 space-y-8">
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)]">
                    Stars Variant
                  </h3>
                  <div className="flex gap-2">
                    <button
                      onClick={() => setProgress(Math.max(0, progress - 1))}
                      className="px-3 py-1 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm"
                    >
                      -
                    </button>
                    <button
                      onClick={() => setProgress(Math.min(5, progress + 1))}
                      className="px-3 py-1 rounded-lg bg-gray-200 hover:bg-gray-300 text-sm"
                    >
                      +
                    </button>
                  </div>
                </div>
                <ProgressIndicator current={progress} total={5} variant="stars" />
              </div>

              <div className="space-y-4">
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)]">
                  Dots Variant
                </h3>
                <ProgressIndicator current={progress} total={5} variant="dots" />
              </div>

              <div className="space-y-4">
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)]">
                  Steps Variant
                </h3>
                <div className="overflow-x-auto pb-4">
                  <ProgressIndicator current={progress} total={5} variant="steps" />
                </div>
              </div>
            </div>
          </section>

          {/* Activity Cards */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
              Activity Cards
            </h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Tappable cards for book covers and activity tiles with clear affordance.
            </p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                <ActivityCard title="Colors" icon={<Palette className="w-12 h-12 text-white" />} />
                <ActivityCard title="Music" icon={<Music className="w-12 h-12 text-white" />} />
                <ActivityCard title="Locked" icon={<Book className="w-12 h-12 text-white" />} locked />
              </div>
            </div>
          </section>

          {/* Modals */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">Modals</h2>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Reward popups and parent gate for different user experiences.
            </p>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 space-y-4">
              <div>
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)] mb-4">
                  Reward Modal
                </h3>
                <button
                  onClick={() => setShowReward(true)}
                  className="px-6 py-3 bg-[var(--color-learning-primary)] hover:bg-[var(--color-learning-secondary)] text-white font-display font-bold rounded-[var(--radius-lg)] transition-colors"
                >
                  Show Reward
                </button>
              </div>

              <div>
                <h3 className="text-xl font-display font-semibold text-[var(--color-text-primary-light)] mb-4">
                  Parent Gate
                </h3>
                <button
                  onClick={() => setShowParentGate(true)}
                  className="px-6 py-3 bg-[var(--color-book-primary)] hover:bg-[var(--color-book-secondary)] text-white font-display font-bold rounded-[var(--radius-lg)] transition-colors"
                >
                  Show Parent Gate
                </button>
              </div>
            </div>
          </section>
        </div>

        {/* Modal Instances */}
        <RewardModal
          isOpen={showReward}
          onClose={() => setShowReward(false)}
          title="Great Job!"
          message="You earned a star! (星をゲット!)"
        />

        <ParentGate
          isOpen={showParentGate}
          onClose={() => setShowParentGate(false)}
          onSuccess={() => {
            setShowParentGate(false)
            alert("Parent verification successful!")
          }}
        />
      </div>
    </main>
  )
}
