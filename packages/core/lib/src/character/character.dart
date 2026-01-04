import 'package:hive/hive.dart';

import 'character_emotion.dart';
import 'character_type.dart';

part 'character.g.dart';

/// Character state and progression data.
@HiveType(typeId: 1)
class Character extends HiveObject {
  Character({
    required this.profileId,
    required this.typeId,
    this.name,
    this.experiencePoints = 0,
    this.equippedAccessory,
    List<String>? unlockedAccessories,
  }) : unlockedAccessories = unlockedAccessories ?? [];

  /// The profile this character belongs to.
  @HiveField(0)
  final String profileId;

  /// Character type ID (e.g., 'fox', 'penguin').
  @HiveField(1)
  final String typeId;

  /// Optional custom name given by the child.
  @HiveField(2)
  String? name;

  /// Total experience points earned.
  @HiveField(3)
  int experiencePoints;

  /// Currently equipped accessory ID.
  @HiveField(4)
  String? equippedAccessory;

  /// List of unlocked accessory IDs.
  @HiveField(5)
  List<String> unlockedAccessories;

  // ============================================
  // Computed Properties
  // ============================================

  /// Get the character type info.
  CharacterTypeInfo? get typeInfo => CharacterTypes.fromId(typeId);

  /// Calculate current level from experience points.
  ///
  /// Level thresholds:
  /// - Level 1: 0 XP
  /// - Level 2: 100 XP
  /// - Level 3: 250 XP
  /// - Level 4: 500 XP
  /// - Level 5: 1000 XP
  /// - ...
  int get level {
    if (experiencePoints < 100) return 1;
    if (experiencePoints < 250) return 2;
    if (experiencePoints < 500) return 3;
    if (experiencePoints < 1000) return 4;
    if (experiencePoints < 2000) return 5;
    if (experiencePoints < 4000) return 6;
    if (experiencePoints < 8000) return 7;
    if (experiencePoints < 16000) return 8;
    if (experiencePoints < 32000) return 9;
    return 10;
  }

  /// XP required to reach the next level.
  int get xpForNextLevel {
    const thresholds = [100, 250, 500, 1000, 2000, 4000, 8000, 16000, 32000];
    if (level >= 10) return 0;
    return thresholds[level - 1];
  }

  /// Current progress towards next level (0.0 to 1.0).
  double get levelProgress {
    if (level >= 10) return 1.0;

    const thresholds = [0, 100, 250, 500, 1000, 2000, 4000, 8000, 16000, 32000];
    final currentThreshold = thresholds[level - 1];
    final nextThreshold = thresholds[level];
    final xpInCurrentLevel = experiencePoints - currentThreshold;
    final xpRequiredForLevel = nextThreshold - currentThreshold;

    return xpInCurrentLevel / xpRequiredForLevel;
  }

  /// Display name (custom name or default type name).
  String get displayName => name ?? typeInfo?.displayNameJa ?? typeId;

  // ============================================
  // Methods
  // ============================================

  /// Create a copy with updated fields.
  Character copyWith({
    String? profileId,
    String? typeId,
    String? name,
    int? experiencePoints,
    String? equippedAccessory,
    List<String>? unlockedAccessories,
  }) {
    return Character(
      profileId: profileId ?? this.profileId,
      typeId: typeId ?? this.typeId,
      name: name ?? this.name,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      equippedAccessory: equippedAccessory ?? this.equippedAccessory,
      unlockedAccessories: unlockedAccessories ?? List.from(this.unlockedAccessories),
    );
  }

  @override
  String toString() => 'Character(type: $typeId, level: $level, xp: $experiencePoints)';
}
