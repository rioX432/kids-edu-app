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

/// Provider for reading history.
final readingHistoryProvider = StateProvider<List<String>>((ref) => []);
