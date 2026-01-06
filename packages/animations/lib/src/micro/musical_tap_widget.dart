import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Musical note to play on tap.
enum MusicalNote {
  c4,  // Do (低)
  d4,  // Re
  e4,  // Mi
  f4,  // Fa
  g4,  // Sol
  a4,  // La
  b4,  // Si
  c5,  // Do (高)
}

/// A widget that plays a musical note and shows visual feedback when tapped.
///
/// Each UI element can be assigned a note, and when tapped, it plays
/// that note while showing a visual "ripple" effect. This turns
/// interaction into musical exploration for kids.
///
/// Example:
/// ```dart
/// MusicalTapWidget(
///   note: MusicalNote.c4,
///   child: ColorButton(color: Colors.red),
/// )
/// ```
class MusicalTapWidget extends StatefulWidget {
  const MusicalTapWidget({
    super.key,
    required this.child,
    this.note = MusicalNote.c4,
    this.onTap,
    this.showVisualFeedback = true,
    this.noteColor,
    this.enabled = true,
    this.hapticFeedback = true,
  });

  /// The child widget to wrap.
  final Widget child;

  /// The musical note to play.
  final MusicalNote note;

  /// Called when tapped.
  final VoidCallback? onTap;

  /// Whether to show visual feedback (note symbol animation).
  final bool showVisualFeedback;

  /// Color of the note visual. If null, uses note-specific color.
  final Color? noteColor;

  /// Whether the widget is interactive.
  final bool enabled;

  /// Whether to provide haptic feedback.
  final bool hapticFeedback;

  @override
  State<MusicalTapWidget> createState() => _MusicalTapWidgetState();
}

class _MusicalTapWidgetState extends State<MusicalTapWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Offset? _tapPosition;
  Size? _widgetSize;

  Color get _noteColor => widget.noteColor ?? _defaultNoteColor;

  Color get _defaultNoteColor => switch (widget.note) {
        MusicalNote.c4 => const Color(0xFFFF6B6B), // Red
        MusicalNote.d4 => const Color(0xFFFF9F43), // Orange
        MusicalNote.e4 => const Color(0xFFFFD93D), // Yellow
        MusicalNote.f4 => const Color(0xFF6BCB77), // Green
        MusicalNote.g4 => const Color(0xFF4D96FF), // Blue
        MusicalNote.a4 => const Color(0xFF9B59B6), // Purple
        MusicalNote.b4 => const Color(0xFFE91E63), // Pink
        MusicalNote.c5 => const Color(0xFFFF6B6B), // Red (高いDo)
      };

  String get _noteSymbol => switch (widget.note) {
        MusicalNote.c4 => 'ド',
        MusicalNote.d4 => 'レ',
        MusicalNote.e4 => 'ミ',
        MusicalNote.f4 => 'ファ',
        MusicalNote.g4 => 'ソ',
        MusicalNote.a4 => 'ラ',
        MusicalNote.b4 => 'シ',
        MusicalNote.c5 => 'ド♪',
      };

  void _handleTap(TapDownDetails details) {
    if (!widget.enabled) return;

    // Haptic feedback
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Visual feedback
    if (widget.showVisualFeedback) {
      setState(() {
        _tapPosition = details.localPosition;
      });

      _controller?.dispose();
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      _controller!.forward().then((_) {
        if (mounted) {
          setState(() => _tapPosition = null);
          _controller?.dispose();
          _controller = null;
        }
      });
    }

    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              widget.child,
              if (_tapPosition != null && _controller != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, _) {
                        return CustomPaint(
                          painter: _MusicalNotePainter(
                            progress: _controller!.value,
                            position: _tapPosition!,
                            color: _noteColor,
                            noteSymbol: _noteSymbol,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MusicalNotePainter extends CustomPainter {
  _MusicalNotePainter({
    required this.progress,
    required this.position,
    required this.color,
    required this.noteSymbol,
  });

  final double progress;
  final Offset position;
  final Color color;
  final String noteSymbol;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1) return;

    final opacity = (1 - progress).clamp(0.0, 1.0);

    // Rising note animation
    final riseAmount = 60 * Curves.easeOut.transform(progress);
    final wobble = math.sin(progress * math.pi * 4) * 10 * (1 - progress);

    final noteCenter = Offset(
      position.dx + wobble,
      position.dy - riseAmount,
    );

    // Glow effect
    final glowRadius = 30 + 20 * progress;
    final glowPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(noteCenter, glowRadius, glowPaint);

    // Note circle
    final circleRadius = 20 * (1 + progress * 0.3);
    final circlePaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(noteCenter, circleRadius, circlePaint);

    // Note border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(noteCenter, circleRadius, borderPaint);

    // Draw musical note symbol
    final textPainter = TextPainter(
      text: TextSpan(
        text: noteSymbol,
        style: TextStyle(
          color: Colors.white.withValues(alpha: opacity),
          fontSize: 14 + progress * 4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      noteCenter - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    // Sparkle particles
    _drawSparkles(canvas, noteCenter, progress, opacity);
  }

  void _drawSparkles(Canvas canvas, Offset center, double progress, double opacity) {
    final sparkleCount = 6;
    final sparklePaint = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < sparkleCount; i++) {
      final angle = (i / sparkleCount) * math.pi * 2 + progress * math.pi;
      final distance = 30 + 25 * progress;
      final sparkleSize = 3 * (1 - progress);

      final sparklePos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      canvas.drawCircle(sparklePos, sparkleSize, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(_MusicalNotePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// A row of colored buttons that each play a different note.
///
/// Creates a simple piano-like interface where each color
/// corresponds to a musical note.
class MusicalColorRow extends StatelessWidget {
  const MusicalColorRow({
    super.key,
    this.onNoteTap,
    this.buttonSize = 40,
  });

  /// Called when any note is tapped.
  final void Function(MusicalNote note)? onNoteTap;

  /// Size of each button.
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate button size to fit within constraints
        final availableWidth = constraints.maxWidth;
        final noteCount = MusicalNote.values.length;
        final totalPadding = (noteCount - 1) * 6; // 3px padding on each side
        final maxButtonSize = (availableWidth - totalPadding) / noteCount;
        final effectiveSize = buttonSize.clamp(24.0, maxButtonSize.clamp(24.0, buttonSize));

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          runSpacing: 6,
          children: MusicalNote.values.map((note) {
            final color = _noteToColor(note);
            return MusicalTapWidget(
              note: note,
              onTap: () => onNoteTap?.call(note),
              child: Container(
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(effectiveSize / 4),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _noteToColor(MusicalNote note) => switch (note) {
        MusicalNote.c4 => const Color(0xFFFF6B6B),
        MusicalNote.d4 => const Color(0xFFFF9F43),
        MusicalNote.e4 => const Color(0xFFFFD93D),
        MusicalNote.f4 => const Color(0xFF6BCB77),
        MusicalNote.g4 => const Color(0xFF4D96FF),
        MusicalNote.a4 => const Color(0xFF9B59B6),
        MusicalNote.b4 => const Color(0xFFE91E63),
        MusicalNote.c5 => const Color(0xFFFF6B6B),
      };
}

/// Extension to easily add musical tap to any widget.
extension MusicalTapExtension on Widget {
  Widget withMusicalTap({
    MusicalNote note = MusicalNote.c4,
    VoidCallback? onTap,
    bool showVisualFeedback = true,
  }) {
    return MusicalTapWidget(
      note: note,
      onTap: onTap,
      showVisualFeedback: showVisualFeedback,
      child: this,
    );
  }
}
