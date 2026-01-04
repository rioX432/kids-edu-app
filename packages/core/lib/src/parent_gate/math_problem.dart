/// A simple math problem for parent gate verification.
class MathProblem {
  const MathProblem({
    required this.a,
    required this.b,
    required this.operation,
    required this.answer,
  });

  /// First operand.
  final int a;

  /// Second operand.
  final int b;

  /// Operation type.
  final MathOperation operation;

  /// Correct answer.
  final int answer;

  /// Format the problem as a string (e.g., "7 + 5 = ?").
  String get displayText => '$a ${operation.symbol} $b = ?';

  /// Check if the given answer is correct.
  bool isCorrect(int userAnswer) => userAnswer == answer;
}

/// Math operation types.
enum MathOperation {
  addition('+'),
  subtraction('-');

  const MathOperation(this.symbol);

  final String symbol;
}
