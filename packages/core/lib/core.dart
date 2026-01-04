/// Shared core logic for kids educational apps.
///
/// This package provides:
/// - [Character] - Character system with emotions and experience
/// - [ParentGateService] - Child protection gate
/// - [StorageService] - Local storage abstraction
/// - [StreakManager] - Daily streak management
/// - [RewardService] - Stamps and unlockables
/// - [AudioManager] - BGM, SE, and narration
library core;

// Character
export 'src/character/character.dart';
export 'src/character/character_emotion.dart';
export 'src/character/character_repository.dart';
export 'src/character/character_type.dart';

// Parent Gate
export 'src/parent_gate/parent_gate_service.dart';
export 'src/parent_gate/math_problem.dart';

// Storage
export 'src/storage/storage_service.dart';
export 'src/storage/hive_storage_service.dart';
export 'src/storage/profile.dart';
export 'src/storage/profile_repository.dart';

// Streak
export 'src/streak/streak_data.dart';
export 'src/streak/streak_manager.dart';

// Rewards
export 'src/rewards/reward.dart';
export 'src/rewards/stamp_book.dart';
export 'src/rewards/unlockable.dart';
export 'src/rewards/reward_service.dart';

// Audio
export 'src/audio/audio_manager.dart';
export 'src/audio/audio_assets.dart';
