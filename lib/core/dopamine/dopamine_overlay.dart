import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/kinly_sections.dart';
import '../time/clock.dart';
import '../telemetry/telemetry.dart';
import 'dopamine_models.dart';
import 'enums/dopamine_milestone.dart';

/// Hosts dopamine overlays and enforces cooldown/queue rules.
class DopamineOverlayHost extends StatefulWidget {
  const DopamineOverlayHost({
    super.key,
    required this.child,
    this.clock = const SystemClock(),
    this.telemetry = const NullTelemetry(),
  });

  final Widget child;
  final Clock clock;
  final Telemetry telemetry;

  static DopamineOverlayHostState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<DopamineOverlayHostState>();
  }

  @override
  State<DopamineOverlayHost> createState() => DopamineOverlayHostState();
}

class DopamineOverlayHostState extends State<DopamineOverlayHost>
    with TickerProviderStateMixin {
  static const _cooldown = Duration(seconds: 3);
  static const _coalesceWindow = Duration(seconds: 1);
  static const _visibleDuration = Duration(milliseconds: 600);

  OverlayEntry? _entry;
  AnimationController? _controller;
  Timer? _dismissTimer;
  DateTime? _lastShownAt;

  Future<void> show(DopamineMoment moment, {Rect? anchorRect}) async {
    final now = widget.clock.now();
    final sinceLast = _lastShownAt == null ? null : now.difference(_lastShownAt!);
    final withinCoalesceWindow =
        sinceLast != null && sinceLast < _coalesceWindow && _entry != null;

    if (withinCoalesceWindow) {
      // Coalesce: replace active entry with latest moment.
      _lastShownAt = now;
      _removeActive();
    } else {
      // Cooldown: drop if shown too recently.
      if (sinceLast != null && sinceLast < _cooldown) {
        return;
      }
      _lastShownAt = now;
      _removeActive();
    }

    final overlay = Overlay.of(context, debugRequiredFor: widget);

    final mediaQuery = MediaQuery.maybeOf(context);
    final reduceMotion =
        moment.reduceMotion || (mediaQuery?.disableAnimations ?? false);
    final size =
        mediaQuery?.size ?? MediaQueryData.fromView(View.of(context)).size;
    final resolvedAnchor = anchorRect ?? _defaultAnchor(size);

    _controller = AnimationController(
      vsync: this,
      duration:
          reduceMotion
              ? const Duration(milliseconds: 200)
              : const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 220),
    );

    _entry = OverlayEntry(
      builder:
          (context) => _DopamineOverlay(
            animation: _controller!,
            moment: moment.copyWith(reduceMotion: reduceMotion),
            anchorRect: resolvedAnchor,
          ),
    );

    widget.telemetry.track(
      'dopamine_shown',
      properties: {
        'milestone': moment.milestone.name,
        'strength': moment.strength.name,
        'echo_present': (moment.echo?.isNotEmpty ?? false),
        'reduce_motion': reduceMotion,
        'haptic_used': !reduceMotion && moment.hapticEnabled,
        'theme':
            Theme.of(context).brightness == Brightness.dark ? 'dark' : 'light',
      },
    );

    overlay.insert(_entry!);
    _controller!.forward();
    _playHaptic(moment, reduceMotion);

    _dismissTimer = Timer(_visibleDuration, _dismissActive);
  }

  void _dismissActive() {
    _controller?.reverse();
    _dismissTimer?.cancel();
    _dismissTimer = Timer(const Duration(milliseconds: 260), _removeActive);
  }

  void _removeActive() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _controller?.dispose();
    _controller = null;
    _entry?.remove();
    _entry = null;
  }

  void _playHaptic(DopamineMoment moment, bool reduceMotion) {
    if (reduceMotion || !moment.hapticEnabled) return;
    switch (moment.milestone) {
      case DopamineMilestone.flow:
      case DopamineMilestone.pulse:
        HapticFeedback.lightImpact();
        break;
      case DopamineMilestone.share:
        HapticFeedback.selectionClick();
        break;
      case DopamineMilestone.reflection:
        HapticFeedback.mediumImpact();
        break;
    }
  }

  Rect _defaultAnchor(Size size) {
    final width = 160.0;
    final height = 48.0;
    final left = (size.width - width) / 2;
    final top = max(24.0, size.height * 0.68 - height);
    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  void dispose() {
    _removeActive();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _DopamineOverlay extends StatelessWidget {
  const _DopamineOverlay({
    required this.animation,
    required this.moment,
    required this.anchorRect,
  });

  final Animation<double> animation;
  final DopamineMoment moment;
  final Rect anchorRect;

  @override
  Widget build(BuildContext context) {
    final accent = _resolveAccent(context, moment.milestone);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final curveValue = Curves.easeOut.transform(animation.value);
          final microOpacity = moment.reduceMotion ? 1.0 : curveValue;
          final microScale =
              moment.reduceMotion ? 1.0 : 0.92 + (0.18 * curveValue);
          // Quick pulse: scale up then settle.
          final pulsePhase =
              curveValue < 0.5 ? curveValue * 2 : (1 - curveValue) * 2;
          final pulseScale =
              moment.reduceMotion ? 1.0 : 1.0 + (0.05 * pulsePhase);
          final pulseOpacity =
              moment.reduceMotion ? 0.0 : 0.35 * (1 - curveValue);
          final iconData = _iconFor(moment.milestone);

          return Stack(
            children: [
              // Button pulse (tight lift effect)
              Positioned(
                left: anchorRect.left,
                top: anchorRect.top,
                child: Transform.scale(
                  scale: pulseScale,
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: pulseOpacity,
                    child: Container(
                      width: anchorRect.width,
                      height: anchorRect.height,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              // Micro animation at anchor
              Positioned(
                left: anchorRect.center.dx - 16,
                top: anchorRect.center.dy - 16,
                child: Transform.scale(
                  scale: microScale,
                  child: Opacity(
                    opacity: microOpacity,
                    child: _MicroBurst(
                      color: accent,
                      icon: iconData,
                      milestone: moment.milestone,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _resolveAccent(BuildContext context, DopamineMilestone milestone) {
    final sections = Theme.of(context).extension<KinlySections>();
    switch (milestone) {
      case DopamineMilestone.flow:
        return sections?.flow.accent ?? Theme.of(context).colorScheme.primary;
      case DopamineMilestone.share:
        return sections?.share.accent ?? Theme.of(context).colorScheme.primary;
      case DopamineMilestone.pulse:
        return sections?.pulse.accent ?? Theme.of(context).colorScheme.tertiary;
      case DopamineMilestone.reflection:
        return sections?.pulse.accent ?? Theme.of(context).colorScheme.tertiary;
    }
  }
}

class _MicroBurst extends StatelessWidget {
  const _MicroBurst({
    required this.color,
    required this.icon,
    required this.milestone,
  });

  final Color color;
  final IconData icon;
  final DopamineMilestone milestone;

  @override
  Widget build(BuildContext context) {
    final isBloom = milestone == DopamineMilestone.reflection;
    final isShare = milestone == DopamineMilestone.share;
    final size = isBloom ? 40.0 : (isShare ? 36.0 : 32.0);
    final blur = isBloom ? 18.0 : (isShare ? 14.0 : 12.0);
    final spread = isBloom ? 8.0 : (isShare ? 6.0 : 4.0);
    final innerOpacity = isBloom ? 0.55 : (isShare ? 0.78 : 0.75);
    final iconSize = isBloom ? 0.0 : (isShare ? 20.0 : 18.0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: innerOpacity),
            color.withValues(alpha: 0.0),
          ],
          stops: const [0.2, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: blur,
            spreadRadius: spread,
          ),
        ],
      ),
      child:
          isBloom
              ? null
              : Center(
                child: Icon(
                  icon,
                  size: iconSize,
                  color: color.withValues(alpha: 0.9),
                ),
              ),
    );
  }
}

IconData _iconFor(DopamineMilestone milestone) {
  switch (milestone) {
    case DopamineMilestone.flow:
      return Icons.auto_awesome;
    case DopamineMilestone.share:
      return Icons.check_rounded;
    case DopamineMilestone.pulse:
      return Icons.favorite_rounded;
    case DopamineMilestone.reflection:
      return Icons.wb_iridescent_rounded;
  }
}
