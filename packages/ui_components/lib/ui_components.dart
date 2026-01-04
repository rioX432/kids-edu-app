/// Shared UI components for kids educational apps.
///
/// This package provides reusable widgets:
/// - [ChoiceButton] - Quiz answer buttons with feedback states
/// - [CharacterAvatar] - Character display with emotions
/// - [ProgressIndicator] - Stars, dots, or steps progress
/// - [RewardModal] - Celebration popup for rewards
/// - [ParentGateModal] - Parent verification modal
library ui_components;

// Buttons
export 'src/buttons/choice_button.dart';
export 'src/buttons/primary_button.dart';
export 'src/buttons/icon_action_button.dart';

// Character
export 'src/character/character_avatar.dart';
export 'src/character/character_selector.dart';

// Progress
export 'src/progress/star_progress.dart';
export 'src/progress/dot_progress.dart';
export 'src/progress/step_progress.dart';

// Modals
export 'src/modals/reward_modal.dart';
export 'src/modals/parent_gate_modal.dart';

// Common
export 'src/common/animated_container.dart';
export 'src/common/tap_feedback.dart';
