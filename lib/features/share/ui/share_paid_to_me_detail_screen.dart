import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/color_tokens.dart';
import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography_tokens.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/kinly_list_tile.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/scroll/kinly_scroll_fade.dart';
import '../../../data/repositories/expenses_repository.dart';
import '../../../generated/l10n.dart';
import '../../today/domain/models.dart';

class SharePaidToMeDetailScreen extends StatefulWidget {
  const SharePaidToMeDetailScreen({
    super.key,
    required this.entry,
    required this.homeId,
    required this.expensesRepository,
  });

  final TodaySharePaidToMe entry;
  final String homeId;
  final ExpensesRepository expensesRepository;

  @override
  State<SharePaidToMeDetailScreen> createState() =>
      _SharePaidToMeDetailScreenState();
}

class _SharePaidToMeDetailScreenState extends State<SharePaidToMeDetailScreen> {
  bool _isLoading = true;
  bool _isAcknowledging = false;
  String? _error;
  String? _acknowledgeError;
  List<TodaySharePaidItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _acknowledgeError = null;
    });
    try {
      final items = await widget.expensesRepository.listPaidToMeByDebtor(
        homeId: widget.homeId,
        debtorUserId: widget.entry.debtorUserId,
      );
      if (!mounted) return;
      setState(() {
        _items = items
            .map(TodaySharePaidItem.fromModel)
            .toList(growable: false);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _acknowledgePayments() async {
    final strings = S.of(context);
    setState(() {
      _isAcknowledging = true;
      _acknowledgeError = null;
    });

    try {
      await widget.expensesRepository.markPaidReceivedViewedForDebtor(
        homeId: widget.homeId,
        debtorUserId: widget.entry.debtorUserId,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isAcknowledging = false;
        _acknowledgeError = strings.sharePaidDetailAcknowledgeError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>()!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    // Ensure last tile can scroll above the bottomNavigationBar.
    final bottomScrollPad = spacing.lg + spacing.xl + spacing.lg;

    return Scaffold(
      appBar: AppBar(title: Text(s.todayShareTabPaidToMe)),

      // ✅ Bottom controls are NOT part of the scroll.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: backgroundColor,
          padding: EdgeInsetsDirectional.fromSTEB(
            spacing.lg,
            spacing.sm,
            spacing.lg,
            spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_acknowledgeError != null) ...[
                Text(
                  _acknowledgeError!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                SizedBox(height: spacing.sm),
              ],
              KinlyFilledButton.text(
                onPressed:
                    _isLoading ||
                            _isAcknowledging ||
                            _items.isEmpty ||
                            _error != null
                        ? null
                        : _acknowledgePayments,
                label:
                    _isAcknowledging
                        ? s.sharePaidDetailAcknowledging
                        : s.sharePaidDetailAcknowledge,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: backgroundColor,
              child: _Header(entry: widget.entry),
            ),

            SizedBox(height: spacing.lg),

            // ✅ Only this area scrolls.
            Expanded(
              child: ClipRect(
                child: KinlyScrollFade(
                  fadeTop: true,
                  maskColor: backgroundColor,
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      if (_isLoading)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: KinlyLoader()),
                        )
                      else if (_error != null)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              _error!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else if (_items.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text(s.shareOwedDetailEmpty)),
                        )
                      else
                        SliverList.separated(
                          itemCount: _items.length,
                          separatorBuilder:
                              (_, __) => SizedBox(height: spacing.sm),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            final typography =
                                Theme.of(context).extension<KinlyTypography>();
                            final colors =
                                Theme.of(context).extension<KinlyColorTokens>();

                            return KinlyListTile(
                              title: item.description,
                              trailing: Text(
                                item.formattedAmount,
                                style: (typography?.titleSmall ??
                                        Theme.of(context).textTheme.titleSmall)
                                    ?.copyWith(color: colors?.onSurface),
                              ),
                            );
                          },
                        ),

                      // ✅ Spacer so the last item never sits under the bottom bar.
                      SliverToBoxAdapter(
                        child: SizedBox(height: bottomScrollPad),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.entry});

  final TodaySharePaidToMe entry;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;
    final colors = Theme.of(context).extension<KinlySections>()?.share;

    return Row(
      children: [
        KinlyCircleAvatar(
          avatarUrl: entry.debtorAvatarUrl,
          isOwner: entry.isOwner,
          radius: 28,
        ),
        SizedBox(width: spacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.debtorUsername,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: colors?.icon),
            ),
            Text(
              entry.hasUnseen
                  ? S.of(context).todaySharePaidUnseen(entry.unseenCount)
                  : S.of(context).todaySharePaidSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const Spacer(),
        Text(
          entry.totalPaidFormatted,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors?.icon,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class TodaySharePaidItem {
  TodaySharePaidItem({
    required this.expenseId,
    required this.description,
    required this.amountCents,
    required this.markedPaidAt,
    this.notes,
  });

  final String expenseId;
  final String description;
  final int amountCents;
  final DateTime? markedPaidAt;
  final String? notes;

  factory TodaySharePaidItem.fromModel(ExpensePaidToMeItem model) {
    return TodaySharePaidItem(
      expenseId: model.expenseId,
      description: model.description,
      amountCents: model.amountCents,
      markedPaidAt: model.markedPaidAt,
      notes: model.notes,
    );
  }

  String get formattedAmount {
    return NumberFormat.simpleCurrency(
      decimalDigits: 2,
    ).format(amountCents / 100.0);
  }
}
