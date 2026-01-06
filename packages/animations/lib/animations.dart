/// Rich animation system for kids educational apps.
///
/// This package provides:
/// - Rive integration for complex animations
/// - Custom page transitions (cloud sweep, book turn, rainbow wipe)
/// - Tap feedback effects (particles, physics)
/// - Celebration effects (confetti, star rain, sticker collection)
/// - Living UI elements (eye follower, breathing, peek-a-boo creatures)
/// - Interactive backgrounds (animated sky, floating elements)
/// - Animated progress indicators
library animations;

// Rive integration
export 'src/rive/rive_controller.dart';
export 'src/rive/rive_asset_paths.dart';

// Page transitions
export 'src/transitions/kids_page_transitions.dart';
export 'src/transitions/rainbow_wipe_transition.dart';

// Effects
export 'src/effects/confetti_effect.dart';
export 'src/effects/particle_tap_effect.dart';

// Living UI
export 'src/living_ui/breathing_widget.dart';
export 'src/living_ui/eye_follower.dart';

// Physics-based widgets
export 'src/physics/squishy_button.dart';

// Progress indicators
export 'src/progress/caterpillar_progress.dart';

// Backgrounds
export 'src/backgrounds/animated_sky_background.dart';
export 'src/backgrounds/peek_a_boo_creature.dart';

// Rewards
export 'src/rewards/flying_sticker.dart';

// Micro-interactions
export 'src/micro/seed_growth_effect.dart';
export 'src/micro/musical_tap_widget.dart';
export 'src/micro/touch_feedback.dart';
