import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/enums/reflective_generation_mode.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/core/ui/reflective_generation/enums/reflective_phase.dart';

/// Kinly goal alignment (why these choices):
/// - Calm + readable: pause is in seconds, not milliseconds.
/// - Low-noise: short acknowledgement, then primary lands, then secondary fades in.
/// - Never feels "stuck": bounded max pause, and completion always fires.
/// - Deterministic timing: secondary reveal is scheduled *after* pause starts.
class ReflectiveGenerationOverlay extends StatefulWidget {
  const ReflectiveGenerationOverlay({
    super.key,
    required this.mode,
    required this.onCompleted,

    /// Short acknowledgement (e.g. "Got it") before the reflective pause copy.
    /// Keep this brief so the UI feels responsive.
    this.acknowledgementDuration = const Duration(milliseconds: 500),

    /// The actual "pause" where users read the primary/secondary copy.
    /// Defaults to seconds because it should be readable.
    this.pauseDuration = const Duration(seconds: 4),

    /// How long after the pause begins the secondary line should appear.
    /// This ensures the primary has "landed" first.
    this.secondaryAfterPauseDelay,
  });

  final ReflectiveGenerationMode mode;
  final VoidCallback onCompleted;

  final Duration acknowledgementDuration;
  final Duration pauseDuration;

  /// If null, a Kinly-tuned delay is derived from pauseDuration (calm but not sluggish).
  final Duration? secondaryAfterPauseDelay;

  @override
  State<ReflectiveGenerationOverlay> createState() =>
      _ReflectiveGenerationOverlayState();
}

class _ReflectiveGenerationOverlayState
    extends State<ReflectiveGenerationOverlay>
    with SingleTickerProviderStateMixin {
  // Kinly-tuned guardrails.
  static const Duration _minAck = Duration(milliseconds: 200);
  static const Duration _maxAck = Duration(seconds: 2);
  static const Duration _minPause = Duration(seconds: 2);
  static const Duration _maxPause = Duration(seconds: 10);

  // Breathing tuned to “calm”. (Your old 1200ms can feel twitchy for longer pauses.)
  static const Duration _breathingPeriod = Duration(milliseconds: 1800);
  static const double _breathingLower = 0.94;
  static const double _breathingUpper = 1.0;

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
      widget.acknowledgementDuration >= _minAck &&
          widget.acknowledgementDuration <= _maxAck,
      'Reflective acknowledgementDuration should be ${_minAck.inMilliseconds}ms–${_maxAck.inSeconds}s.',
    );
    assert(
      widget.pauseDuration >= _minPause && widget.pauseDuration <= _maxPause,
      'Reflective pauseDuration should be ${_minPause.inSeconds}s–${_maxPause.inSeconds}s.',
    );

    _breathingController = AnimationController(
      vsync: this,
      duration: _breathingPeriod,
      lowerBound: _breathingLower,
      upperBound: _breathingUpper,
    )..repeat(reverse: true);

    _breathingScale = CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    );

    _startTimers();
  }

  @override
  void didUpdateWidget(covariant ReflectiveGenerationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final timingChanged =
        oldWidget.acknowledgementDuration != widget.acknowledgementDuration ||
        oldWidget.pauseDuration != widget.pauseDuration ||
        oldWidget.secondaryAfterPauseDelay != widget.secondaryAfterPauseDelay;

    final modeChanged = oldWidget.mode != widget.mode;

    if (timingChanged || modeChanged) {
      _reset();
      _restartTimers();
    }
  }

  @override
  void dispose() {
    _cancelTimers();
    _breathingController.dispose();
    super.dispose();
  }

  void _reset() {
    _completed = false;
    _showSecondary = false;
    _phase = ReflectivePhase.acknowledge;
  }

  void _restartTimers() {
    _cancelTimers();
    _startTimers();
  }

  void _cancelTimers() {
    _ackTimer?.cancel();
    _completeTimer?.cancel();
    _secondaryTimer?.cancel();
    _ackTimer = null;
    _completeTimer = null;
    _secondaryTimer = null;
  }

  // Derived delay so the secondary appears after the primary lands.
  // For Kinly: calm, readable, not sluggish.
  Duration _derivedSecondaryAfterPauseDelay(Duration pause) {
    // About ~20–25% into the pause, clamped to sensible bounds.
    final ms = (pause.inMilliseconds * 0.22).round().clamp(650, 1100);
    return Duration(milliseconds: ms);
  }

  void _startTimers() {
    _ackTimer = Timer(widget.acknowledgementDuration, () {
      if (!mounted || _completed) return;

      setState(() => _phase = ReflectivePhase.pause);

      // Secondary is scheduled *after* we enter pause phase,
      // so primary has time to land first.
      final afterPauseDelay =
          widget.secondaryAfterPauseDelay ??
          _derivedSecondaryAfterPauseDelay(widget.pauseDuration);

      _secondaryTimer?.cancel();
      _secondaryTimer = Timer(afterPauseDelay, () {
        if (!mounted || _completed) return;
        setState(() => _showSecondary = true);
      });
    });

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
              duration: const Duration(milliseconds: 260),
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
      case ReflectiveGenerationMode.houseNorms:
        return _ReflectiveCopy(
          primary: strings.reflectiveHouseNormsPrimary,
          secondary: strings.reflectiveHouseNormsSecondary,
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
