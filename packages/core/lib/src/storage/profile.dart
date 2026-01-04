import 'package:hive/hive.dart';

part 'profile.g.dart';

/// User profile for a child.
///
/// Supports multiple profiles on one device (for siblings sharing a tablet).
@HiveType(typeId: 0)
class Profile extends HiveObject {
  Profile({
    required this.id,
    required this.name,
    required this.createdAt,
    this.characterId,
    this.characterName,
    this.characterAccessory,
  });

  /// Unique profile ID.
  @HiveField(0)
  final String id;

  /// Display name (e.g., "たろう", "はなこ").
  @HiveField(1)
  final String name;

  /// When the profile was created.
  @HiveField(2)
  final DateTime createdAt;

  /// Selected character type ID (e.g., 'fox', 'penguin').
  @HiveField(3)
  String? characterId;

  /// Custom name for the character (optional).
  @HiveField(4)
  String? characterName;

  /// Equipped accessory ID (optional).
  @HiveField(5)
  String? characterAccessory;

  /// Create a copy with updated fields.
  Profile copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    String? characterId,
    String? characterName,
    String? characterAccessory,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      characterId: characterId ?? this.characterId,
      characterName: characterName ?? this.characterName,
      characterAccessory: characterAccessory ?? this.characterAccessory,
    );
  }

  @override
  String toString() => 'Profile(id: $id, name: $name)';
}
