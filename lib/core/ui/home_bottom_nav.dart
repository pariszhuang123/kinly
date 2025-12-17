import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../theme/kinly_palette.dart';
import '../theme/color_tokens.dart';

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
    final colors =
        theme.extension<KinlyColorTokens>() ??
        KinlyPalette.build(theme.brightness).colorTokens;
    final t = S.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: colors.onSurface.withValues(alpha: 1.0),
      unselectedItemColor: colors.onSurface.withValues(alpha: 0.6),
      backgroundColor: colors.surfaceVariant,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_today_rounded),
          label: t.navToday,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.explore_rounded),
          label: t.navExplore,
        ),
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.navHub),
      ],
    );
  }
}
