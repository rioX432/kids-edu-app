"use client"

import { useState, useEffect } from "react"
import { X } from "lucide-react"

interface ParentGateProps {
  isOpen: boolean
  onClose: () => void
  onSuccess: () => void
}

export function ParentGate({ isOpen, onClose, onSuccess }: ParentGateProps) {
  const [num1] = useState(() => Math.floor(Math.random() * 5) + 1)
  const [num2] = useState(() => Math.floor(Math.random() * 5) + 1)
  const [answer, setAnswer] = useState("")
  const [isHolding, setIsHolding] = useState(false)
  const [holdProgress, setHoldProgress] = useState(0)

  useEffect(() => {
    if (!isOpen) {
      setAnswer("")
      setIsHolding(false)
      setHoldProgress(0)
    }
  }, [isOpen])

  useEffect(() => {
    let interval: NodeJS.Timeout
    if (isHolding && Number.parseInt(answer) === num1 + num2) {
      interval = setInterval(() => {
        setHoldProgress((prev) => {
          if (prev >= 100) {
            clearInterval(interval)
            onSuccess()
            return 0
          }
          return prev + 4
        })
      }, 30)
    } else {
      setHoldProgress(0)
    }
    return () => clearInterval(interval)
  }, [isHolding, answer, num1, num2, onSuccess])

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center p-6 z-50">
      <div className="bg-[var(--color-surface-light)] rounded-[var(--radius-xl)] p-8 max-w-md w-full shadow-2xl">
        <div className="flex justify-between items-start mb-6">
          <div>
            <h2 className="text-2xl font-sans font-bold text-[var(--color-text-primary-light)] mb-2">
              Parent Verification
            </h2>
            <p className="text-sm text-[var(--color-text-secondary-light)]">This area is for adults only</p>
          </div>
          <button
            onClick={onClose}
            className="w-10 h-10 rounded-full hover:bg-gray-100 flex items-center justify-center transition-colors"
          >
            <X className="w-5 h-5 text-[var(--color-text-secondary-light)]" />
          </button>
        </div>

        <div className="space-y-6">
          {/* Math Problem */}
          <div className="bg-[var(--color-bg-light)] rounded-[var(--radius-lg)] p-6 text-center">
            <p className="text-base text-[var(--color-text-secondary-light)] mb-4">Solve this simple math problem:</p>
            <p className="text-4xl font-sans font-bold text-[var(--color-text-primary-light)]">
              {num1} + {num2} = ?
            </p>
          </div>

          {/* Answer Input */}
          <div>
            <label className="block text-sm font-sans font-medium text-[var(--color-text-primary-light)] mb-2">
              Your answer:
            </label>
            <input
              type="number"
              value={answer}
              onChange={(e) => setAnswer(e.target.value)}
              className="w-full h-14 px-4 text-xl font-sans text-[var(--color-text-primary-light)] bg-white border-2 border-[var(--color-text-disabled-light)] rounded-[var(--radius-md)] focus:border-[var(--color-book-primary)] focus:outline-none transition-colors"
              placeholder="Enter answer"
            />
          </div>

          {/* Long Press Button */}
          <div>
            <p className="text-sm text-[var(--color-text-secondary-light)] mb-2 text-center">
              Hold the button below for 3 seconds
            </p>
            <button
              onMouseDown={() => Number.parseInt(answer) === num1 + num2 && setIsHolding(true)}
              onMouseUp={() => setIsHolding(false)}
              onMouseLeave={() => setIsHolding(false)}
              onTouchStart={() => Number.parseInt(answer) === num1 + num2 && setIsHolding(true)}
              onTouchEnd={() => setIsHolding(false)}
              disabled={Number.parseInt(answer) !== num1 + num2}
              className={`
                relative w-full h-16 rounded-[var(--radius-md)] font-sans font-semibold text-white
                transition-all duration-200 overflow-hidden
                ${
                  Number.parseInt(answer) === num1 + num2
                    ? "bg-[var(--color-book-primary)] hover:bg-[var(--color-book-secondary)] cursor-pointer"
                    : "bg-[var(--color-text-disabled-light)] cursor-not-allowed"
                }
              `}
            >
              <div
                className="absolute inset-0 bg-[var(--color-success)] transition-all duration-100"
                style={{ width: `${holdProgress}%` }}
              />
              <span className="relative z-10">{isHolding ? "Keep holding..." : "Hold to Continue"}</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
