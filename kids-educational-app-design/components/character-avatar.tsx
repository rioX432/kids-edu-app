type AvatarSize = "small" | "medium" | "large"
type Emotion = "happy" | "excited" | "thinking" | "sleeping"

interface CharacterAvatarProps {
  size?: AvatarSize
  emotion?: Emotion
  characterColor?: string
  image?: string
}

export function CharacterAvatar({
  size = "medium",
  emotion = "happy",
  characterColor = "--color-character-1",
  image,
}: CharacterAvatarProps) {
  const sizeStyles = {
    small: "w-16 h-16",
    medium: "w-24 h-24",
    large: "w-32 h-32",
  }

  const emotionIndicators = {
    happy: "😊",
    excited: "🤩",
    thinking: "🤔",
    sleeping: "😴",
  }

  return (
    <div className="relative inline-block">
      <div
        className={`
          ${sizeStyles[size]} rounded-full 
          border-4 border-white shadow-lg
          flex items-center justify-center
          text-4xl
        `}
        style={{ backgroundColor: `var(${characterColor})` }}
      >
        {image ? (
          <img src={image || "/placeholder.svg"} alt="Character" className="w-full h-full rounded-full object-cover" />
        ) : (
          <span>{emotionIndicators[emotion]}</span>
        )}
      </div>

      {/* Emotion Badge */}
      <div className="absolute -bottom-1 -right-1 w-8 h-8 rounded-full bg-white border-2 border-[var(--color-text-disabled-light)] flex items-center justify-center text-sm shadow-md">
        {emotionIndicators[emotion]}
      </div>
    </div>
  )
}
