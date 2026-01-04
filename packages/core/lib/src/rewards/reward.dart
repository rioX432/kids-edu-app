/// Base class for rewards.
abstract class Reward {
  const Reward({
    required this.id,
    required this.type,
    required this.name,
    required this.nameJa,
    this.description,
    this.assetPath,
  });

  /// Unique identifier.
  final String id;

  /// Type of reward.
  final RewardType type;

  /// Display name (English).
  final String name;

  /// Display name (Japanese).
  final String nameJa;

  /// Optional description.
  final String? description;

  /// Asset path for the reward image/icon.
  final String? assetPath;
}

/// Types of rewards.
enum RewardType {
  /// Accessories for character (hats, glasses, etc.).
  accessory,

  /// Background themes.
  background,

  /// Stamp for stamp book.
  stamp,

  /// Badge/achievement.
  badge,
}

/// Accessory reward for character.
class AccessoryReward extends Reward {
  const AccessoryReward({
    required super.id,
    required super.name,
    required super.nameJa,
    required this.category,
    super.description,
    super.assetPath,
  }) : super(type: RewardType.accessory);

  /// Category of accessory.
  final AccessoryCategory category;
}

/// Categories of accessories.
enum AccessoryCategory {
  hat,
  glasses,
  scarf,
  bow,
  necklace,
}

/// Badge/achievement reward.
class BadgeReward extends Reward {
  const BadgeReward({
    required super.id,
    required super.name,
    required super.nameJa,
    required this.condition,
    super.description,
    super.assetPath,
  }) : super(type: RewardType.badge);

  /// Condition to unlock this badge.
  final UnlockCondition condition;
}

/// Condition to unlock a reward.
class UnlockCondition {
  const UnlockCondition({
    required this.trigger,
    this.value,
  });

  /// What triggers the unlock.
  final UnlockTrigger trigger;

  /// Required value (e.g., 5 for "streak of 5 days").
  final int? value;

  /// Check if this condition is met.
  bool isMet({
    int? streakDays,
    int? characterLevel,
    int? totalDays,
    int? stampBooksCompleted,
  }) {
    switch (trigger) {
      case UnlockTrigger.streak:
        return streakDays != null && value != null && streakDays >= value!;
      case UnlockTrigger.level:
        return characterLevel != null && value != null && characterLevel >= value!;
      case UnlockTrigger.totalDays:
        return totalDays != null && value != null && totalDays >= value!;
      case UnlockTrigger.stampBookComplete:
        return stampBooksCompleted != null && value != null && stampBooksCompleted >= value!;
      case UnlockTrigger.immediate:
        return true;
    }
  }
}

/// Triggers for unlocking rewards.
enum UnlockTrigger {
  /// Achieve a certain streak.
  streak,

  /// Reach a certain character level.
  level,

  /// Accumulate a certain number of active days.
  totalDays,

  /// Complete a stamp book.
  stampBookComplete,

  /// Immediately unlocked (e.g., first-time bonus).
  immediate,
}
