import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/kinly_palette.dart';
import '../theme/control_tokens.dart';
import 'kinly_loader.dart';

class KinlyCircleAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final bool isOwner;
  final String? fallbackInitial;

  const KinlyCircleAvatar({
    super.key,
    this.avatarUrl,
    this.radius = 20,
    this.isOwner = false,
    this.fallbackInitial,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = _normalizeRadius(radius);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controls =
        theme.extension<KinlyControlColors>() ??
        KinlyPalette.controls(theme.brightness, colorScheme);

    final showsSvgAvatar =
        avatarUrl != null && avatarUrl!.trim().toLowerCase().endsWith('.svg');

    final avatar = CircleAvatar(
      radius: resolvedRadius,
      backgroundColor:
          avatarUrl == null ? colorScheme.primaryContainer : Colors.transparent,
      foregroundColor: colorScheme.onPrimaryContainer,
      backgroundImage:
          avatarUrl != null && !showsSvgAvatar
              ? NetworkImage(avatarUrl!)
              : null,
      child: switch ((avatarUrl, showsSvgAvatar)) {
        (null, _) => fallbackInitial != null
            ? Text(
                fallbackInitial!.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              )
            : null,
        (_, true) => ClipOval(
          child: SizedBox.expand(
            child: SvgPicture.network(
              avatarUrl!,
              fit: BoxFit.cover,
              placeholderBuilder:
                  (_) => Center(
                    child: KinlyLoader(
                      size: resolvedRadius,
                      color: colorScheme.primary,
                    ),
                  ),
            ),
          ),
        ),
        _ => null,
      },
    );

    final badgeSize = resolvedRadius * 0.95;
    final badgeBackground = controls.avatarBadgeBg;
    final iconColor = controls.avatarBadgeFg;
    final badge = Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(color: badgeBackground, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: SvgPicture.asset(
          'assets/icons/logo/Home.svg',
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );

    return SizedBox(
      width: resolvedRadius * 2,
      height: resolvedRadius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: avatar),
          if (isOwner) PositionedDirectional(end: -2, bottom: -2, child: badge),
        ],
      ),
    );
  }

  double _normalizeRadius(double value) {
    // Enforce design token sizes (diameters 24, 40, 56 => radii 12, 20, 28)
    const allowed = [12.0, 20.0, 28.0];
    return allowed.reduce(
      (closest, current) =>
          (current - value).abs() < (closest - value).abs()
              ? current
              : closest,
    );
  }
}
