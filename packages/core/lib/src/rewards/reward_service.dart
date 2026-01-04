import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'reward.dart';
import 'stamp_book.dart';
import 'unlockable.dart';

/// Event emitted when a reward is unlocked.
class RewardUnlockedEvent {
  const RewardUnlockedEvent({
    required this.reward,
    required this.profileId,
  });

  final Reward reward;
  final String profileId;
}

/// Event emitted when a stamp book is completed.
class StampBookCompletedEvent {
  const StampBookCompletedEvent({
    required this.stampBook,
    required this.profileId,
  });

  final StampBook stampBook;
  final String profileId;
}

/// Service for managing rewards, stamps, and unlockables.
class RewardService {
  RewardService({
    List<Reward>? availableRewards,
  }) : _availableRewards = availableRewards ?? defaultRewards;

  static const String _stampBookBoxName = 'stamp_books';
  static const String _unlockableBoxName = 'unlockables';
  static const int _defaultStampBookSlots = 30;

  final List<Reward> _availableRewards;
  final _uuid = const Uuid();

  late Box<StampBook> _stampBookBox;
  late Box<UnlockableProgress> _unlockableBox;
  bool _initialized = false;

  /// Initialize the service.
  Future<void> init() async {
    if (_initialized) return;

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(StampBookAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UnlockableProgressAdapter());
    }

    _stampBookBox = await Hive.openBox<StampBook>(_stampBookBoxName);
    _unlockableBox = await Hive.openBox<UnlockableProgress>(_unlockableBoxName);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError('RewardService not initialized. Call init() first.');
    }
  }

  // ============================================
  // Stamp Book Management
  // ============================================

  /// Get active stamp book for a profile, or create one.
  StampBook getActiveStampBook(String profileId) {
    _ensureInitialized();

    // Find an incomplete stamp book
    final books = _stampBookBox.values
        .where((b) => b.profileId == profileId && !b.isCompleted)
        .toList();

    if (books.isNotEmpty) return books.first;

    // Create a new stamp book
    final newBook = StampBook(
      id: _uuid.v4(),
      profileId: profileId,
      totalSlots: _defaultStampBookSlots,
    );
    _stampBookBox.put(newBook.id, newBook);
    return newBook;
  }

  /// Get all stamp books for a profile.
  List<StampBook> getStampBooks(String profileId) {
    _ensureInitialized();
    return _stampBookBox.values
        .where((b) => b.profileId == profileId)
        .toList();
  }

  /// Get completed stamp books count for a profile.
  int getCompletedStampBooksCount(String profileId) {
    _ensureInitialized();
    return _stampBookBox.values
        .where((b) => b.profileId == profileId && b.isCompleted)
        .length;
  }

  /// Add a stamp to the active stamp book.
  ///
  /// Returns the event if stamp book was completed, null otherwise.
  Future<StampBookCompletedEvent?> addStamp(String profileId) async {
    _ensureInitialized();

    final book = getActiveStampBook(profileId);
    final wasCompleted = book.isCompleted;

    book.addStamp();
    await _stampBookBox.put(book.id, book);

    if (book.isCompleted && !wasCompleted) {
      return StampBookCompletedEvent(
        stampBook: book,
        profileId: profileId,
      );
    }

    return null;
  }

  // ============================================
  // Unlockable Management
  // ============================================

  /// Get unlockable progress for a profile.
  UnlockableProgress getUnlockableProgress(String profileId) {
    _ensureInitialized();

    final existing = _unlockableBox.get(profileId);
    if (existing != null) return existing;

    final newProgress = UnlockableProgress(profileId: profileId);
    _unlockableBox.put(profileId, newProgress);
    return newProgress;
  }

  /// Check if a reward is unlocked.
  bool isUnlocked(String profileId, String rewardId) {
    _ensureInitialized();
    return getUnlockableProgress(profileId).isUnlocked(rewardId);
  }

  /// Get all unlocked reward IDs for a profile.
  List<String> getUnlockedIds(String profileId) {
    _ensureInitialized();
    return getUnlockableProgress(profileId).unlockedIds;
  }

  /// Unlock a reward manually.
  Future<bool> unlock(String profileId, String rewardId) async {
    _ensureInitialized();

    final progress = getUnlockableProgress(profileId);
    if (!progress.unlock(rewardId)) return false;

    await _unlockableBox.put(profileId, progress);
    return true;
  }

  /// Check and unlock rewards based on current progress.
  ///
  /// Returns list of newly unlocked rewards.
  Future<List<RewardUnlockedEvent>> checkAndUnlock({
    required String profileId,
    int? streakDays,
    int? characterLevel,
    int? totalDays,
    int? stampBooksCompleted,
  }) async {
    _ensureInitialized();

    final progress = getUnlockableProgress(profileId);
    final unlockedEvents = <RewardUnlockedEvent>[];

    for (final reward in _availableRewards) {
      if (progress.isUnlocked(reward.id)) continue;

      if (reward is! BadgeReward) continue;

      if (reward.condition.isMet(
        streakDays: streakDays,
        characterLevel: characterLevel,
        totalDays: totalDays,
        stampBooksCompleted: stampBooksCompleted,
      )) {
        progress.unlock(reward.id);
        unlockedEvents.add(RewardUnlockedEvent(
          reward: reward,
          profileId: profileId,
        ));
      }
    }

    if (unlockedEvents.isNotEmpty) {
      await _unlockableBox.put(profileId, progress);
    }

    return unlockedEvents;
  }

  /// Close the service.
  Future<void> close() async {
    if (_initialized) {
      await _stampBookBox.close();
      await _unlockableBox.close();
      _initialized = false;
    }
  }
}

