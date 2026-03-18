import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route_names.dart';
import '../../../../contracts/personal_directory/models.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_outlined_button.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/ui/kinly_circle_avatar.dart';
import '../../../../core/ui/kinly_icons.dart';
import '../../../../core/ui/kinly_list_tile.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../../generated/l10n.dart';
import '../../../../contracts/share/models.dart';
import '../share_detail_route_args.dart';
import '../share_period_label.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class ShareOwedDetailBody extends StatelessWidget {
  const ShareOwedDetailBody({
    super.key,
    required this.owed,
    required this.spacing,
    required this.strings,
    required this.hasItems,
    required this.isSubmitting,
    required this.errorMessage,
    required this.paymentBankAccount,
    required this.isLoadingPaymentBankAccount,
    required this.onMarkAllPaid,
  });

  final TodayShareOwed owed;
  final Spacing spacing;
  final S strings;
  final bool hasItems;
  final bool isSubmitting;
  final String? errorMessage;
  final PersonalDirectoryBankAccount? paymentBankAccount;
  final bool isLoadingPaymentBankAccount;
  final Future<void> Function() onMarkAllPaid;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShareOwedHeader(owed: owed),
        SizedBox(height: spacing.lg),
        if (!isLoadingPaymentBankAccount) ...[
          _SharePaymentCard(
            owed: owed,
            bankAccount: paymentBankAccount,
            strings: strings,
          ),
          SizedBox(height: spacing.lg),
        ],
        Expanded(
          child:
              hasItems
                  ? KinlyScrollFade(
                    child: _ShareOwedItemsList(items: owed.items),
                  )
                  : _ShareOwedEmptyState(message: strings.shareOwedDetailEmpty),
        ),
        if (errorMessage != null) ...[
          SizedBox(height: spacing.sm),
          Text(
            errorMessage!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        SizedBox(height: spacing.lg),
        _ShareOwedMarkPaidButton(
          isSubmitting: isSubmitting,
          isEnabled: !isSubmitting && hasItems,
          label: strings.shareOwedDetailPaid,
          onPressed: (!isSubmitting && hasItems) ? onMarkAllPaid : null,
        ),
      ],
    );
  }
}

class _ShareOwedHeader extends StatelessWidget {
  const _ShareOwedHeader({required this.owed});

  final TodayShareOwed owed;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return Row(
      children: [
        KinlyCircleAvatar(
          avatarUrl: owed.avatarUrl,
          radius: 28,
          isOwner: owed.isOwner,
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(owed.displayName, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        Text(
          _formatCurrency(owed.totalOwedCents),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ShareOwedEmptyState extends StatelessWidget {
  const _ShareOwedEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);

    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ShareOwedItemsList extends StatelessWidget {
  const _ShareOwedItemsList({required this.items});

  final List<TodayShareOwedItem> items;
  bool _hasText(String? value) => (value ?? '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final spacing = KinlyThemeAccess.of(context).extension<Spacing>()!;

    return ListView.separated(
      padding: EdgeInsetsDirectional.only(top: spacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        final hasNotes = _hasText(item.notes);
        final hasPhoto = _hasText(item.evidencePhotoPath);
        final canOpen = hasNotes || hasPhoto;
        final periodLabel = sharePeriodLabel(
          recurrenceEvery: item.recurrenceEvery,
          recurrenceUnit: item.recurrenceUnit,
          startDate: item.startDate,
          strings: strings,
        );
        return _DetailRow(
          description: item.description,
          periodLabel: periodLabel,
          amountLabel: _formatCurrency(item.amountCents),
          hasNotes: hasNotes,
          hasPhoto: hasPhoto,
          onTap:
              canOpen
                  ? () => context.pushNamed(
                    AppRouteNames.shareOwedItemDetail,
                    extra: ShareOwedItemDetailRouteArgs(item: item),
                  )
                  : null,
        );
      },
    );
  }
}

class _SharePaymentCard extends StatelessWidget {
  const _SharePaymentCard({
    required this.owed,
    required this.bankAccount,
    required this.strings,
  });

  final TodayShareOwed owed;
  final PersonalDirectoryBankAccount? bankAccount;
  final S strings;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final reference = _paymentReference(strings);
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child:
          bankAccount == null
              ? Text(strings.shareOwedBankMissing(reference))
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.shareOwedPaymentDetailsTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: spacing.md),
                  _CopyRow(
                    label: strings.shareOwedAccountHolderLabel,
                    value: bankAccount!.accountHolderName,
                    ctaLabel: strings.shareOwedCopyCta,
                  ),
                  SizedBox(height: spacing.sm),
                  _CopyRow(
                    label: strings.shareOwedAccountNumberLabel,
                    value: bankAccount!.accountNumber,
                    ctaLabel: strings.shareOwedCopyCta,
                  ),
                  SizedBox(height: spacing.sm),
                  _CopyRow(
                    label: strings.shareOwedReferenceLabel,
                    value: reference,
                    ctaLabel: strings.shareOwedCopyCta,
                  ),
                ],
              ),
    );
  }

  String _paymentReference(S strings) {
    final username = (owed.username ?? '').trim();
    if (username.isNotEmpty) return username;
    final displayName = owed.displayName.trim();
    if (displayName.isNotEmpty) return displayName;
    return strings.personalDirectoryFallbackName;
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({
    required this.label,
    required this.value,
    required this.ctaLabel,
  });

  final String label;
  final String value;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(width: 8),
        KinlyOutlinedButton.text(
          onPressed: () => _copy(value),
          label: ctaLabel,
          compact: true,
          fullWidth: false,
        ),
      ],
    );
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
  }
}

class _ShareOwedMarkPaidButton extends StatelessWidget {
  const _ShareOwedMarkPaidButton({
    required this.isSubmitting,
    required this.isEnabled,
    required this.label,
    required this.onPressed,
  });

  final bool isSubmitting;
  final bool isEnabled;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          KinlyFilledButton.text(
            fullWidth: true,
            onPressed: isEnabled ? onPressed : null,
            label: label,
          ),
          if (isSubmitting)
            const SizedBox(height: 20, width: 20, child: KinlyLoader(size: 20)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.description,
    required this.periodLabel,
    required this.amountLabel,
    required this.hasPhoto,
    required this.hasNotes,
    required this.onTap,
  });

  final String description;
  final String periodLabel;
  final String amountLabel;
  final bool hasPhoto;
  final bool hasNotes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final canOpen = onTap != null;

    return KinlyListTile(
      title: description,
      subtitle: periodLabel,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amountLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (hasNotes) ...[
            SizedBox(width: spacing.xs),
            const Icon(KinlyIcons.notesOutlined, size: 18),
          ],
          if (hasPhoto) ...[
            SizedBox(width: spacing.xs),
            const Icon(KinlyIcons.photoCameraOutlined, size: 18),
          ],
          if (canOpen) ...[
            SizedBox(width: spacing.xs),
            const Icon(KinlyIcons.chevronRight, size: 18),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
