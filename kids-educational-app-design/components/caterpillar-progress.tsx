"use client"

import * as React from "react"
import { motion } from "framer-motion"

interface CaterpillarProgressProps {
  progress: number // 0-100
  className?: string
}

export function CaterpillarProgress({ progress, className }: CaterpillarProgressProps) {
  const [isEating, setIsEating] = React.useState(false)
  const [isBlinking, setIsBlinking] = React.useState(false)
  const segments = Math.floor((progress / 100) * 5)
  const isComplete = progress >= 100

  React.useEffect(() => {
    const blinkInterval = setInterval(
      () => {
        if (Math.random() > 0.5) {
          setIsBlinking(true)
          setTimeout(() => setIsBlinking(false), 150)
        }
      },
      2000 + Math.random() * 2000,
    )

    return () => clearInterval(blinkInterval)
  }, [])

  React.useEffect(() => {
    if (progress > 0 && progress < 100) {
      setIsEating(true)
      setTimeout(() => setIsEating(false), 400)
    }
  }, [progress])

  if (isComplete) {
    return (
      <div className={className}>
        {/* Butterfly transformation */}
        <motion.div
          className="flex flex-col items-center gap-4"
          initial={{ scale: 0, rotate: -180 }}
          animate={{ scale: 1, rotate: 0 }}
          transition={{
            type: "spring",
            stiffness: 200,
            damping: 15,
          }}
        >
          <motion.div
            className="text-6xl"
            animate={{
              y: [-5, 5, -5],
            }}
            transition={{
              duration: 2,
              repeat: Number.POSITIVE_INFINITY,
              ease: "easeInOut",
            }}
          >
            🦋
          </motion.div>
          <div className="font-sans font-bold text-2xl text-[var(--color-learning-primary)]">Complete!</div>
        </motion.div>
      </div>
    )
  }

  return (
    <div className={className}>
      <div className="relative h-24 flex items-center">
        {/* Path with leaves */}
        <div className="absolute inset-0 flex items-center justify-between px-4">
          {[...Array(5)].map((_, i) => (
            <motion.div
              key={i}
              className="text-3xl"
              initial={{ opacity: 1, scale: 1 }}
              animate={{
                opacity: i < segments ? 0 : 1,
                scale: i < segments ? 0 : 1,
              }}
              transition={{ duration: 0.3 }}
            >
              🍃
            </motion.div>
          ))}
        </div>

        {/* Caterpillar */}
        <div className="relative z-10 flex items-center gap-1">
          {/* Head */}
          <motion.div
            className="relative bg-[#6BCF7E] rounded-full w-16 h-16 flex items-center justify-center shadow-lg"
            animate={
              isEating
                ? {
                    scaleX: [1, 0.9, 1],
                  }
                : {
                    y: [0, -2, 0],
                  }
            }
            transition={
              isEating
                ? { duration: 0.4 }
                : {
                    duration: 2,
                    repeat: Number.POSITIVE_INFINITY,
                    ease: "easeInOut",
                  }
            }
          >
            {/* Eyes */}
            <div className="absolute top-4 left-3 flex gap-2">
              <motion.div
                className="w-2 h-3 bg-black rounded-full"
                animate={{ scaleY: isBlinking ? 0.1 : 1 }}
                transition={{ duration: 0.1 }}
              />
              <motion.div
                className="w-2 h-3 bg-black rounded-full"
                animate={{ scaleY: isBlinking ? 0.1 : 1 }}
                transition={{ duration: 0.1 }}
              />
            </div>

            {/* Smile */}
            <div className="absolute bottom-4 left-1/2 -translate-x-1/2 w-6 h-3 border-b-2 border-black rounded-full" />

            {/* Antennae */}
            <div className="absolute -top-2 left-1/2 -translate-x-1/2 flex gap-2">
              <motion.div
                className="w-1 h-4 bg-[#6BCF7E] rounded-full"
                animate={{ rotate: [-10, 10, -10] }}
                transition={{ duration: 1, repeat: Number.POSITIVE_INFINITY }}
              />
              <motion.div
                className="w-1 h-4 bg-[#6BCF7E] rounded-full"
                animate={{ rotate: [10, -10, 10] }}
                transition={{ duration: 1, repeat: Number.POSITIVE_INFINITY }}
              />
            </div>

            {/* Mouth animation when eating */}
            {isEating && (
              <motion.div
                className="absolute bottom-2 left-1/2 -translate-x-1/2 text-2xl"
                initial={{ opacity: 0 }}
                animate={{ opacity: [0, 1, 0] }}
                transition={{ duration: 0.4 }}
              >
                😋
              </motion.div>
            )}
          </motion.div>

          {/* Body segments */}
          {[...Array(segments)].map((_, i) => (
            <motion.div
              key={i}
              className="bg-gradient-to-r from-[#6BCF7E] to-[#5BB56D] rounded-full w-12 h-12 shadow-md"
              initial={{ scale: 0, x: -20 }}
              animate={{
                scale: 1,
                x: 0,
                y: i % 2 === 0 ? [0, -2, 0] : [0, 2, 0],
              }}
              transition={{
                scale: { duration: 0.3 },
                y: {
                  duration: 2,
                  delay: i * 0.1,
                  repeat: Number.POSITIVE_INFINITY,
                  ease: "easeInOut",
                },
              }}
            />
          ))}
        </div>

        {/* Progress text */}
        <div className="absolute right-0 top-1/2 -translate-y-1/2 font-sans font-bold text-xl text-[var(--color-text-secondary)]">
          {progress}%
        </div>
      </div>
    </div>
  )
}
