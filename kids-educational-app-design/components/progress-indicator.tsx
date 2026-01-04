interface ProgressIndicatorProps {
  current: number
  total: number
  variant?: "stars" | "dots" | "steps"
}

export function ProgressIndicator({ current, total, variant = "stars" }: ProgressIndicatorProps) {
  if (variant === "stars") {
    return (
      <div className="flex items-center justify-center gap-3">
        {Array.from({ length: total }).map((_, index) => (
          <div
            key={index}
            className={`
              transition-all duration-300
              ${
                index < current
                  ? "w-8 h-8 text-[var(--color-learning-secondary)] scale-110"
                  : "w-6 h-6 text-[var(--color-text-disabled-light)] scale-100"
              }
            `}
          >
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
            </svg>
          </div>
        ))}
      </div>
    )
  }

  if (variant === "dots") {
    return (
      <div className="flex items-center justify-center gap-2">
        {Array.from({ length: total }).map((_, index) => (
          <div
            key={index}
            className={`
              rounded-full transition-all duration-300
              ${index < current ? "w-3 h-3 bg-[var(--color-learning-primary)]" : "w-2 h-2 bg-[var(--color-text-disabled-light)]"}
            `}
          />
        ))}
      </div>
    )
  }

  // Steps variant
  return (
    <div className="flex items-center gap-2">
      {Array.from({ length: total }).map((_, index) => (
        <div key={index} className="flex items-center">
          <div
            className={`
              w-12 h-12 rounded-full flex items-center justify-center
              font-display font-bold text-lg transition-all duration-300
              ${
                index < current
                  ? "bg-[var(--color-success)] text-white scale-110 shadow-lg"
                  : index === current
                    ? "bg-[var(--color-learning-primary)] text-white scale-110 shadow-lg"
                    : "bg-[var(--color-text-disabled-light)] text-white"
              }
            `}
          >
            {index + 1}
          </div>
          {index < total - 1 && (
            <div
              className={`w-8 h-1 rounded ${index < current ? "bg-[var(--color-success)]" : "bg-[var(--color-text-disabled-light)]"}`}
            />
          )}
        </div>
      ))}
    </div>
  )
}
