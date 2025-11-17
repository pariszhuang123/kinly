import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = S.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: colorScheme.onSurface.withValues(alpha: 1.0),
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      backgroundColor: colorScheme.surfaceContainerHigh,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today_rounded),
          label: t.navToday,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore_rounded),
          label: t.navExplore,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_rounded),
          label: t.navHub,
        ),
      ],
    );
  }
}
