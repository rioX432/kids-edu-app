import Link from "next/link"
import { Palette, BookOpen, Smile, Layout, Sparkles } from "lucide-react"

export default function Home() {
  const sections = [
    {
      title: "Color Palette",
      description: "Shared base colors, app-specific accents, and night mode variants",
      href: "/colors",
      icon: Palette,
      color: "bg-[var(--color-learning-primary)]",
    },
    {
      title: "Typography",
      description: "Font families, sizes, and styles optimized for young children",
      href: "/typography",
      icon: BookOpen,
      color: "bg-[var(--color-book-primary)]",
    },
    {
      title: "Components",
      description: "UI components with states designed for ages 3-5",
      href: "/components",
      icon: Layout,
      color: "bg-[var(--color-learning-tertiary)]",
    },
    {
      title: "Sample Screens",
      description: "Learning App, Picture Book App, and shared experiences",
      href: "/samples",
      icon: Sparkles,
      color: "bg-[var(--color-book-secondary)]",
    },
  ]

  return (
    <main className="min-h-screen p-6 md:p-12">
      <div className="max-w-6xl mx-auto">
        <header className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-[var(--radius-xl)] bg-gradient-to-br from-[var(--color-learning-primary)] to-[var(--color-learning-tertiary)] mb-6">
            <Smile className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-5xl md:text-6xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
            Kids Educational App Suite
          </h1>
          <p className="text-xl text-[var(--color-text-secondary-light)] max-w-2xl mx-auto">
            A cohesive design system for learning and picture book apps targeting children ages 3-5
          </p>
        </header>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-12">
          {sections.map((section) => {
            const Icon = section.icon
            return (
              <Link
                key={section.href}
                href={section.href}
                className="group block p-8 bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] shadow-sm hover:shadow-lg transition-all duration-300 hover:-translate-y-1"
              >
                <div
                  className={`inline-flex items-center justify-center w-16 h-16 rounded-[var(--radius-lg)] ${section.color} mb-4 group-hover:scale-110 transition-transform`}
                >
                  <Icon className="w-8 h-8 text-white" />
                </div>
                <h2 className="text-2xl font-display font-bold text-[var(--color-text-primary-light)] mb-2">
                  {section.title}
                </h2>
                <p className="text-[var(--color-text-secondary-light)]">{section.description}</p>
              </Link>
            )
          })}
        </div>

        <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 shadow-sm">
          <h2 className="text-2xl font-display font-bold text-[var(--color-text-primary-light)] mb-4">
            Design Principles
          </h2>
          <ul className="space-y-3 text-[var(--color-text-secondary-light)]">
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">Large touch targets</strong> - Minimum
                48x48dp, prefer 64x64dp+ for comfortable interaction
              </span>
            </li>
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">High contrast</strong> - Ensuring readability
                for young eyes
              </span>
            </li>
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">Rounded, friendly shapes</strong> - No sharp
                edges, welcoming design
              </span>
            </li>
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">Minimal text</strong> - Rely on icons and
                illustrations
              </span>
            </li>
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">Clear visual feedback</strong> - Every
                interaction provides obvious response
              </span>
            </li>
            <li className="flex items-start gap-3">
              <span className="inline-block w-2 h-2 rounded-full bg-[var(--color-success)] mt-2 flex-shrink-0" />
              <span>
                <strong className="text-[var(--color-text-primary-light)]">No anxiety</strong> - Gentle error states,
                encouraging feedback
              </span>
            </li>
          </ul>
        </div>
      </div>
    </main>
  )
}
