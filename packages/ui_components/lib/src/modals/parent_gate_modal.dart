import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

import '../buttons/primary_button.dart';
import '../buttons/icon_action_button.dart';

/// A modal that implements the parent gate verification.
///
/// Requires a 3-second hold followed by a simple math problem.
class ParentGateModal extends StatefulWidget {
  const ParentGateModal({
    super.key,
    required this.onVerified,
    this.onCancel,
  });

  /// Callback when parent verification succeeds.
  final VoidCallback onVerified;

  /// Callback when modal is cancelled.
  final VoidCallback? onCancel;

  /// Shows the parent gate modal.
  static Future<bool> show(BuildContext context) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: AppSpacing.durationNormal,
      pageBuilder: (context, animation, secondaryAnimation) {
        return ParentGateModal(
          onVerified: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  State<ParentGateModal> createState() => _ParentGateModalState();
}

class _ParentGateModalState extends State<ParentGateModal>
    with SingleTickerProviderStateMixin {
  late final ParentGateService _parentGateService;
  late AnimationController _holdController;

  _ParentGateStep _currentStep = _ParentGateStep.hold;
  MathProblem? _mathProblem;
  String _answer = '';
  bool _isWrong = false;

  @override
  void initState() {
    super.initState();
    _parentGateService = ParentGateService();
    _holdController = AnimationController(
      duration: _parentGateService.holdDuration,
      vsync: this,
    );

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showMathProblem();
      }
    });
  }

  void _showMathProblem() {
    setState(() {
      _currentStep = _ParentGateStep.math;
      _mathProblem = _parentGateService.generateProblem();
    });
  }

  void _onAnswerSubmit() {
    if (_mathProblem == null) return;

    final answerInt = int.tryParse(_answer);
    if (answerInt == null) return;

    if (_parentGateService.verify(_mathProblem!, answerInt)) {
      widget.onVerified();
    } else {
      setState(() {
        _isWrong = true;
        _answer = '';
        _mathProblem = _parentGateService.generateProblem();
      });

      Future.delayed(AppSpacing.durationNormal, () {
        if (mounted) {
          setState(() => _isWrong = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.horizontalLg,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 340),
            padding: AppSpacing.insetXl,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.radiusXxl,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '🔒',
                      style: TextStyle(fontSize: 32),
                    ),
                    Text(
                      'おとなのかた へ',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    AppCloseButton(onTap: widget.onCancel),
                  ],
                ),
                const VGap.lg(),

                // Content based on step
                if (_currentStep == _ParentGateStep.hold)
                  _buildHoldStep()
                else
                  _buildMathStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoldStep() {
    return Column(
      children: [
        Text(
          'ボタンを 3びょう\nおしつづけてね',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const VGap.xl(),

        // Hold button
        GestureDetector(
          onTapDown: (_) => _holdController.forward(),
          onTapUp: (_) => _holdController.reverse(),
          onTapCancel: () => _holdController.reverse(),
          child: AnimatedBuilder(
            animation: _holdController,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.learningSecondary,
                  border: Border.all(
                    color: AppColors.learningPrimary,
                    width: 6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.learningPrimary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Progress circle
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: _holdController.value,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.learningPrimary,
                        ),
                        backgroundColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    // Icon
                    Icon(
                      Icons.touch_app_rounded,
                      size: 48,
                      color: AppColors.learningPrimary,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const VGap.lg(),

        Text(
          'おさえたまま まってね',
          style: AppTypography.caption.copyWith(
            color: AppColors.textDisabledLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMathStep() {
    if (_mathProblem == null) return const SizedBox.shrink();

    return Column(
      children: [
        AnimatedContainer(
          duration: AppSpacing.durationFast,
          padding: AppSpacing.insetLg,
          decoration: BoxDecoration(
            color: _isWrong
                ? AppColors.errorGentle
                : AppColors.learningSecondary.withOpacity(0.3),
            borderRadius: AppSpacing.radiusLg,
            border: Border.all(
              color: _isWrong
                  ? AppColors.errorBorder
                  : AppColors.learningPrimary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Text(
            _mathProblem!.displayText,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
        const VGap.lg(),

        // Number input
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppSpacing.radiusLg,
            border: Border.all(
              color: AppColors.textDisabledLight,
              width: 2,
            ),
          ),
          child: Text(
            _answer.isEmpty ? '?' : _answer,
            style: AppTypography.headlineMedium.copyWith(
              color: _answer.isEmpty
                  ? AppColors.textDisabledLight
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
        const VGap.lg(),

        // Number pad
        _buildNumberPad(),
        const VGap.lg(),

        // Submit button
        PrimaryButton(
          text: 'こたえる',
          onTap: _answer.isNotEmpty ? _onAnswerSubmit : null,
          enabled: _answer.isNotEmpty,
        ),

        if (_isWrong) ...[
          const VGap.md(),
          Text(
            'ちがうよ、もういちど！',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.errorBorder,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNumberButton('C', isAction: true),
            _buildNumberButton('0'),
            _buildNumberButton('⌫', isAction: true),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String label, {bool isAction = false}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: isAction
            ? AppColors.surfaceLight
            : AppColors.learningSecondary.withOpacity(0.3),
        borderRadius: AppSpacing.radiusMd,
        child: InkWell(
          onTap: () {
            if (label == 'C') {
              setState(() => _answer = '');
            } else if (label == '⌫') {
              if (_answer.isNotEmpty) {
                setState(() => _answer = _answer.substring(0, _answer.length - 1));
              }
            } else {
              if (_answer.length < 3) {
                setState(() => _answer = _answer + label);
              }
            }
          },
          borderRadius: AppSpacing.radiusMd,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Text(
              label,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ParentGateStep {
  hold,
  math,
}
