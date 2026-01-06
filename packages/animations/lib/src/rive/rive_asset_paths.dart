/// Asset paths for Rive animation files.
///
/// All Rive assets should be placed in the app's `assets/rive/` directory
/// and registered in pubspec.yaml.
abstract final class RiveAssetPaths {
  /// Base path for all Rive assets
  static const String basePath = 'assets/rive';

  // ============================================
  // UI Effects
  // ============================================

  /// Particle burst on tap (flowers, stars, sparkles)
  static const String tapParticles = '$basePath/tap_particles.riv';

  /// Squishy button deformation
  static const String buttonSquish = '$basePath/button_squish.riv';

  /// Confetti celebration effect
  static const String confetti = '$basePath/confetti.riv';

  /// Stars falling from top
  static const String starRain = '$basePath/star_rain.riv';

  // ============================================
  // Page Transitions
  // ============================================

  /// Cloud sweep transition (learning app)
  static const String cloudTransition = '$basePath/cloud_transition.riv';

  /// Book page turn transition (picture book app)
  static const String bookTurn = '$basePath/book_turn.riv';

  /// Star burst transition
  static const String starBurst = '$basePath/star_burst.riv';

  // ============================================
  // Living UI
  // ============================================

  /// Eyes that follow pointer
  static const String eyeFollower = '$basePath/eye_follower.riv';

  // ============================================
  // Characters
  // ============================================

  /// Character animation template
  /// Replace {type} with: fox, penguin, bear, rabbit, cat, dog
  static String character(String type) => '$basePath/character_$type.riv';

  /// Fox character
  static const String characterFox = '$basePath/character_fox.riv';

  /// Penguin character
  static const String characterPenguin = '$basePath/character_penguin.riv';

  /// Bear character
  static const String characterBear = '$basePath/character_bear.riv';

  /// Rabbit character
  static const String characterRabbit = '$basePath/character_rabbit.riv';

  /// Cat character
  static const String characterCat = '$basePath/character_cat.riv';

  /// Dog character
  static const String characterDog = '$basePath/character_dog.riv';
}

/// State machine input names used across Rive assets.
///
/// These should match the input names defined in Rive Editor.
abstract final class RiveInputs {
  // Triggers (fire once)
  static const String trigger = 'trigger';
  static const String tap = 'tap';
  static const String blink = 'blink';

  // Booleans (on/off state)
  static const String pressed = 'pressed';
  static const String hover = 'hover';
  static const String active = 'active';

  // Numbers (continuous values)
  static const String progress = 'progress';
  static const String lookX = 'look_x';
  static const String lookY = 'look_y';
  static const String intensity = 'intensity';
  static const String speed = 'speed';

  // Enums (discrete values)
  static const String direction = 'direction';
  static const String emotion = 'emotion';
  static const String color = 'color';
}

/// Standard state machine names.
abstract final class RiveStateMachines {
  static const String defaultMachine = 'State Machine 1';
  static const String main = 'Main';
  static const String controller = 'Controller';
}
