import 'package:flutter/material.dart';

/// Available character types for selection.
enum CharacterType {
  fox,
  penguin,
  bear,
  rabbit,
  cat,
  dog,
}

/// Character type metadata.
class CharacterTypeInfo {
  const CharacterTypeInfo({
    required this.type,
    required this.displayName,
    required this.displayNameJa,
    required this.emoji,
    required this.color,
    required this.assetPath,
  });

  final CharacterType type;
  final String displayName;
  final String displayNameJa;
  final String emoji;
  final Color color;
  final String assetPath;

  /// Get the character ID string.
  String get id => type.name;
}

/// Predefined character types.
abstract final class CharacterTypes {
  static const fox = CharacterTypeInfo(
    type: CharacterType.fox,
    displayName: 'Fox',
    displayNameJa: 'きつね',
    emoji: '🦊',
    color: Color(0xFFFF9F6E),
    assetPath: 'assets/characters/fox',
  );

  static const penguin = CharacterTypeInfo(
    type: CharacterType.penguin,
    displayName: 'Penguin',
    displayNameJa: 'ぺんぎん',
    emoji: '🐧',
    color: Color(0xFF7EC8E3),
    assetPath: 'assets/characters/penguin',
  );

  static const bear = CharacterTypeInfo(
    type: CharacterType.bear,
    displayName: 'Bear',
    displayNameJa: 'くま',
    emoji: '🐻',
    color: Color(0xFFFFD66E),
    assetPath: 'assets/characters/bear',
  );

  static const rabbit = CharacterTypeInfo(
    type: CharacterType.rabbit,
    displayName: 'Rabbit',
    displayNameJa: 'うさぎ',
    emoji: '🐰',
    color: Color(0xFFC9A0DC),
    assetPath: 'assets/characters/rabbit',
  );

  static const cat = CharacterTypeInfo(
    type: CharacterType.cat,
    displayName: 'Cat',
    displayNameJa: 'ねこ',
    emoji: '🐱',
    color: Color(0xFFFFB6C1),
    assetPath: 'assets/characters/cat',
  );

  static const dog = CharacterTypeInfo(
    type: CharacterType.dog,
    displayName: 'Dog',
    displayNameJa: 'いぬ',
    emoji: '🐶',
    color: Color(0xFFA0D2DB),
    assetPath: 'assets/characters/dog',
  );

  /// All available character types.
  static const List<CharacterTypeInfo> all = [
    fox,
    penguin,
    bear,
    rabbit,
    cat,
    dog,
  ];

  /// Get character info by type.
  static CharacterTypeInfo fromType(CharacterType type) {
    return all.firstWhere((info) => info.type == type);
  }

  /// Get character info by ID string.
  static CharacterTypeInfo? fromId(String id) {
    try {
      final type = CharacterType.values.firstWhere((t) => t.name == id);
      return fromType(type);
    } catch (_) {
      return null;
    }
  }
}
