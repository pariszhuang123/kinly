import 'package:flutter/widgets.dart';

import 'package:kinly/core/ui/kinly_list_tile.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

class TodayShoppingListCard extends StatelessWidget {
  const TodayShoppingListCard({
    super.key,
    required this.onTap,
    required this.count,
  });

  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (count <= 0) {
      return const SizedBox.shrink();
    }

    return KinlyListTile(
      leading: const Icon(KinlyIcons.shoppingBasketOutlined),
      title: s.shoppingCardTitle,
      subtitle: s.shoppingCardSubtitle(count),
      trailing: const Icon(KinlyIcons.chevronRight),
      onTap: onTap,
    );
  }
}
