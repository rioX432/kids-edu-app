import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

/// Provider for checking if user has completed onboarding.
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final storage = HiveStorageService();
  final profileRepo = ProfileRepository(storage);
  final profiles = await profileRepo.getAllProfiles();
  return profiles.isNotEmpty;
});

/// Provider for current profile.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final storage = HiveStorageService();
  final profileRepo = ProfileRepository(storage);
  final profiles = await profileRepo.getAllProfiles();
  return profiles.isNotEmpty ? profiles.first : null;
});

/// Provider for current character.
final currentCharacterProvider = FutureProvider<Character?>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final storage = HiveStorageService();
  final charRepo = CharacterRepository(storage);
  return charRepo.getCharacter(profile.id);
});

/// Provider for streak data.
final streakDataProvider = FutureProvider<StreakData?>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final storage = HiveStorageService();
  final streakManager = StreakManager(storage);
  return streakManager.getStreak(profile.id);
});

/// Provider for profile repository.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final storage = HiveStorageService();
  return ProfileRepository(storage);
});

/// Provider for character repository.
final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final storage = HiveStorageService();
  return CharacterRepository(storage);
});

/// Provider for streak manager.
final streakManagerProvider = Provider<StreakManager>((ref) {
  final storage = HiveStorageService();
  return StreakManager(storage);
});

/// Provider for reward service.
final rewardServiceProvider = Provider<RewardService>((ref) {
  final storage = HiveStorageService();
  return RewardService(storage);
});
