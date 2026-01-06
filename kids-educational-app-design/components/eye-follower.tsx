"use client"

import * as React from "react"
import { motion, useSpring } from "framer-motion"

interface EyeFollowerProps {
  size?: number
  className?: string
}

export function EyeFollower({ size = 48, className }: EyeFollowerProps) {
  const [mousePos, setMousePos] = React.useState({ x: 0, y: 0 })
  const [isBlinking, setIsBlinking] = React.useState(false)
  const [isSurprised, setIsSurprised] = React.useState(false)
  const containerRef = React.useRef<HTMLDivElement>(null)

  const smoothMouseX = useSpring(0, { stiffness: 100, damping: 20 })
  const smoothMouseY = useSpring(0, { stiffness: 100, damping: 20 })

  React.useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (!containerRef.current) return

      const rect = containerRef.current.getBoundingClientRect()
      const centerX = rect.left + rect.width / 2
      const centerY = rect.top + rect.height / 2

      const deltaX = e.clientX - centerX
      const deltaY = e.clientY - centerY

      const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
      const maxDistance = 300
      const speed = distance / 10

      if (speed > 50) {
        setIsSurprised(true)
        setTimeout(() => setIsSurprised(false), 500)
      }

      const angle = Math.atan2(deltaY, deltaX)
      const maxLook = size * 0.25
      const lookDistance = Math.min(distance / maxDistance, 1) * maxLook

      smoothMouseX.set(Math.cos(angle) * lookDistance)
      smoothMouseY.set(Math.sin(angle) * lookDistance)
    }

    window.addEventListener("mousemove", handleMouseMove)
    return () => window.removeEventListener("mousemove", handleMouseMove)
  }, [size, smoothMouseX, smoothMouseY])

  React.useEffect(() => {
    const blinkInterval = setInterval(
      () => {
        if (Math.random() > 0.3) {
          setIsBlinking(true)
          setTimeout(() => setIsBlinking(false), 150)
        }
      },
      3000 + Math.random() * 2000,
    )

    return () => clearInterval(blinkInterval)
  }, [])

  React.useEffect(() => {
    const idleMovement = setInterval(() => {
      if (Math.random() > 0.7) {
        const randomX = (Math.random() - 0.5) * size * 0.1
        const randomY = (Math.random() - 0.5) * size * 0.1
        smoothMouseX.set(randomX)
        smoothMouseY.set(randomY)
      }
    }, 2000)

    return () => clearInterval(idleMovement)
  }, [size, smoothMouseX, smoothMouseY])

  return (
    <div ref={containerRef} className={className} style={{ width: size * 2.2, height: size }}>
      <div className="flex gap-2 items-center justify-center h-full">
        {/* Left Eye */}
        <Eye
          size={size}
          smoothX={smoothMouseX}
          smoothY={smoothMouseY}
          isBlinking={isBlinking}
          isSurprised={isSurprised}
        />

        {/* Right Eye */}
        <Eye
          size={size}
          smoothX={smoothMouseX}
          smoothY={smoothMouseY}
          isBlinking={isBlinking}
          isSurprised={isSurprised}
        />
      </div>
    </div>
  )
}

function Eye({
  size,
  smoothX,
  smoothY,
  isBlinking,
  isSurprised,
}: {
  size: number
  smoothX: any
  smoothY: any
  isBlinking: boolean
  isSurprised: boolean
}) {
  return (
    <motion.div
      className="relative bg-white rounded-full shadow-inner flex items-center justify-center"
      style={{ width: size, height: size }}
      animate={isSurprised ? { scale: 1.2 } : { scale: 1 }}
      transition={{ duration: 0.2 }}
    >
      {/* Eyelid for blinking */}
      <motion.div
        className="absolute inset-0 bg-[var(--color-learning-secondary)] rounded-full origin-top z-10"
        initial={{ scaleY: 0 }}
        animate={{ scaleY: isBlinking ? 1 : 0 }}
        transition={{ duration: 0.1 }}
      />

      {/* Pupil */}
      <motion.div
        className="bg-black rounded-full shadow-lg"
        style={{
          width: size * 0.4,
          height: size * 0.4,
          x: smoothX,
          y: smoothY,
        }}
      >
        {/* Highlight */}
        <div
          className="absolute top-1/4 left-1/4 bg-white rounded-full"
          style={{
            width: size * 0.12,
            height: size * 0.12,
          }}
        />
      </motion.div>
    </motion.div>
  )
}
