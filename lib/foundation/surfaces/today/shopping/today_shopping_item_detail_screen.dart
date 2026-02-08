import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/homes/shopping_models.dart';
import 'package:kinly/core/theme/spacing.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';

class TodayShoppingItemDetailScreen extends StatelessWidget {
  const TodayShoppingItemDetailScreen({
    super.key,
    required this.item,
    required this.photoUrl,
    required this.onMarkComplete,
  });

  final ShoppingListItem item;
  final String photoUrl;
  final Future<void> Function() onMarkComplete;

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final resolvedPhotoUrl = photoUrl;
    final hasPhoto = resolvedPhotoUrl.isNotEmpty;
    final hasQuantity = _hasText(item.quantity);
    final hasDetails = _hasText(item.details);
    final heroTag = 'shopping-photo-${resolvedPhotoUrl.hashCode}';

    final detailSections = <Widget>[
      _ReadOnlyField(label: s.shoppingNameLabel, value: item.name),
    ];

    if (hasQuantity) {
      detailSections
        ..add(SizedBox(height: spacing.md))
        ..add(
          _ReadOnlyField(
            label: s.shoppingAmountLabel,
            value: item.quantity!.trim(),
          ),
        );
    }

    if (hasDetails) {
      detailSections
        ..add(SizedBox(height: spacing.md))
        ..add(
          _ReadOnlyField(
            label: s.shoppingContextLabel,
            value: item.details!.trim(),
            maxLines: 6,
          ),
        );
    }

    if (hasPhoto) {
      detailSections
        ..add(SizedBox(height: spacing.md))
        ..add(Text(s.shoppingPhotoLabel, style: theme.textTheme.titleSmall))
        ..add(SizedBox(height: spacing.sm))
        ..add(
          KinlyTapTarget(
            onTap: () {
              context.pushNamed(
                AppRouteNames.todayShoppingPhoto,
                queryParameters: {
                  'photoUrl': resolvedPhotoUrl,
                  'title': s.shoppingDetailTitle,
                  'heroTag': heroTag,
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: heroTag,
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(resolvedPhotoUrl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
    }

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shoppingDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...detailSections,
              const Spacer(),
              if (!item.isCompleted)
                KinlyFilledButton.text(
                  onPressed: () async {
                    await onMarkComplete();
                    if (!context.mounted) return;
                    context.pop();
                  },
                  label: s.shoppingMarkCompleteCta,
                  fullWidth: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.maxLines = 2,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        SizedBox(height: spacing.xs),
        Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.all(spacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(value, maxLines: maxLines, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
