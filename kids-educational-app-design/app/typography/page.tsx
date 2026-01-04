import Link from "next/link"
import { ArrowLeft } from "lucide-react"

export default function TypographyPage() {
  return (
    <main className="min-h-screen p-6 md:p-12">
      <div className="max-w-4xl mx-auto">
        <Link
          href="/"
          className="inline-flex items-center gap-2 text-[var(--color-text-secondary-light)] hover:text-[var(--color-text-primary-light)] mb-8 transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Home
        </Link>

        <h1 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">Typography</h1>
        <p className="text-xl text-[var(--color-text-secondary-light)] mb-12">
          Font families, scales, and styles optimized for children ages 3-5 with support for Japanese and English.
        </p>

        {/* Font Families */}
        <section className="mb-16">
          <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">Font Families</h2>

          <div className="space-y-6">
            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-2xl font-display font-bold text-[var(--color-text-primary-light)]">
                  Baloo 2 (Display)
                </h3>
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">font-display</span>
              </div>
              <p className="text-[var(--color-text-secondary-light)] mb-6">
                Used for headings, titles, and playful UI elements. Rounded, friendly appearance.
              </p>
              <div className="space-y-2">
                <p className="font-display text-5xl">ABC abc 123 あいう</p>
                <p className="text-sm text-[var(--color-text-secondary-light)]">Weights: 400, 500, 600, 700, 800</p>
              </div>
            </div>

            <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-2xl font-display font-bold text-[var(--color-text-primary-light)]">
                  Fredoka (Body)
                </h3>
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">font-sans</span>
              </div>
              <p className="text-[var(--color-text-secondary-light)] mb-6">
                Used for body text, labels, and readable content. Excellent legibility at small sizes.
              </p>
              <div className="space-y-2">
                <p className="font-sans text-2xl">ABC abc 123 あいう</p>
                <p className="text-sm text-[var(--color-text-secondary-light)]">Weights: 300, 400, 500, 600, 700</p>
              </div>
            </div>
          </div>
        </section>

        {/* Typography Scale */}
        <section className="mb-16">
          <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">
            Typography Scale
          </h2>

          <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 space-y-8">
            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-6xl / 3.75rem</span>
              </div>
              <h1 className="text-6xl font-display font-bold text-[var(--color-text-primary-light)]">Heading 1</h1>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">App titles, onboarding screens</p>
            </div>

            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-5xl / 3rem</span>
              </div>
              <h2 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)]">Heading 2</h2>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Section titles, activity titles</p>
            </div>

            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-4xl / 2.25rem</span>
              </div>
              <h3 className="text-4xl font-display font-bold text-[var(--color-text-primary-light)]">Heading 3</h3>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Question text, story titles</p>
            </div>

            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-2xl / 1.5rem</span>
              </div>
              <p className="text-2xl font-sans font-medium text-[var(--color-text-primary-light)]">Large Body Text</p>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Button labels, choice options</p>
            </div>

            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-lg / 1.125rem</span>
              </div>
              <p className="text-lg font-sans text-[var(--color-text-primary-light)]">Body Text</p>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">Story content, descriptions</p>
            </div>

            <div>
              <div className="flex items-baseline justify-between mb-2">
                <span className="text-sm text-[var(--color-text-secondary-light)] font-mono">text-base / 1rem</span>
              </div>
              <p className="text-base font-sans text-[var(--color-text-secondary-light)]">Small Text / Captions</p>
              <p className="text-sm text-[var(--color-text-secondary-light)] mt-2">
                Hints, helper text (minimal usage)
              </p>
            </div>
          </div>
        </section>

        {/* Usage Guidelines */}
        <section>
          <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">
            Usage Guidelines
          </h2>

          <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
            <ul className="space-y-4">
              <li className="flex items-start gap-3">
                <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
                <div>
                  <strong className="text-[var(--color-text-primary-light)]">Minimal text principle:</strong>
                  <p className="text-[var(--color-text-secondary-light)]">
                    Children ages 3-5 cannot read. Use text sparingly and always combine with visual cues.
                  </p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
                <div>
                  <strong className="text-[var(--color-text-primary-light)]">Line height:</strong>
                  <p className="text-[var(--color-text-secondary-light)]">
                    Use 1.4-1.6 (leading-relaxed or leading-6) for better readability.
                  </p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
                <div>
                  <strong className="text-[var(--color-text-primary-light)]">Font weights:</strong>
                  <p className="text-[var(--color-text-secondary-light)]">
                    Use bold (600-700) for important elements. Avoid thin weights that are hard to read.
                  </p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
                <div>
                  <strong className="text-[var(--color-text-primary-light)]">Bilingual support:</strong>
                  <p className="text-[var(--color-text-secondary-light)]">
                    Both Fredoka and Baloo 2 support Japanese characters with good readability.
                  </p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
                <div>
                  <strong className="text-[var(--color-text-primary-light)]">Contrast:</strong>
                  <p className="text-[var(--color-text-secondary-light)]">
                    Always ensure sufficient contrast between text and background (WCAG AA minimum).
                  </p>
                </div>
              </li>
            </ul>
          </div>
        </section>
      </div>
    </main>
  )
}
