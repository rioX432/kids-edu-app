import 'package:hive_flutter/hive_flutter.dart';

import 'character.dart';
import 'character_type.dart';

/// Repository for managing character data.
class CharacterRepository {
  CharacterRepository();

  static const String _boxName = 'characters';

  late Box<Character> _box;
  bool _initialized = false;

  /// Initialize the repository.
  Future<void> init() async {
    if (_initialized) return;

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CharacterAdapter());
    }

    _box = await Hive.openBox<Character>(_boxName);
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'CharacterRepository not initialized. Call init() first.',
      );
    }
  }

  /// Get character for a profile.
  Character? getByProfileId(String profileId) {
    _ensureInitialized();
    try {
      return _box.values.firstWhere((c) => c.profileId == profileId);
    } catch (_) {
      return null;
    }
  }

  /// Create a new character for a profile.
  Future<Character> create({
    required String profileId,
    required CharacterType type,
    String? name,
  }) async {
    _ensureInitialized();

    // Check if character already exists for this profile
    final existing = getByProfileId(profileId);
    if (existing != null) {
      throw StateError('Character already exists for profile $profileId');
    }

    final character = Character(
      profileId: profileId,
      typeId: type.name,
      name: name,
    );

    await _box.put(profileId, character);
    return character;
  }

  /// Update a character.
  Future<void> update(Character character) async {
    _ensureInitialized();
    await _box.put(character.profileId, character);
  }

  /// Add experience points to a character.
  Future<Character> addExperience(String profileId, int points) async {
    _ensureInitialized();

    final character = getByProfileId(profileId);
    if (character == null) {
      throw StateError('Character not found for profile $profileId');
    }

    final previousLevel = character.level;
    character.experiencePoints += points;
    await update(character);

    // Return updated character (caller can check for level up)
    return character;
  }

  /// Unlock an accessory for a character.
  Future<void> unlockAccessory(String profileId, String accessoryId) async {
    _ensureInitialized();

    final character = getByProfileId(profileId);
    if (character == null) {
      throw StateError('Character not found for profile $profileId');
    }

    if (!character.unlockedAccessories.contains(accessoryId)) {
      character.unlockedAccessories.add(accessoryId);
      await update(character);
    }
  }

  /// Equip an accessory.
  Future<void> equipAccessory(String profileId, String? accessoryId) async {
    _ensureInitialized();

    final character = getByProfileId(profileId);
    if (character == null) {
      throw StateError('Character not found for profile $profileId');
    }

    // Verify accessory is unlocked (if not null)
    if (accessoryId != null &&
        !character.unlockedAccessories.contains(accessoryId)) {
      throw ArgumentError('Accessory $accessoryId is not unlocked');
    }

    character.equippedAccessory = accessoryId;
    await update(character);
  }

  /// Set custom name for character.
  Future<void> setName(String profileId, String? name) async {
    _ensureInitialized();

    final character = getByProfileId(profileId);
    if (character == null) {
      throw StateError('Character not found for profile $profileId');
    }

    character.name = name;
    await update(character);
  }

  /// Delete character for a profile.
  Future<void> delete(String profileId) async {
    _ensureInitialized();
    await _box.delete(profileId);
  }

  /// Close the repository.
  Future<void> close() async {
    if (_initialized) {
      await _box.close();
      _initialized = false;
    }
  }
}
