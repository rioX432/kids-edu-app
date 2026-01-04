import 'package:hive/hive.dart';

part 'stamp_book.g.dart';

/// A stamp book that tracks daily progress.
///
/// Children collect stamps each day they complete activities.
/// Completing a stamp book unlocks rewards.
@HiveType(typeId: 3)
class StampBook extends HiveObject {
  StampBook({
    required this.id,
    required this.profileId,
    required this.totalSlots,
    this.filledSlots = 0,
    this.completedAt,
    List<DateTime>? stampDates,
  }) : stampDates = stampDates ?? [];

  /// Unique identifier.
  @HiveField(0)
  final String id;

  /// Profile this stamp book belongs to.
  @HiveField(1)
  final String profileId;

  /// Total number of slots in this stamp book.
  @HiveField(2)
  final int totalSlots;

  /// Number of slots filled with stamps.
  @HiveField(3)
  int filledSlots;

  /// When the stamp book was completed (null if not completed).
  @HiveField(4)
  DateTime? completedAt;

  /// Dates when stamps were added.
  @HiveField(5)
  List<DateTime> stampDates;

  /// Whether the stamp book is completed.
  bool get isCompleted => filledSlots >= totalSlots;

  /// Progress as a percentage (0.0 to 1.0).
  double get progress => filledSlots / totalSlots;

  /// Number of remaining slots.
  int get remainingSlots => totalSlots - filledSlots;

  /// Add a stamp to this book.
  ///
  /// Returns true if a stamp was added, false if already full.
  bool addStamp() {
    if (isCompleted) return false;

    filledSlots++;
    stampDates.add(DateTime.now());

    if (isCompleted) {
      completedAt = DateTime.now();
    }

    return true;
  }

  /// Create a copy with updated fields.
  StampBook copyWith({
    String? id,
    String? profileId,
    int? totalSlots,
    int? filledSlots,
    DateTime? completedAt,
    List<DateTime>? stampDates,
  }) {
    return StampBook(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      totalSlots: totalSlots ?? this.totalSlots,
      filledSlots: filledSlots ?? this.filledSlots,
      completedAt: completedAt ?? this.completedAt,
      stampDates: stampDates ?? List.from(this.stampDates),
    );
  }

  @override
  String toString() =>
      'StampBook(id: $id, filled: $filledSlots/$totalSlots, completed: $isCompleted)';
}
