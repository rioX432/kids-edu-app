import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';

import 'streak_data.dart';

/// Result of recording activity.
class StreakResult {
  const StreakResult({
    required this.streakData,
    required this.action,
    this.previousStreak,
  });

  final StreakData streakData;
  final StreakAction action;
  final int? previousStreak;

  /// Whether the streak was maintained or increased.
  bool get isPositive =>
      action == StreakAction.continued ||
      action == StreakAction.recovered ||
      action == StreakAction.alreadyRecorded;

  /// Whether a milestone was reached (every 5 days).
  bool get reachedMilestone {
    if (!isPositive) return false;
    return streakData.currentStreak > 0 &&
           streakData.currentStreak % 5 == 0 &&
           action == StreakAction.continued;
  }
}

/// Action taken when recording activity.
enum StreakAction {
  /// First activity, streak started.
  started,

  /// Activity continued from yesterday.
  continued,

  /// Streak recovered using monthly recovery.
  recovered,

  /// Streak was broken (gap of 2+ days).
  broken,

  /// Already recorded activity today.
  alreadyRecorded,
}

/// Manages daily activity streaks.
class StreakManager {
  StreakManager();

  static const String _boxName = 'streaks';

  late Box<StreakData> _box;
  bool _initialized = false;

  /// Initialize the manager.
  Future<void> init() async {
    if (_initialized) return;

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StreakDataAdapter());
    }

    _box = await Hive.openBox<StreakData>(_boxName);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('StreakManager not initialized. Call init() first.');
    }
  }

  /// Get streak data for a profile.
  StreakData? getByProfileId(String profileId) {
    _ensureInitialized();
    return _box.get(profileId);
  }

  /// Get or create streak data for a profile.
  StreakData getOrCreate(String profileId) {
    _ensureInitialized();
    final existing = _box.get(profileId);
    if (existing != null) return existing;

    final newData = StreakData(profileId: profileId);
    _box.put(profileId, newData);
    return newData;
  }

  /// Record activity for today.
  ///
  /// Call this when the user completes a learning session or finishes a book.
  Future<StreakResult> recordActivity(String profileId) async {
    _ensureInitialized();

    var data = getOrCreate(profileId);
    final today = _dateOnly(DateTime.now());
    final currentMonth = today.month;

    // Reset monthly recovery if it's a new month
    if (data.lastRecoveryResetMonth != currentMonth) {
      data = data.copyWith(
        recoveryUsedThisMonth: false,
        lastRecoveryResetMonth: currentMonth,
      );
    }

    // Check if already recorded today
    if (data.lastActivityDate != null &&
        _isSameDay(data.lastActivityDate!, today)) {
      return StreakResult(
        streakData: data,
        action: StreakAction.alreadyRecorded,
      );
    }

    final previousStreak = data.currentStreak;
    StreakAction action;

    if (data.lastActivityDate == null) {
      // First activity ever
      data = data.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastActivityDate: today,
        totalActiveDays: 1,
      );
      action = StreakAction.started;
    } else {
      final daysSinceLastActivity = today.difference(data.lastActivityDate!).inDays;

      if (daysSinceLastActivity == 1) {
        // Consecutive day - continue streak
        final newStreak = data.currentStreak + 1;
        data = data.copyWith(
          currentStreak: newStreak,
          longestStreak: max(data.longestStreak, newStreak),
          lastActivityDate: today,
          totalActiveDays: data.totalActiveDays + 1,
        );
        action = StreakAction.continued;
      } else if (daysSinceLastActivity == 2 && data.canUseRecovery) {
        // Missed one day - use recovery
        final newStreak = data.currentStreak + 1;
        data = data.copyWith(
          currentStreak: newStreak,
          longestStreak: max(data.longestStreak, newStreak),
          lastActivityDate: today,
          totalActiveDays: data.totalActiveDays + 1,
          recoveryUsedThisMonth: true,
        );
        action = StreakAction.recovered;
      } else {
        // Streak broken
        data = data.copyWith(
          currentStreak: 1,
          lastActivityDate: today,
          totalActiveDays: data.totalActiveDays + 1,
        );
        action = StreakAction.broken;
      }
    }

    await _box.put(profileId, data);

    return StreakResult(
      streakData: data,
      action: action,
      previousStreak: previousStreak,
    );
  }

  /// Check streak status without recording.
  StreakStatus checkStatus(String profileId) {
    _ensureInitialized();

    final data = getByProfileId(profileId);
    if (data == null) return StreakStatus.noStreak;

    final today = _dateOnly(DateTime.now());

    if (data.lastActivityDate == null) return StreakStatus.noStreak;

    if (_isSameDay(data.lastActivityDate!, today)) {
      return StreakStatus.completedToday;
    }

    final daysSinceLastActivity = today.difference(data.lastActivityDate!).inDays;

    if (daysSinceLastActivity == 1) {
      return StreakStatus.pendingToday;
    }

    if (daysSinceLastActivity == 2 && data.canUseRecovery) {
      return StreakStatus.atRiskRecoverable;
    }

    return StreakStatus.broken;
  }

  /// Delete streak data for a profile.
  Future<void> delete(String profileId) async {
    _ensureInitialized();
    await _box.delete(profileId);
  }

  /// Close the manager.
  Future<void> close() async {
    if (_initialized) {
      await _box.close();
      _initialized = false;
    }
  }

  /// Remove time component from DateTime.
  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Check if two dates are the same day.
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Current status of a streak.
enum StreakStatus {
  /// No activity recorded yet.
  noStreak,

  /// Already completed activity today.
  completedToday,

  /// Activity expected today to maintain streak.
  pendingToday,

  /// Missed yesterday, but can use recovery.
  atRiskRecoverable,

  /// Streak is broken (missed 2+ days or no recovery available).
  broken,
}
