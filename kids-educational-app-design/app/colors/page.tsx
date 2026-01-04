import Link from "next/link"
import { ArrowLeft } from "lucide-react"

export default function ColorsPage() {
  const baseColors = [
    { name: "Background Light", var: "--color-bg-light", value: "#FFFBF5" },
    { name: "Background Dark", var: "--color-bg-dark", value: "#1A1C2E" },
    { name: "Surface Light", var: "--color-surface-light", value: "#FFFFFF" },
    { name: "Surface Dark", var: "--color-surface-dark", value: "#252841" },
  ]

  const textColors = [
    { name: "Primary Light", var: "--color-text-primary-light", value: "#2D2D2D" },
    { name: "Primary Dark", var: "--color-text-primary-dark", value: "#F5F5F5" },
    { name: "Secondary Light", var: "--color-text-secondary-light", value: "#6B6B6B" },
    { name: "Secondary Dark", var: "--color-text-secondary-dark", value: "#B8B8B8" },
  ]

  const learningColors = [
    { name: "Primary (Orange)", var: "--color-learning-primary", value: "#FF8C42" },
    { name: "Secondary (Yellow)", var: "--color-learning-secondary", value: "#FFD93D" },
    { name: "Tertiary (Pink)", var: "--color-learning-tertiary", value: "#FF6B9D" },
  ]

  const bookColors = [
    { name: "Primary (Purple)", var: "--color-book-primary", value: "#7B68EE" },
    { name: "Secondary (Blue)", var: "--color-book-secondary", value: "#4A90E2" },
    { name: "Tertiary (Lavender)", var: "--color-book-tertiary", value: "#9B8FD9" },
  ]

  const bookNightColors = [
    { name: "Primary Night", var: "--color-book-night-primary", value: "#5B4DB8" },
    { name: "Secondary Night", var: "--color-book-night-secondary", value: "#3A6FA8" },
    { name: "Background Night", var: "--color-book-night-bg", value: "#0F1119" },
    { name: "Surface Night", var: "--color-book-night-surface", value: "#1C1E2E" },
  ]

  const semanticColors = [
    { name: "Success (Celebration)", var: "--color-success", value: "#6BCF7E" },
    { name: "Error (Gentle)", var: "--color-error-gentle", value: "#FFB3BA" },
  ]

  const characterColors = [
    { name: "Character 1", var: "--color-character-1", value: "#FF9F6E" },
    { name: "Character 2", var: "--color-character-2", value: "#7EC8E3" },
    { name: "Character 3", var: "--color-character-3", value: "#FFD66E" },
    { name: "Character 4", var: "--color-character-4", value: "#C9A0DC" },
  ]

  const ColorSwatch = ({ name, varName, value }: { name: string; varName: string; value: string }) => (
    <div className="flex flex-col gap-3">
      <div
        className="w-full h-24 rounded-[var(--radius-lg)] shadow-sm"
        style={{ backgroundColor: `var(${varName})` }}
      />
      <div>
        <p className="font-display font-semibold text-[var(--color-text-primary-light)]">{name}</p>
        <p className="text-sm text-[var(--color-text-secondary-light)] font-mono">{value}</p>
        <p className="text-xs text-[var(--color-text-disabled-light)] font-mono">{varName}</p>
      </div>
    </div>
  )

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

        <h1 className="text-5xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">Color Palette</h1>
        <p className="text-xl text-[var(--color-text-secondary-light)] mb-12 max-w-3xl">
          Comprehensive color system with semantic naming for shared base colors, app-specific accents, and night mode
          variants.
        </p>

        <div className="space-y-12">
          {/* Base Colors */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">
              Shared Base Colors
            </h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              {baseColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>

          {/* Text Colors */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">Text Colors</h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              {textColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>

          {/* Learning App Colors */}
          <section className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
            <div className="flex items-center gap-3 mb-2">
              <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)]">
                Learning App Accent Palette
              </h2>
            </div>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Energetic, cheerful colors for active learning sessions (3-7 minutes)
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {learningColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>

          {/* Picture Book App Colors */}
          <section className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8">
            <div className="flex items-center gap-3 mb-2">
              <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)]">
                Picture Book App Accent Palette
              </h2>
            </div>
            <p className="text-[var(--color-text-secondary-light)] mb-6">
              Calm, relaxing colors for bedtime reading (10-15 minutes)
            </p>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {bookColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>

          {/* Night Mode Colors */}
          <section className="bg-[var(--color-book-night-bg)] rounded-[var(--radius-xl)] p-8">
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-dark)] mb-2">
              Picture Book Night Mode
            </h2>
            <p className="text-[var(--color-text-secondary-dark)] mb-6">
              Dimmed palette for comfortable bedtime reading
            </p>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              {bookNightColors.map((color) => (
                <div key={color.var} className="flex flex-col gap-3">
                  <div
                    className="w-full h-24 rounded-[var(--radius-lg)] shadow-sm"
                    style={{ backgroundColor: `var(${color.var})` }}
                  />
                  <div>
                    <p className="font-display font-semibold text-[var(--color-text-primary-dark)]">{color.name}</p>
                    <p className="text-sm text-[var(--color-text-secondary-dark)] font-mono">{color.value}</p>
                    <p className="text-xs text-[var(--color-text-disabled-dark)] font-mono">{color.var}</p>
                  </div>
                </div>
              ))}
            </div>
          </section>

          {/* Semantic Colors */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">
              Semantic Colors
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {semanticColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>

          {/* Character Colors */}
          <section>
            <h2 className="text-3xl font-display font-bold text-[var(--color-text-primary-light)] mb-6">
              Character Colors
            </h2>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
              {characterColors.map((color) => (
                <ColorSwatch key={color.var} name={color.name} varName={color.var} value={color.value} />
              ))}
            </div>
          </section>
        </div>
      </div>
    </main>
  )
}
