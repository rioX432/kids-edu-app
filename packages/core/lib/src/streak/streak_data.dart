import 'package:hive/hive.dart';

part 'streak_data.g.dart';

/// Data model for tracking daily activity streaks.
@HiveType(typeId: 2)
class StreakData extends HiveObject {
  StreakData({
    required this.profileId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
    this.recoveryUsedThisMonth = false,
    this.lastRecoveryResetMonth,
    this.totalActiveDays = 0,
  });

  /// The profile this streak belongs to.
  @HiveField(0)
  final String profileId;

  /// Current consecutive days streak.
  @HiveField(1)
  int currentStreak;

  /// Longest streak ever achieved.
  @HiveField(2)
  int longestStreak;

  /// Date of last activity (date only, no time).
  @HiveField(3)
  DateTime? lastActivityDate;

  /// Whether recovery has been used this month.
  @HiveField(4)
  bool recoveryUsedThisMonth;

  /// Month when recovery was last reset.
  @HiveField(5)
  int? lastRecoveryResetMonth;

  /// Total number of days with activity (not consecutive).
  @HiveField(6)
  int totalActiveDays;

  /// Check if recovery is available.
  bool get canUseRecovery => !recoveryUsedThisMonth;

  /// Create a copy with updated fields.
  StreakData copyWith({
    String? profileId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
    bool? recoveryUsedThisMonth,
    int? lastRecoveryResetMonth,
    int? totalActiveDays,
  }) {
    return StreakData(
      profileId: profileId ?? this.profileId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      recoveryUsedThisMonth: recoveryUsedThisMonth ?? this.recoveryUsedThisMonth,
      lastRecoveryResetMonth: lastRecoveryResetMonth ?? this.lastRecoveryResetMonth,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
    );
  }

  @override
  String toString() =>
      'StreakData(current: $currentStreak, longest: $longestStreak, total: $totalActiveDays)';
}
