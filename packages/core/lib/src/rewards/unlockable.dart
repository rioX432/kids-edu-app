import 'package:hive/hive.dart';

part 'unlockable.g.dart';

/// Tracks unlocked rewards for a profile.
@HiveType(typeId: 4)
class UnlockableProgress extends HiveObject {
  UnlockableProgress({
    required this.profileId,
    List<String>? unlockedIds,
    List<DateTime>? unlockDates,
  })  : unlockedIds = unlockedIds ?? [],
        unlockDates = unlockDates ?? [];

  /// Profile this progress belongs to.
  @HiveField(0)
  final String profileId;

  /// List of unlocked reward IDs.
  @HiveField(1)
  List<String> unlockedIds;

  /// Dates when rewards were unlocked.
  @HiveField(2)
  List<DateTime> unlockDates;

  /// Check if a reward is unlocked.
  bool isUnlocked(String id) => unlockedIds.contains(id);

  /// Unlock a reward.
  ///
  /// Returns true if newly unlocked, false if already unlocked.
  bool unlock(String id) {
    if (isUnlocked(id)) return false;

    unlockedIds.add(id);
    unlockDates.add(DateTime.now());
    return true;
  }

  /// Get the date a reward was unlocked.
  DateTime? getUnlockDate(String id) {
    final index = unlockedIds.indexOf(id);
    if (index < 0) return null;
    return unlockDates[index];
  }

  /// Total number of unlocked rewards.
  int get totalUnlocked => unlockedIds.length;

  /// Get recently unlocked reward IDs (last 5).
  List<String> get recentlyUnlocked {
    if (unlockedIds.length <= 5) return List.from(unlockedIds.reversed);
    return unlockedIds.sublist(unlockedIds.length - 5).reversed.toList();
  }
}
