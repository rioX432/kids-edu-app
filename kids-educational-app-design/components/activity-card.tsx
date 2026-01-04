"use client"

import type { ReactNode } from "react"
import { Lock } from "lucide-react"

interface ActivityCardProps {
  title: string
  icon: ReactNode
  locked?: boolean
  onClick?: () => void
}

export function ActivityCard({ title, icon, locked = false, onClick }: ActivityCardProps) {
  return (
    <button
      onClick={!locked ? onClick : undefined}
      disabled={locked}
      className={`
        relative w-full aspect-square rounded-[var(--radius-xl)] p-6
        flex flex-col items-center justify-center gap-4
        transition-all duration-300
        ${
          locked
            ? "bg-[var(--color-text-disabled-light)] opacity-50 cursor-not-allowed"
            : "bg-gradient-to-br from-[var(--color-learning-primary)] to-[var(--color-learning-tertiary)] hover:scale-105 active:scale-95 shadow-lg hover:shadow-xl"
        }
      `}
    >
      {locked && (
        <div className="absolute top-4 right-4 w-8 h-8 rounded-full bg-white flex items-center justify-center">
          <Lock className="w-5 h-5 text-[var(--color-text-primary-light)]" />
        </div>
      )}

      <div className="w-20 h-20 rounded-[var(--radius-lg)] bg-white/30 flex items-center justify-center">{icon}</div>

      <h3 className="text-2xl font-display font-bold text-white text-center">{title}</h3>
    </button>
  )
}
