/// Rich animation system for kids educational apps.
///
/// This package provides:
/// - Rive integration for complex animations
/// - Custom page transitions (cloud sweep, book turn)
/// - Tap feedback effects (particles, physics)
/// - Celebration effects (confetti, star rain)
/// - Living UI elements (eye follower, breathing)
library animations;

// Rive integration
export 'src/rive/rive_controller.dart';
export 'src/rive/rive_asset_paths.dart';

// Page transitions
export 'src/transitions/kids_page_transitions.dart';

// Effects
export 'src/effects/confetti_effect.dart';
export 'src/effects/particle_tap_effect.dart';

// Living UI
export 'src/living_ui/breathing_widget.dart';
export 'src/living_ui/eye_follower.dart';

// Physics-based widgets
export 'src/physics/squishy_button.dart';
