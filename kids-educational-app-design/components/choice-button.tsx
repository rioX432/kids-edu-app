"use client"

import type { ReactNode } from "react"
import { Check, X } from "lucide-react"

type ChoiceButtonState = "default" | "selected" | "correct" | "incorrect"

interface ChoiceButtonProps {
  children: ReactNode
  state?: ChoiceButtonState
  onClick?: () => void
  icon?: ReactNode
}

export function ChoiceButton({ children, state = "default", onClick, icon }: ChoiceButtonProps) {
  const stateStyles = {
    default:
      "bg-white border-4 border-[var(--color-text-disabled-light)] hover:border-[var(--color-learning-primary)] hover:scale-105 active:scale-95",
    selected:
      "bg-[var(--color-learning-secondary)] border-4 border-[var(--color-learning-primary)] scale-105 shadow-lg",
    correct: "bg-[var(--color-success)] border-4 border-[#4CAF50] scale-105 shadow-lg",
    incorrect: "bg-[var(--color-error-gentle)] border-4 border-[#FF8A80] scale-95 opacity-75",
  }

  return (
    <button
      onClick={onClick}
      className={`
        relative w-full min-h-[4rem] p-6 rounded-[var(--radius-xl)]
        transition-all duration-300 ease-out
        flex items-center justify-start gap-4
        ${stateStyles[state]}
      `}
      disabled={state === "correct" || state === "incorrect"}
    >
      {/* Icon */}
      {icon && (
        <div className="flex-shrink-0 w-16 h-16 rounded-[var(--radius-lg)] bg-white/50 flex items-center justify-center">
          {icon}
        </div>
      )}

      {/* Content */}
      <span className="flex-1 text-2xl font-display font-bold text-[var(--color-text-primary-light)] text-left">
        {children}
      </span>

      {/* State Indicator */}
      {state === "correct" && (
        <div className="flex-shrink-0 w-12 h-12 rounded-full bg-white flex items-center justify-center animate-bounce">
          <Check className="w-8 h-8 text-[#4CAF50] stroke-[3]" />
        </div>
      )}
      {state === "incorrect" && (
        <div className="flex-shrink-0 w-12 h-12 rounded-full bg-white flex items-center justify-center">
          <X className="w-8 h-8 text-[#FF8A80] stroke-[3]" />
        </div>
      )}
    </button>
  )
}
