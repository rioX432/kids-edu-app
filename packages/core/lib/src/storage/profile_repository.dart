import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import 'profile.dart';

/// Repository for managing user profiles.
///
/// Handles:
/// - Creating/deleting profiles
/// - Switching active profile
/// - Persisting profile data
class ProfileRepository {
  ProfileRepository();

  static const String _boxName = 'profiles';
  static const String _activeProfileKey = 'active_profile_id';

  late Box<Profile> _profileBox;
  late Box<String> _settingsBox;
  bool _initialized = false;

  final _uuid = const Uuid();

  /// Initialize the repository.
  Future<void> init() async {
    if (_initialized) return;

    // Register adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProfileAdapter());
    }

    _profileBox = await Hive.openBox<Profile>(_boxName);
    _settingsBox = await Hive.openBox<String>('profile_settings');
    _initialized = true;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'ProfileRepository not initialized. Call init() first.',
      );
    }
  }

  /// Get all profiles.
  List<Profile> getAll() {
    _ensureInitialized();
    return _profileBox.values.toList();
  }

  /// Get a profile by ID.
  Profile? getById(String id) {
    _ensureInitialized();
    return _profileBox.get(id);
  }

  /// Get the currently active profile.
  Profile? getActive() {
    _ensureInitialized();
    final activeId = _settingsBox.get(_activeProfileKey);
    if (activeId == null) return null;
    return _profileBox.get(activeId);
  }

  /// Set the active profile.
  Future<void> setActive(String id) async {
    _ensureInitialized();
    if (!_profileBox.containsKey(id)) {
      throw ArgumentError('Profile with id $id does not exist');
    }
    await _settingsBox.put(_activeProfileKey, id);
  }

  /// Create a new profile.
  Future<Profile> create({required String name}) async {
    _ensureInitialized();

    final profile = Profile(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
    );

    await _profileBox.put(profile.id, profile);

    // If this is the first profile, set it as active
    if (_profileBox.length == 1) {
      await setActive(profile.id);
    }

    return profile;
  }

  /// Update an existing profile.
  Future<void> update(Profile profile) async {
    _ensureInitialized();
    await _profileBox.put(profile.id, profile);
  }

  /// Delete a profile.
  Future<void> delete(String id) async {
    _ensureInitialized();
    await _profileBox.delete(id);

    // If deleted profile was active, switch to another or clear
    final activeId = _settingsBox.get(_activeProfileKey);
    if (activeId == id) {
      final remaining = _profileBox.values.toList();
      if (remaining.isNotEmpty) {
        await setActive(remaining.first.id);
      } else {
        await _settingsBox.delete(_activeProfileKey);
      }
    }
  }

  /// Check if any profiles exist.
  bool get hasProfiles {
    _ensureInitialized();
    return _profileBox.isNotEmpty;
  }

  /// Get the number of profiles.
  int get count {
    _ensureInitialized();
    return _profileBox.length;
  }

  /// Close the repository.
  Future<void> close() async {
    if (_initialized) {
      await _profileBox.close();
      await _settingsBox.close();
      _initialized = false;
    }
  }
}
