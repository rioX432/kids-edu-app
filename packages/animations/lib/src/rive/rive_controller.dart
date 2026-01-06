import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

/// Controller for managing Rive animations with State Machine support.
///
/// This controller simplifies common Rive operations:
/// - Loading artboards
/// - Managing State Machine inputs
/// - Triggering animations
///
/// Example:
/// ```dart
/// final controller = KidsRiveController();
///
/// RiveAnimation.asset(
///   RiveAssetPaths.confetti,
///   onInit: controller.onInit,
/// )
///
/// // Trigger celebration
/// controller.trigger('fire');
/// ```
class KidsRiveController {
  KidsRiveController({
    this.stateMachineName,
  });

  /// Optional state machine name. If null, uses the first state machine.
  final String? stateMachineName;

  Artboard? _artboard;
  StateMachineController? _stateMachineController;

  final Map<String, SMIInput<dynamic>> _inputs = {};

  /// Whether the controller has been initialized.
  bool get isInitialized => _artboard != null;

  /// The underlying artboard.
  Artboard? get artboard => _artboard;

  /// Initialize callback for RiveAnimation.
  ///
  /// Pass this to `RiveAnimation.asset(onInit: controller.onInit)`.
  void onInit(Artboard artboard) {
    _artboard = artboard;

    // Find and attach state machine
    final smNames = artboard.stateMachines.map((sm) => sm.name).toList();
    final controller = stateMachineName != null
        ? StateMachineController.fromArtboard(artboard, stateMachineName!)
        : smNames.isNotEmpty
            ? StateMachineController.fromArtboard(artboard, smNames.first)
            : null;

    if (controller != null) {
      artboard.addController(controller);
      _stateMachineController = controller;

      // Cache all inputs for easy access
      for (final input in controller.inputs) {
        _inputs[input.name] = input;
      }
    }
  }

  /// Fire a trigger input.
  ///
  /// Triggers are one-shot events that fire an animation.
  void trigger(String inputName) {
    final input = _inputs[inputName];
    if (input is SMITrigger) {
      input.fire();
    }
  }

  /// Set a boolean input value.
  void setBool(String inputName, bool value) {
    final input = _inputs[inputName];
    if (input is SMIBool) {
      input.value = value;
    }
  }

  /// Get current boolean input value.
  bool? getBool(String inputName) {
    final input = _inputs[inputName];
    if (input is SMIBool) {
      return input.value;
    }
    return null;
  }

  /// Set a number input value.
  void setNumber(String inputName, double value) {
    final input = _inputs[inputName];
    if (input is SMINumber) {
      input.value = value;
    }
  }

  /// Get current number input value.
  double? getNumber(String inputName) {
    final input = _inputs[inputName];
    if (input is SMINumber) {
      return input.value;
    }
    return null;
  }

  /// Check if an input exists.
  bool hasInput(String inputName) => _inputs.containsKey(inputName);

  /// Get all available input names.
  List<String> get inputNames => _inputs.keys.toList();

  /// Dispose resources.
  void dispose() {
    _stateMachineController?.dispose();
    _inputs.clear();
    _artboard = null;
    _stateMachineController = null;
  }
}

/// Widget that provides a Rive animation with controller access.
///
/// This is a convenience wrapper around RiveAnimation that handles
/// controller lifecycle automatically.
///
/// Example:
/// ```dart
/// KidsRiveAnimation(
///   asset: RiveAssetPaths.confetti,
///   onReady: (controller) {
///     // Store controller for later use
///     _confettiController = controller;
///   },
/// )
/// ```
class KidsRiveAnimation extends StatefulWidget {
  const KidsRiveAnimation({
    super.key,
    required this.asset,
    this.stateMachineName,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.onReady,
    this.placeholder,
  });

  /// Path to the Rive asset.
  final String asset;

  /// State machine name (optional, uses first if not specified).
  final String? stateMachineName;

  /// How the animation should fit within its bounds.
  final BoxFit fit;

  /// Alignment of the animation within its bounds.
  final Alignment alignment;

  /// Called when the controller is ready for use.
  final void Function(KidsRiveController controller)? onReady;

  /// Widget to show while loading.
  final Widget? placeholder;

  @override
  State<KidsRiveAnimation> createState() => _KidsRiveAnimationState();
}

class _KidsRiveAnimationState extends State<KidsRiveAnimation> {
  late final KidsRiveController _controller;

  @override
  void initState() {
    super.initState();
    _controller = KidsRiveController(
      stateMachineName: widget.stateMachineName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onInit(Artboard artboard) {
    _controller.onInit(artboard);
    widget.onReady?.call(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      widget.asset,
      fit: widget.fit,
      alignment: widget.alignment,
      onInit: _onInit,
      placeHolder: widget.placeholder,
    );
  }
}