/// Default rewards available in the app.
const List<Reward> defaultRewards = [
  // Streak badges
  BadgeReward(
    id: 'badge_streak_3',
    name: '3-Day Streak',
    nameJa: '3日連続',
    condition: UnlockCondition(trigger: UnlockTrigger.streak, value: 3),
  ),
  BadgeReward(
    id: 'badge_streak_7',
    name: '7-Day Streak',
    nameJa: '1週間連続',
    condition: UnlockCondition(trigger: UnlockTrigger.streak, value: 7),
  ),
  BadgeReward(
    id: 'badge_streak_14',
    name: '14-Day Streak',
    nameJa: '2週間連続',
    condition: UnlockCondition(trigger: UnlockTrigger.streak, value: 14),
  ),
  BadgeReward(
    id: 'badge_streak_30',
    name: '30-Day Streak',
    nameJa: '1か月連続',
    condition: UnlockCondition(trigger: UnlockTrigger.streak, value: 30),
  ),

  // Level badges
  BadgeReward(
    id: 'badge_level_2',
    name: 'Level 2',
    nameJa: 'レベル2',
    condition: UnlockCondition(trigger: UnlockTrigger.level, value: 2),
  ),
  BadgeReward(
    id: 'badge_level_5',
    name: 'Level 5',
    nameJa: 'レベル5',
    condition: UnlockCondition(trigger: UnlockTrigger.level, value: 5),
  ),
  BadgeReward(
    id: 'badge_level_10',
    name: 'Level 10',
    nameJa: 'レベル10',
    condition: UnlockCondition(trigger: UnlockTrigger.level, value: 10),
  ),

  // Stamp book badges
  BadgeReward(
    id: 'badge_stamp_book_1',
    name: 'First Stamp Book',
    nameJa: 'はじめてのスタンプ帳',
    condition: UnlockCondition(trigger: UnlockTrigger.stampBookComplete, value: 1),
  ),

  // Accessories (unlocked at various levels)
  AccessoryReward(
    id: 'accessory_hat_basic',
    name: 'Basic Hat',
    nameJa: 'ベーシックなぼうし',
    category: AccessoryCategory.hat,
  ),
  AccessoryReward(
    id: 'accessory_glasses_round',
    name: 'Round Glasses',
    nameJa: 'まるいめがね',
    category: AccessoryCategory.glasses,
  ),
  AccessoryReward(
    id: 'accessory_scarf_red',
    name: 'Red Scarf',
    nameJa: 'あかいマフラー',
    category: AccessoryCategory.scarf,
  ),
];
