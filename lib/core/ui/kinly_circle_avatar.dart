import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final showsSvgAvatar =
        avatarUrl != null && avatarUrl!.trim().toLowerCase().endsWith('.svg');

    final avatar = CircleAvatar(
      radius: radius,
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
                      size: radius,
                      color: colorScheme.primary,
                    ),
                  ),
            ),
          ),
        ),
        _ => null,
      },
    );

    final badgeSize = radius * 0.95;
    final isDark = theme.brightness == Brightness.dark;
    final badgeBackground = isDark ? Colors.white : Colors.black;
    final iconColor = isDark ? colorScheme.primary : colorScheme.onPrimary;
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
      width: radius * 2,
      height: radius * 2,
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
}
