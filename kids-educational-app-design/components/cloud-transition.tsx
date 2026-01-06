"use client"

import type * as React from "react"
import { motion, AnimatePresence } from "framer-motion"

interface CloudTransitionProps {
  isTransitioning: boolean
  children: React.ReactNode
}

export function CloudTransition({ isTransitioning, children }: CloudTransitionProps) {
  return (
    <div className="relative">
      {children}

      <AnimatePresence>
        {isTransitioning && (
          <>
            {/* Left Cloud */}
            <motion.div
              className="fixed top-0 left-0 w-1/2 h-full z-50 pointer-events-none"
              initial={{ x: "-100%" }}
              animate={{ x: 0 }}
              exit={{ x: "-100%" }}
              transition={{ duration: 0.4, ease: "easeInOut" }}
            >
              <svg viewBox="0 0 500 1000" className="w-full h-full" preserveAspectRatio="none">
                <defs>
                  <linearGradient id="cloudGradient1" x1="0%" y1="0%" x2="100%" y2="100%">
                    <stop offset="0%" stopColor="#ffffff" />
                    <stop offset="100%" stopColor="#e8f4ff" />
                  </linearGradient>
                  <filter id="cloudShadow">
                    <feGaussianBlur in="SourceAlpha" stdDeviation="8" />
                    <feOffset dx="4" dy="4" result="offsetblur" />
                    <feComponentTransfer>
                      <feFuncA type="linear" slope="0.2" />
                    </feComponentTransfer>
                    <feMerge>
                      <feMergeNode />
                      <feMergeNode in="SourceGraphic" />
                    </feMerge>
                  </filter>
                </defs>

                {/* Organic cloud shape */}
                <path
                  d="M 0,0 L 0,1000 L 400,1000 Q 450,800 420,600 Q 400,400 450,200 Q 480,50 450,0 Z"
                  fill="url(#cloudGradient1)"
                  filter="url(#cloudShadow)"
                />

                {/* Cloud bumps for texture */}
                <ellipse cx="350" cy="200" rx="80" ry="60" fill="#ffffff" opacity="0.6" />
                <ellipse cx="380" cy="400" rx="70" ry="50" fill="#ffffff" opacity="0.5" />
                <ellipse cx="360" cy="600" rx="90" ry="70" fill="#ffffff" opacity="0.6" />
                <ellipse cx="370" cy="800" rx="75" ry="55" fill="#ffffff" opacity="0.5" />
              </svg>

              {/* Sparkles */}
              {[...Array(6)].map((_, i) => (
                <motion.div
                  key={i}
                  className="absolute text-2xl"
                  style={{
                    left: `${60 + Math.random() * 20}%`,
                    top: `${10 + i * 15}%`,
                  }}
                  initial={{ opacity: 0, scale: 0 }}
                  animate={{ opacity: [0, 1, 0], scale: [0, 1, 0.5] }}
                  transition={{
                    duration: 0.6,
                    delay: i * 0.1,
                  }}
                >
                  ✨
                </motion.div>
              ))}
            </motion.div>

            {/* Right Cloud */}
            <motion.div
              className="fixed top-0 right-0 w-1/2 h-full z-50 pointer-events-none"
              initial={{ x: "100%" }}
              animate={{ x: 0 }}
              exit={{ x: "100%" }}
              transition={{ duration: 0.4, ease: "easeInOut" }}
            >
              <svg viewBox="0 0 500 1000" className="w-full h-full" preserveAspectRatio="none">
                <defs>
                  <linearGradient id="cloudGradient2" x1="100%" y1="0%" x2="0%" y2="100%">
                    <stop offset="0%" stopColor="#ffffff" />
                    <stop offset="100%" stopColor="#ffe8f4" />
                  </linearGradient>
                </defs>

                {/* Organic cloud shape */}
                <path
                  d="M 500,0 L 500,1000 L 100,1000 Q 50,800 80,600 Q 100,400 50,200 Q 20,50 50,0 Z"
                  fill="url(#cloudGradient2)"
                  filter="url(#cloudShadow)"
                />

                {/* Cloud bumps for texture */}
                <ellipse cx="150" cy="200" rx="80" ry="60" fill="#ffffff" opacity="0.6" />
                <ellipse cx="120" cy="400" rx="70" ry="50" fill="#ffffff" opacity="0.5" />
                <ellipse cx="140" cy="600" rx="90" ry="70" fill="#ffffff" opacity="0.6" />
                <ellipse cx="130" cy="800" rx="75" ry="55" fill="#ffffff" opacity="0.5" />
              </svg>

              {/* Sparkles */}
              {[...Array(6)].map((_, i) => (
                <motion.div
                  key={i}
                  className="absolute text-2xl"
                  style={{
                    left: `${20 + Math.random() * 20}%`,
                    top: `${10 + i * 15}%`,
                  }}
                  initial={{ opacity: 0, scale: 0 }}
                  animate={{ opacity: [0, 1, 0], scale: [0, 1, 0.5] }}
                  transition={{
                    duration: 0.6,
                    delay: i * 0.1,
                  }}
                >
                  ⭐
                </motion.div>
              ))}
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
