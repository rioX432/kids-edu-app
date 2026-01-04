"use client"

import type { ReactNode } from "react"
import { Sparkles, X } from "lucide-react"

interface RewardModalProps {
  isOpen: boolean
  onClose: () => void
  title: string
  message?: string
  rewardIcon?: ReactNode
}

export function RewardModal({ isOpen, onClose, title, message, rewardIcon }: RewardModalProps) {
  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center p-6 z-50 animate-in fade-in duration-300">
      <div className="bg-gradient-to-br from-[var(--color-learning-secondary)] to-[var(--color-learning-primary)] rounded-[var(--radius-xl)] p-8 max-w-md w-full shadow-2xl animate-in zoom-in duration-500">
        <div className="flex justify-end mb-4">
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full bg-white/30 hover:bg-white/50 flex items-center justify-center transition-colors"
          >
            <X className="w-6 h-6 text-white" />
          </button>
        </div>

        <div className="text-center">
          {/* Reward Icon */}
          <div className="mb-6 flex justify-center animate-bounce">
            {rewardIcon || (
              <div className="w-32 h-32 rounded-full bg-white flex items-center justify-center shadow-lg">
                <Sparkles className="w-16 h-16 text-[var(--color-learning-primary)]" />
              </div>
            )}
          </div>

          {/* Title */}
          <h2 className="text-5xl font-display font-bold text-white mb-4 drop-shadow-lg">{title}</h2>

          {/* Message */}
          {message && <p className="text-2xl font-sans text-white/90 drop-shadow">{message}</p>}

          {/* Celebration Stars */}
          <div className="flex justify-center gap-2 mt-6">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="w-8 h-8 text-white animate-pulse" style={{ animationDelay: `${i * 0.1}s` }}>
                <svg viewBox="0 0 24 24" fill="currentColor">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                </svg>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )
}
