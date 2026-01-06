import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A fun, animated caterpillar progress indicator for kids.
///
/// The caterpillar "eats" leaves as progress increases, growing body segments.
/// When progress reaches 100%, it transforms into a butterfly!
///
/// Example:
/// ```dart
/// CaterpillarProgress(
///   progress: 0.6, // 60% complete
///   onComplete: () => print('Transformed!'),
/// )
/// ```
class CaterpillarProgress extends StatefulWidget {
  const CaterpillarProgress({
    super.key,
    required this.progress,
    this.onComplete,
    this.showPercentage = true,
    this.leafCount = 5,
    this.caterpillarColor = const Color(0xFF6BCF7E),
    this.height = 96.0,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Called when progress reaches 1.0 (100%).
  final VoidCallback? onComplete;

  /// Whether to show the percentage text.
  final bool showPercentage;

  /// Number of leaves to show (default 5).
  final int leafCount;

  /// Color of the caterpillar (default green).
  final Color caterpillarColor;

  /// Height of the widget.
  final double height;

  @override
  State<CaterpillarProgress> createState() => _CaterpillarProgressState();
}

class _CaterpillarProgressState extends State<CaterpillarProgress>
    with TickerProviderStateMixin {
  late AnimationController _bobController;
  late AnimationController _antennaController;
  late AnimationController _eatingController;
  late AnimationController _butterflyController;

  bool _isBlinking = false;
  bool _isEating = false;
  Timer? _blinkTimer;
  double _previousProgress = 0.0;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Bobbing animation (head moves up/down)
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Antenna waving
    _antennaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Eating animation
    _eatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Butterfly transformation
    _butterflyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _previousProgress = widget.progress;
    _scheduleNextBlink();

    if (widget.progress >= 1.0) {
      _butterflyController.forward();
    }
  }

  void _scheduleNextBlink() {
    _blinkTimer?.cancel();
    final nextBlink = 2000 + _random.nextInt(2000);
    _blinkTimer = Timer(Duration(milliseconds: nextBlink), () {
      if (mounted && _random.nextDouble() > 0.5) {
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _isBlinking = false);
        });
      }
      _scheduleNextBlink();
    });
  }

  @override
  void didUpdateWidget(CaterpillarProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger eating animation when progress increases
    if (widget.progress > _previousProgress && widget.progress < 1.0) {
      _triggerEating();
    }

    // Trigger butterfly transformation
    if (widget.progress >= 1.0 && _previousProgress < 1.0) {
      _butterflyController.forward();
      // Defer callback to avoid setState during build
      if (widget.onComplete != null) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          widget.onComplete?.call();
        });
      }
    }

    _previousProgress = widget.progress;
  }

  void _triggerEating() {
    setState(() => _isEating = true);
    _eatingController.forward(from: 0).then((_) {
      if (mounted) setState(() => _isEating = false);
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _bobController.dispose();
    _antennaController.dispose();
    _eatingController.dispose();
    _butterflyController.dispose();
    super.dispose();
  }

  int get _segments => (widget.progress * widget.leafCount).floor();

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (widget.progress >= 1.0) {
      return _buildButterfly(reduceMotion);
    }

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Leaves along the path
          _buildLeaves(reduceMotion),

          // Caterpillar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: _buildCaterpillar(reduceMotion),
          ),

          // Progress percentage
          if (widget.showPercentage)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '${(widget.progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildButterfly(bool reduceMotion) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: AnimatedBuilder(
          animation: _butterflyController,
          builder: (context, child) {
            final scale = Curves.elasticOut.transform(
              _butterflyController.value.clamp(0.0, 1.0),
            );
            final rotation = (1 - _butterflyController.value) * -math.pi;

            return Transform.scale(
              scale: reduceMotion ? 1.0 : scale,
              child: Transform.rotate(
                angle: reduceMotion ? 0 : rotation,
                child: child,
              ),
            );
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Floating butterfly
                AnimatedBuilder(
                  animation: _bobController,
                  builder: (context, child) {
                    final offset = reduceMotion
                        ? 0.0
                        : math.sin(_bobController.value * math.pi * 2) * 5;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: const Text(
                    '🦋',
                    style: TextStyle(fontSize: 48),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: widget.caterpillarColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaves(bool reduceMotion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.leafCount, (index) {
          final isEaten = index < _segments;

          return AnimatedOpacity(
            opacity: isEaten ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedScale(
              scale: isEaten ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: const Text(
                '🍃',
                style: TextStyle(fontSize: 28),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCaterpillar(bool reduceMotion) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Head
        _buildHead(reduceMotion),

        // Body segments
        ...List.generate(_segments, (index) => _buildSegment(index, reduceMotion)),
      ],
    );
  }

  Widget _buildHead(bool reduceMotion) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bobController, _eatingController]),
      builder: (context, child) {
        double offsetY = 0;
        double scaleX = 1.0;

        if (!reduceMotion) {
          if (_isEating) {
            // Eating animation: squish horizontally
            scaleX = 1.0 - (math.sin(_eatingController.value * math.pi) * 0.1);
          } else {
            // Normal bobbing
            offsetY = math.sin(_bobController.value * math.pi) * 2;
          }
        }

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scaleX: scaleX,
            child: child,
          ),
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: widget.caterpillarColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Antennae
            _buildAntennae(reduceMotion),

            // Eyes
            Positioned(
              top: 12,
              left: 12,
              child: Row(
                children: [
                  _buildEye(),
                  const SizedBox(width: 8),
                  _buildEye(),
                ],
              ),
            ),

            // Smile
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withValues(alpha: 0.7),
                        width: 2,
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),

            // Eating face overlay
            if (_isEating)
              const Positioned.fill(
                child: Center(
                  child: Text('😋', style: TextStyle(fontSize: 24)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAntennae(bool reduceMotion) {
    return Positioned(
      top: -8,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _antennaController,
          builder: (context, child) {
            final angle = reduceMotion
                ? 0.0
                : math.sin(_antennaController.value * math.pi * 2) * 0.2;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: -angle,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: widget.caterpillarColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Transform.rotate(
                  angle: angle,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: widget.caterpillarColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEye() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: 8,
      height: _isBlinking ? 2 : 12,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSegment(int index, bool reduceMotion) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _bobController,
        builder: (context, child) {
          // Alternating wave motion
          final phase = index % 2 == 0 ? 0.0 : math.pi;
          final offsetY = reduceMotion
              ? 0.0
              : math.sin(_bobController.value * math.pi * 2 + phase) * 2;

          return Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          );
        },
        child: Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.caterpillarColor,
                HSLColor.fromColor(widget.caterpillarColor)
                    .withLightness(
                      (HSLColor.fromColor(widget.caterpillarColor).lightness - 0.1)
                          .clamp(0.0, 1.0),
                    )
                    .toColor(),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
