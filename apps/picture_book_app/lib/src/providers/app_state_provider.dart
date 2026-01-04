import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

/// Provider for profile repository.
final profileRepositoryProvider = FutureProvider<ProfileRepository>((ref) async {
  final repo = ProfileRepository();
  await repo.init();
  return repo;
});

/// Provider for character repository.
final characterRepositoryProvider = FutureProvider<CharacterRepository>((ref) async {
  final repo = CharacterRepository();
  await repo.init();
  return repo;
});

/// Provider for checking if user has completed onboarding.
final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) async {
  final profileRepo = await ref.watch(profileRepositoryProvider.future);
  final profiles = profileRepo.getAll();
  return profiles.isNotEmpty;
});

/// Provider for current profile.
final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final profileRepo = await ref.watch(profileRepositoryProvider.future);
  return profileRepo.getActive();
});

/// Provider for current character.
final currentCharacterProvider = FutureProvider<Character?>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  if (profile == null) return null;

  final charRepo = await ref.watch(characterRepositoryProvider.future);
  return charRepo.getByProfileId(profile.id);
});

/// Provider for reading history.
final readingHistoryProvider = StateProvider<List<String>>((ref) => []);
