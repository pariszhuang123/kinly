import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_route_names.dart';
import '../../../contracts/share/models.dart';
import '../../../core/supabase/storage_path_resolver.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_tap_target.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../generated/l10n.dart';
import 'share_detail_route_args.dart';
import 'share_period_label.dart';

class ShareOwedItemDetailScreen extends StatelessWidget {
  const ShareOwedItemDetailScreen({
    super.key,
    required this.item,
  });

  final TodayShareOwedItem item;

  static bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  String _resolvePhotoUrl(String? path) {
    final trimmed = path?.trim() ?? '';
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    try {
      return StoragePathResolver().toPublicUrl(trimmed) ?? '';
    } catch (_) {
      return '';
    }
  }

  String _formatCurrency(int amountCents) {
    final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
    return formatter.format(amountCents / 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    final period = sharePeriodLabel(
      recurrenceEvery: item.recurrenceEvery,
      recurrenceUnit: item.recurrenceUnit,
      startDate: item.startDate,
      strings: s,
    );
    final hasComments = _hasText(item.notes);
    final photoUrl = _resolvePhotoUrl(item.evidencePhotoPath);
    final hasPhoto = photoUrl.isNotEmpty;
    final heroTag = 'share-owed-photo-${item.expenseId}-${photoUrl.hashCode}';

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shareOwedDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: ListView(
            children: [
              _ReadOnlyField(
                label: s.shoppingNameLabel,
                value: item.description,
              ),
              SizedBox(height: spacing.md),
              _ReadOnlyField(
                label: s.shareCreateRecurrenceLabel,
                value: period,
              ),
              SizedBox(height: spacing.md),
              _ReadOnlyField(
                label: s.shareCreateAmountLabel,
                value: _formatCurrency(item.amountCents),
              ),
              if (hasComments) ...[
                SizedBox(height: spacing.md),
                _ReadOnlyField(
                  label: s.shareCreateNotesLabel,
                  value: item.notes!.trim(),
                  maxLines: 10,
                ),
              ],
              if (hasPhoto) ...[
                SizedBox(height: spacing.md),
                Text(s.shoppingPhotoLabel, style: theme.textTheme.titleSmall),
                SizedBox(height: spacing.sm),
                KinlyTapTarget(
                  onTap:
                      () => context.pushNamed(
                        AppRouteNames.sharePhoto,
                        extra: SharePhotoRouteArgs(
                          photoUrl: photoUrl,
                          title: s.shareOwedDetailTitle,
                          heroTag: heroTag,
                        ),
                      ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: heroTag,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
