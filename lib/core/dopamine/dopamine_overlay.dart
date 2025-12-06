import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/kinly_sections.dart';
import '../theme/spacing.dart';
import 'dopamine_models.dart';

/// Hosts dopamine overlays and enforces cooldown/queue rules.
class DopamineOverlayHost extends StatefulWidget {
  const DopamineOverlayHost({super.key, required this.child});

  final Widget child;

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
  static const _visibleDuration = Duration(seconds: 2);

  OverlayEntry? _entry;
  AnimationController? _controller;
  Timer? _dismissTimer;
  DateTime? _lastShownAt;

  Future<void> show(DopamineMoment moment, {Rect? anchorRect}) async {
    final now = DateTime.now();

    // Cooldown: drop if shown too recently.
    if (_lastShownAt != null && now.difference(_lastShownAt!) < _cooldown) {
      return;
    }

    // Coalesce: replace any active entry with the latest moment.
    if (_lastShownAt != null &&
        now.difference(_lastShownAt!) < _coalesceWindow &&
        _entry != null) {
      _removeActive();
    }

    _lastShownAt = now;
    _removeActive();

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
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>();
    final sections = theme.extension<KinlySections>();
    final colors = _resolveSectionColors(sections, moment.milestone, theme);
    final cardTop = max(
      12.0,
      min(anchorRect.top - 88, MediaQuery.sizeOf(context).height - 140),
    );
    final cardLeft = max(
      12.0,
      min(anchorRect.center.dx - 120, MediaQuery.sizeOf(context).width - 240),
    );

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final curveValue = Curves.easeOut.transform(animation.value);
          final microOpacity = moment.reduceMotion ? 1.0 : curveValue;
          final microScale =
              moment.reduceMotion ? 1.0 : 0.9 + (0.2 * curveValue);
          final cardOpacity = curveValue;
          final cardScale =
              moment.reduceMotion ? 1.0 : 0.96 + (0.08 * curveValue);

          return Stack(
            children: [
              // Micro animation at anchor
              Positioned(
                left: anchorRect.center.dx - 16,
                top: anchorRect.top - 48,
                child: Transform.scale(
                  scale: microScale,
                  child: Opacity(
                    opacity: microOpacity,
                    child: _MicroBurst(color: colors.accent),
                  ),
                ),
              ),
              // Affirmation card
              Positioned(
                left: cardLeft,
                top: cardTop,
                child: Transform.scale(
                  scale: cardScale,
                  child: Opacity(
                    opacity: cardOpacity,
                    child: _AffirmationCard(
                      moment: moment,
                      colors: colors,
                      spacing: spacing,
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

  SectionColors _resolveSectionColors(
    KinlySections? sections,
    DopamineMilestone milestone,
    ThemeData theme,
  ) {
    switch (milestone) {
      case DopamineMilestone.flow:
        return sections?.flow ??
            SectionColors(
              background: theme.colorScheme.surface,
              card: theme.colorScheme.surfaceContainerHigh,
              icon: theme.colorScheme.onSurface,
              accent: theme.colorScheme.primary,
            );
      case DopamineMilestone.share:
        return sections?.share ??
            SectionColors(
              background: theme.colorScheme.surface,
              card: theme.colorScheme.surfaceContainerHigh,
              icon: theme.colorScheme.onSurface,
              accent: theme.colorScheme.primary,
            );
      case DopamineMilestone.pulse:
        return sections?.pulse ??
            SectionColors(
              background: theme.colorScheme.surface,
              card: theme.colorScheme.surfaceContainerHigh,
              icon: theme.colorScheme.onSurface,
              accent: theme.colorScheme.tertiary,
            );
      case DopamineMilestone.reflection:
        return sections?.pulse ??
            SectionColors(
              background: theme.colorScheme.surface,
              card: theme.colorScheme.surfaceContainerHigh,
              icon: theme.colorScheme.onSurface,
              accent: theme.colorScheme.tertiary,
            );
    }
  }
}

class _MicroBurst extends StatelessWidget {
  const _MicroBurst({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withValues(alpha: 0.75), color.withValues(alpha: 0.0)],
          stops: const [0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          size: 18,
          color: color.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _AffirmationCard extends StatelessWidget {
  const _AffirmationCard({
    required this.moment,
    required this.colors,
    required this.spacing,
  });

  final DopamineMoment moment;
  final SectionColors colors;
  final Spacing? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      padding: EdgeInsetsDirectional.fromSTEB(
        spacing?.m ?? 12,
        (spacing?.sm ?? 8) + 2,
        spacing?.m ?? 12,
        spacing?.sm ?? 8,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.accent.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withValues(alpha: 0.16),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing?.xs ?? 6),
          Text(
            moment.affirmation,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.icon,
            ),
          ),
          if (moment.echo != null) ...[
            SizedBox(height: spacing?.xxs ?? 4),
            Text(
              moment.echo!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.icon.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
