"use client"

import * as React from "react"
import { motion, AnimatePresence } from "framer-motion"
import { EnhancedButton } from "./enhanced-button"

interface CelebrationModalProps {
  open: boolean
  onClose: () => void
  title: string
  emoji?: string
  stars?: 1 | 2 | 3
  badge?: string
}

interface Confetti {
  id: number
  x: number
  color: string
  delay: number
  duration: number
}

export function CelebrationModal({ open, onClose, title, emoji = "🎉", stars = 3, badge }: CelebrationModalProps) {
  const [confettiList, setConfettiList] = React.useState<Confetti[]>([])

  React.useEffect(() => {
    if (open) {
      const colors = ["#FFD700", "#FF8C42", "#FF6B9D", "#6BCF7E", "#4A90E2"]
      const newConfetti: Confetti[] = Array.from({ length: 50 }, (_, i) => ({
        id: i,
        x: Math.random() * 100,
        color: colors[Math.floor(Math.random() * colors.length)],
        delay: Math.random() * 0.5,
        duration: 2 + Math.random() * 1,
      }))
      setConfettiList(newConfetti)
    }
  }, [open])

  return (
    <AnimatePresence>
      {open && (
        <motion.div
          className="fixed inset-0 z-50 flex items-center justify-center p-4"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
        >
          {/* Backdrop */}
          <motion.div
            className="absolute inset-0 bg-black/40 backdrop-blur-sm"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
          />

          {/* Confetti */}
          {confettiList.map((confetti) => (
            <motion.div
              key={confetti.id}
              className="absolute top-0 w-3 h-3 rounded-full"
              style={{
                left: `${confetti.x}%`,
                backgroundColor: confetti.color,
              }}
              initial={{ y: -20, rotate: 0, opacity: 1 }}
              animate={{
                y: window.innerHeight + 20,
                rotate: 720,
                opacity: 0,
              }}
              transition={{
                duration: confetti.duration,
                delay: confetti.delay,
                ease: "easeIn",
              }}
            />
          ))}

          {/* Modal Card */}
          <motion.div
            className="relative z-10 bg-[var(--color-background)] rounded-[32px] p-8 max-w-md w-full shadow-2xl"
            initial={{ scale: 0, rotate: -10 }}
            animate={{ scale: 1, rotate: 0 }}
            exit={{ scale: 0, rotate: 10 }}
            transition={{
              type: "spring",
              stiffness: 200,
              damping: 15,
            }}
          >
            {/* Dancing Emoji */}
            <motion.div
              className="flex justify-center mb-6"
              animate={{
                rotate: [0, -10, 10, -10, 10, 0],
                scale: [1, 1.1, 0.9, 1.1, 0.9, 1],
              }}
              transition={{
                duration: 1,
                repeat: Number.POSITIVE_INFINITY,
                repeatDelay: 1,
              }}
            >
              <div className="text-[96px] leading-none">{emoji}</div>
            </motion.div>

            {/* Title */}
            <h2 className="font-sans font-bold text-3xl text-center mb-6 text-[var(--color-text)]">{title}</h2>

            {/* Star Rating */}
            <div className="flex justify-center gap-4 mb-6">
              {Array.from({ length: 3 }).map((_, i) => (
                <motion.div
                  key={i}
                  initial={{ scale: 0, rotate: -180 }}
                  animate={{ scale: 1, rotate: 0 }}
                  transition={{
                    delay: 0.3 + i * 0.15,
                    type: "spring",
                    stiffness: 200,
                  }}
                >
                  <div className={cn("text-5xl", i < stars ? "opacity-100" : "opacity-30")}>⭐</div>
                </motion.div>
              ))}
            </div>

            {/* Badge */}
            {badge && (
              <motion.div
                className="flex justify-center mb-8"
                initial={{ scale: 0, rotate: 0 }}
                animate={{ scale: 1, rotate: 360 }}
                transition={{
                  delay: 0.8,
                  type: "spring",
                  stiffness: 150,
                }}
              >
                <div className="bg-gradient-to-br from-[#FFD700] to-[#FF8C42] rounded-full p-6 text-4xl shadow-lg">
                  {badge}
                </div>
              </motion.div>
            )}

            {/* Dismiss Button */}
            <EnhancedButton variant="primary" size="large" className="w-full" onClick={onClose} particles="stars">
              Continue
            </EnhancedButton>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}

function cn(...classes: (string | boolean | undefined)[]) {
  return classes.filter(Boolean).join(" ")
}
