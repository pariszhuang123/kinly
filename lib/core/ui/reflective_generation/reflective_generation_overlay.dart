import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/reflective_generation/enums/reflective_phase.dart';

class ReflectiveGenerationOverlay extends StatefulWidget {
  const ReflectiveGenerationOverlay({
    super.key,
    required this.mode,
    required this.onCompleted,
    this.acknowledgementDuration = const Duration(milliseconds: 250),
    this.pauseDuration = const Duration(milliseconds: 1150),
  });

  final ReflectiveGenerationMode mode;
  final VoidCallback onCompleted;
  final Duration acknowledgementDuration;
  final Duration pauseDuration;

  @override
  State<ReflectiveGenerationOverlay> createState() =>
      _ReflectiveGenerationOverlayState();
}

class _ReflectiveGenerationOverlayState
    extends State<ReflectiveGenerationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathingController;
  late final Animation<double> _breathingScale;
  Timer? _ackTimer;
  Timer? _completeTimer;
  Timer? _secondaryTimer;
  ReflectivePhase _phase = ReflectivePhase.acknowledge;
  bool _completed = false;
  bool _showSecondary = false;

  Duration get _totalDuration =>
      widget.acknowledgementDuration + widget.pauseDuration;

  @override
  void initState() {
    super.initState();
    assert(
      _totalDuration.inMilliseconds >= 600 &&
          _totalDuration.inMilliseconds <= 1800,
      'Reflective generation duration must be between 600ms and 1800ms.',
    );
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.92,
      upperBound: 1.0,
    )..repeat(reverse: true);
    _breathingScale = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    );
    _startTimers();
  }

  @override
  void dispose() {
    _ackTimer?.cancel();
    _completeTimer?.cancel();
    _secondaryTimer?.cancel();
    _breathingController.dispose();
    super.dispose();
  }

  void _startTimers() {
    _ackTimer = Timer(widget.acknowledgementDuration, () {
      if (!mounted || _completed) return;
      setState(() => _phase = ReflectivePhase.pause);
    });
    _secondaryTimer = Timer(
      widget.acknowledgementDuration + const Duration(milliseconds: 320),
      () {
        if (!mounted || _completed) return;
        setState(() => _showSecondary = true);
      },
    );
    _completeTimer = Timer(_totalDuration, _complete);
  }

  void _complete() {
    if (_completed) return;
    _completed = true;
    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>();
    final colors = theme.colorScheme;
    final headline = theme.textTheme.headlineSmall;
    final body = theme.textTheme.bodyMedium;
    final s = S.of(context);
    final copy = _copyPack(mode: widget.mode, strings: s);

    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: colors.surface.withValues(alpha: 0.96),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              spacing?.lg ?? 16,
              spacing?.xl ?? 24,
              spacing?.lg ?? 16,
              spacing?.xl ?? 24,
            ),
            child: Stack(
              children: [
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child:
                        _phase == ReflectivePhase.acknowledge
                            ? _buildAcknowledgement(
                              headline,
                              colors.onSurface,
                              s.reflectiveAcknowledgementTitle,
                            )
                            : _buildPause(
                              headline,
                              body,
                              copy,
                              colors.onSurface,
                              colors.onSurfaceVariant,
                              spacing,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcknowledgement(
    TextStyle? headline,
    Color textColor,
    String text,
  ) {
    return Text(
      text,
      key: const ValueKey('reflective_ack'),
      style: headline?.copyWith(color: textColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPause(
    TextStyle? headline,
    TextStyle? body,
    _ReflectiveCopy copy,
    Color onSurface,
    Color onSurfaceVariant,
    Spacing? spacing,
  ) {
    return ScaleTransition(
      key: const ValueKey('reflective_pause'),
      scale: _breathingScale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            copy.primary,
            style: headline?.copyWith(color: onSurface),
            textAlign: TextAlign.center,
          ),
          if (copy.secondary != null) ...[
            SizedBox(height: spacing?.s ?? 8),
            AnimatedOpacity(
              opacity: _showSecondary ? 1 : 0,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              child: Text(
                copy.secondary!,
                style: body?.copyWith(color: onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ReflectiveCopy _copyPack({
    required ReflectiveGenerationMode mode,
    required S strings,
  }) {
    switch (mode) {
      case ReflectiveGenerationMode.personalPreferences:
        return _ReflectiveCopy(
          primary: strings.reflectivePersonalPrimary,
          secondary: strings.reflectivePersonalSecondary,
        );
      case ReflectiveGenerationMode.houseRules:
        return _ReflectiveCopy(
          primary: strings.reflectiveHousePrimary,
          secondary: strings.reflectiveHouseSecondary,
        );
      case ReflectiveGenerationMode.generic:
        return _ReflectiveCopy(
          primary: strings.reflectiveGenericPrimary,
          secondary: strings.reflectiveGenericSecondary,
        );
    }
  }
}

class _ReflectiveCopy {
  const _ReflectiveCopy({required this.primary, this.secondary});

  final String primary;
  final String? secondary;
}
