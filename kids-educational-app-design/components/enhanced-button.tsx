"use client"

import * as React from "react"
import { motion, useAnimation } from "framer-motion"
import { cn } from "@/lib/utils"
import { Loader2 } from "lucide-react"

type ParticleType = "stars" | "flowers" | "sparkles" | "none"

interface EnhancedButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "ghost"
  size?: "default" | "large"
  icon?: React.ReactNode
  loading?: boolean
  particles?: ParticleType
  breathe?: boolean
}

interface Particle {
  id: number
  x: number
  y: number
  rotation: number
  scale: number
}

export function EnhancedButton({
  children,
  variant = "primary",
  size = "default",
  icon,
  loading = false,
  particles = "stars",
  breathe = true,
  disabled,
  className,
  onClick,
  ...props
}: EnhancedButtonProps) {
  const [particleList, setParticleList] = React.useState<Particle[]>([])
  const [pressPoint, setPressPoint] = React.useState({ x: 0.5, y: 0.5 })
  const buttonRef = React.useRef<HTMLButtonElement>(null)
  const controls = useAnimation()

  const handlePress = (e: React.MouseEvent<HTMLButtonElement> | React.TouchEvent<HTMLButtonElement>) => {
    if (disabled || loading) return

    const rect = buttonRef.current?.getBoundingClientRect()
    if (!rect) return

    let clientX: number, clientY: number

    if ("touches" in e) {
      clientX = e.touches[0].clientX
      clientY = e.touches[0].clientY
    } else {
      clientX = e.clientX
      clientY = e.clientY
    }

    const x = (clientX - rect.left) / rect.width
    const y = (clientY - rect.top) / rect.height

    setPressPoint({ x, y })

    if (particles !== "none") {
      const newParticles: Particle[] = Array.from({ length: 8 }, (_, i) => ({
        id: Date.now() + i,
        x: clientX - rect.left,
        y: clientY - rect.top,
        rotation: Math.random() * 360,
        scale: 0.8 + Math.random() * 0.4,
      }))
      setParticleList((prev) => [...prev, ...newParticles])

      setTimeout(() => {
        setParticleList((prev) => prev.filter((p) => !newParticles.find((n) => n.id === p.id)))
      }, 1000)
    }
  }

  const particleIcon = {
    stars: "⭐",
    flowers: "🌸",
    sparkles: "✨",
    none: "",
  }[particles]

  return (
    <div className="relative inline-block">
      <motion.button
        ref={buttonRef}
        className={cn(
          "relative overflow-hidden font-sans font-bold transition-colors disabled:opacity-50 disabled:cursor-not-allowed",
          size === "default" && "h-16 px-8 text-lg",
          size === "large" && "h-20 px-10 text-xl",
          "rounded-[24px]",
          variant === "primary" && "bg-[var(--color-learning-primary)] text-white shadow-lg active:shadow-md",
          variant === "secondary" &&
            "border-4 border-[var(--color-learning-primary)] text-[var(--color-learning-primary)] bg-transparent",
          variant === "ghost" && "bg-transparent text-[var(--color-learning-primary)]",
          className,
        )}
        disabled={disabled || loading}
        onClick={onClick}
        onMouseDown={handlePress}
        onTouchStart={handlePress}
        animate={
          breathe && !disabled && !loading
            ? {
                scale: [1, 1.02, 1],
              }
            : {}
        }
        transition={{
          scale: {
            repeat: Number.POSITIVE_INFINITY,
            duration: 2,
            ease: "easeInOut",
          },
        }}
        whileTap={
          !disabled && !loading
            ? {
                scale: 0.95,
                rotateZ: [(pressPoint.x - 0.5) * 2, 0],
                rotateX: [(pressPoint.y - 0.5) * -5, 0],
              }
            : {}
        }
        style={{
          transformOrigin: `${pressPoint.x * 100}% ${pressPoint.y * 100}%`,
        }}
        {...props}
      >
        <span className="relative z-10 flex items-center justify-center gap-3">
          {loading && <Loader2 className="h-6 w-6 animate-spin" />}
          {!loading && icon && <span className="text-2xl">{icon}</span>}
          {children}
        </span>

        {/* Ripple effect */}
        <motion.span
          className={cn(
            "absolute inset-0 rounded-[24px]",
            variant === "primary" && "bg-white/20",
            variant === "secondary" && "bg-[var(--color-learning-primary)]/10",
          )}
          initial={{ scale: 0, opacity: 0.5 }}
          animate={{ scale: 2, opacity: 0 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
        />
      </motion.button>

      {/* Particle effects */}
      {particleList.map((particle) => (
        <motion.div
          key={particle.id}
          className="pointer-events-none absolute text-2xl"
          initial={{
            x: particle.x,
            y: particle.y,
            scale: particle.scale,
            rotate: particle.rotation,
            opacity: 1,
          }}
          animate={{
            x: particle.x + (Math.random() - 0.5) * 100,
            y: particle.y - Math.random() * 80 - 40,
            rotate: particle.rotation + (Math.random() - 0.5) * 180,
            opacity: 0,
            scale: 0,
          }}
          transition={{
            duration: 0.8,
            ease: "easeOut",
          }}
        >
          {particleIcon}
        </motion.div>
      ))}
    </div>
  )
}
