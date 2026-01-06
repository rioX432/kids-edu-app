import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for kids educational apps.
///
/// These transitions create a playful, engaging experience
/// while navigating between screens.

/// Cloud sweep page transition.
///
/// Creates a dreamy effect where clouds sweep across the screen,
/// revealing the new page as they part.
///
/// Best for: Learning app navigation
class CloudTransitionPage<T> extends CustomTransitionPage<T> {
  CloudTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: AppSpacing.durationSlow,
          reverseTransitionDuration: AppSpacing.durationSlow,
          transitionsBuilder: _cloudTransitionBuilder,
        );
}

Widget _cloudTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // Fade + Scale for now (Rive cloud animation can be added later)
  final fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeOut,
  ));

  final scaleAnimation = Tween<double>(
    begin: 0.95,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  ));

  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      scale: scaleAnimation,
      child: child,
    ),
  );
}

/// Book page turn transition.
///
/// Creates a 3D page curl effect like turning a page in a physical book.
///
/// Best for: Picture book app navigation
class BookTurnTransitionPage<T> extends CustomTransitionPage<T> {
  BookTurnTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: _bookTurnTransitionBuilder,
        );
}

Widget _bookTurnTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // Slide from right + fade for page turn feel
  final slideAnimation = Tween<Offset>(
    begin: const Offset(0.3, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutQuart,
  ));

  final fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
  ));

  // Slight rotation for 3D effect
  final rotationAnimation = Tween<double>(
    begin: 0.05,
    end: 0.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  ));

  return SlideTransition(
    position: slideAnimation,
    child: FadeTransition(
      opacity: fadeAnimation,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(rotationAnimation.value),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    ),
  );
}

/// Star burst page transition.
///
/// Creates an explosive star effect perfect for celebrations
/// or exciting moments.
///
/// Best for: Reward screens, level completion
class StarBurstTransitionPage<T> extends CustomTransitionPage<T> {
  StarBurstTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: AppSpacing.durationNormal,
          reverseTransitionDuration: AppSpacing.durationNormal,
          transitionsBuilder: _starBurstTransitionBuilder,
        );
}

Widget _starBurstTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  // Scale up from center with overshoot
  final scaleAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.elasticOut,
  ));

  final fadeAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
  ));

  return FadeTransition(
    opacity: fadeAnimation,
    child: ScaleTransition(
      scale: scaleAnimation,
      child: child,
    ),
  );
}

/// Gentle fade transition for calm moments.
///
/// Best for: Settings, quiet screens, bedtime mode
class GentleFadeTransitionPage<T> extends CustomTransitionPage<T> {
  GentleFadeTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: AppSpacing.durationSlow,
          reverseTransitionDuration: AppSpacing.durationSlow,
          transitionsBuilder: _gentleFadeTransitionBuilder,
        );
}

Widget _gentleFadeTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ),
    child: child,
  );
}

/// Bouncy slide transition for playful navigation.
///
/// Best for: Activity selection, game elements
class BouncySlideTransitionPage<T> extends CustomTransitionPage<T> {
  BouncySlideTransitionPage({
    required super.child,
    this.direction = SlideDirection.right,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 450),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              _bouncySlideTransitionBuilder(
            context,
            animation,
            secondaryAnimation,
            child,
            direction,
          ),
        );

  final SlideDirection direction;
}

enum SlideDirection { left, right, up, down }

Widget _bouncySlideTransitionBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
  SlideDirection direction,
) {
  final begin = switch (direction) {
    SlideDirection.left => const Offset(-1.0, 0.0),
    SlideDirection.right => const Offset(1.0, 0.0),
    SlideDirection.up => const Offset(0.0, -1.0),
    SlideDirection.down => const Offset(0.0, 1.0),
  };

  final slideAnimation = Tween<Offset>(
    begin: begin,
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.elasticOut,
  ));

  return SlideTransition(
    position: slideAnimation,
    child: child,
  );
}
