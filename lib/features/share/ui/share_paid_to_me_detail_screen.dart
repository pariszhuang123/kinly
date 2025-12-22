import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
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
  String? _error;
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
    });
    try {
      await widget.expensesRepository.markPaidReceivedViewedForDebtor(
        homeId: widget.homeId,
        debtorUserId: widget.entry.debtorUserId,
      );
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

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>()!;

    return Scaffold(
      appBar: AppBar(title: Text(s.todayShareTabPaidToMe)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(entry: widget.entry),
              SizedBox(height: spacing.lg),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: KinlyLoader())
                        : _error != null
                        ? Center(
                          child: Text(
                            _error!,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        : _items.isEmpty
                        ? Center(child: Text(s.shareOwedDetailEmpty))
                        : KinlyScrollFade(
                          child: ListView.separated(
                            itemCount: _items.length,
                            padding: EdgeInsetsDirectional.only(
                              top: spacing.sm,
                              bottom: spacing.sm,
                            ),
                            separatorBuilder:
                                (_, __) => SizedBox(height: spacing.sm),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return ListTile(
                                title: Text(item.description),
                                trailing: Text(item.formattedAmount),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
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
