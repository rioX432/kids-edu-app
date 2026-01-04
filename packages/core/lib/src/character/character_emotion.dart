/// Character emotions for visual feedback.
enum CharacterEmotion {
  /// Default happy state.
  happy,

  /// Excited state (after correct answer, reward).
  excited,

  /// Thinking state (during quiz, waiting).
  thinking,

  /// Sleeping state (night mode, picture book).
  sleeping,

  /// Sad state (after incorrect answer - used gently).
  sad,

  /// Encouraging state (after multiple mistakes).
  encouraging,
}

/// Extension for emotion-related utilities.
extension CharacterEmotionX on CharacterEmotion {
  /// Get the asset suffix for this emotion.
  String get assetSuffix => name;

  /// Whether this emotion is positive.
  bool get isPositive => this == CharacterEmotion.happy ||
                         this == CharacterEmotion.excited ||
                         this == CharacterEmotion.encouraging;
}
