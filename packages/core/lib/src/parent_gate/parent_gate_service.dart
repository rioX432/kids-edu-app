import 'dart:math';

import 'math_problem.dart';

/// Service for parent gate verification.
///
/// The parent gate prevents children from accidentally accessing
/// settings, profile switching, or other protected areas.
///
/// Flow:
/// 1. Long press for [holdDuration] (default 3 seconds)
/// 2. Solve a simple math problem
/// 3. Gate unlocks for [unlockDuration] (default 5 minutes)
class ParentGateService {
  ParentGateService({
    this.holdDuration = const Duration(seconds: 3),
    this.unlockDuration = const Duration(minutes: 5),
  });

  /// Duration required to hold before showing math problem.
  final Duration holdDuration;

  /// Duration the gate stays unlocked after verification.
  final Duration unlockDuration;

  final _random = Random();
  DateTime? _unlockedAt;

  /// Whether the gate is currently unlocked.
  bool get isUnlocked {
    if (_unlockedAt == null) return false;
    final elapsed = DateTime.now().difference(_unlockedAt!);
    return elapsed < unlockDuration;
  }

  /// Time remaining until the gate locks again.
  Duration get remainingUnlockTime {
    if (_unlockedAt == null) return Duration.zero;
    final elapsed = DateTime.now().difference(_unlockedAt!);
    final remaining = unlockDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Generate a new math problem.
  ///
  /// Problems are simple enough for adults but hard for young children:
  /// - Addition: a + b where a, b are 1-9
  /// - Subtraction: a - b where a > b, result is positive
  MathProblem generateProblem() {
    // Randomly choose addition or subtraction
    final isAddition = _random.nextBool();

    if (isAddition) {
      final a = _random.nextInt(9) + 1; // 1-9
      final b = _random.nextInt(9) + 1; // 1-9
      return MathProblem(
        a: a,
        b: b,
        operation: MathOperation.addition,
        answer: a + b,
      );
    } else {
      // Subtraction: ensure a > b for positive result
      final a = _random.nextInt(9) + 5;  // 5-13
      final b = _random.nextInt(a - 1) + 1; // 1 to (a-1)
      return MathProblem(
        a: a,
        b: b,
        operation: MathOperation.subtraction,
        answer: a - b,
      );
    }
  }

  /// Verify the answer to a math problem.
  ///
  /// Returns true if correct, and unlocks the gate.
  bool verify(MathProblem problem, int userAnswer) {
    if (problem.isCorrect(userAnswer)) {
      _unlockedAt = DateTime.now();
      return true;
    }
    return false;
  }

  /// Manually lock the gate.
  void lock() {
    _unlockedAt = null;
  }

  /// Extend the unlock duration (useful after settings interaction).
  void extendUnlock() {
    if (isUnlocked) {
      _unlockedAt = DateTime.now();
    }
  }
}
