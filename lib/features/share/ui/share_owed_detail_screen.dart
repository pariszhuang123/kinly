import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../../data/repositories/expenses_repository.dart';
import '../../../generated/l10n.dart';
import '../../today/domain/models.dart';

class ShareOwedDetailScreen extends StatefulWidget {
  const ShareOwedDetailScreen({
    super.key,
    required this.owed,
    required this.expensesRepository,
  });

  final TodayShareOwed owed;
  final ExpensesRepository expensesRepository;

  @override
  State<ShareOwedDetailScreen> createState() => _ShareOwedDetailScreenState();
}

class _ShareOwedDetailScreenState extends State<ShareOwedDetailScreen> {
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    final hasItems = widget.owed.items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(s.shareOwedDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShareOwedHeader(owed: widget.owed),
              SizedBox(height: spacing.lg),
              Expanded(
                child:
                    hasItems
                        ? _ShareOwedItemsList(items: widget.owed.items)
                        : _ShareOwedEmptyState(message: s.shareOwedDetailEmpty),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: spacing.sm),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              SizedBox(height: spacing.lg),
              _ShareOwedMarkPaidButton(
                isSubmitting: _isSubmitting,
                isEnabled: !_isSubmitting && hasItems,
                // You can later change this string to something like "Pay all"
                label: s.shareOwedDetailPaid,
                accentColor: sections.share.accent,
                onPressed: (!_isSubmitting && hasItems) ? _markAllPaid : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Option A: loop over all owed items and call markSharePaid(expenseId)
  Future<void> _markAllPaid() async {
    final strings = S.of(context);

    if (widget.owed.items.isEmpty) {
      setState(() {
        _errorMessage = strings.shareOwedDetailEmpty;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      for (final item in widget.owed.items) {
        await widget.expensesRepository.markSharePaid(item.expenseId);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ExpenseException catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = strings.shareOwedDetailError;
      });
    }
  }
}

/// Header section: avatar, name, subtitle, total owed
class _ShareOwedHeader extends StatelessWidget {
  const _ShareOwedHeader({required this.owed});

  final TodayShareOwed owed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

/// Empty state when there are no owed items
class _ShareOwedEmptyState extends StatelessWidget {
  const _ShareOwedEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        message,
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// List of all owed items, read-only (no selection)
class _ShareOwedItemsList extends StatefulWidget {
  const _ShareOwedItemsList({required this.items});

  final List<TodayShareOwedItem> items;

  @override
  State<_ShareOwedItemsList> createState() => _ShareOwedItemsListState();
}

class _ShareOwedItemsListState extends State<_ShareOwedItemsList> {
  final Set<String> _expanded = <String>{};

  bool _hasNotes(TodayShareOwedItem item) =>
      (item.notes?.trim().isNotEmpty ?? false);

  void _toggle(String expenseId) {
    setState(() {
      if (_expanded.contains(expenseId)) {
        _expanded.remove(expenseId);
      } else {
        _expanded.add(expenseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;

    return ListView.separated(
      itemCount: widget.items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final hasNotes = _hasNotes(item);
        final isExpanded = _expanded.contains(item.expenseId);
        return _DetailRow(
          description: item.description,
          amountLabel: _formatCurrency(item.amountCents),
          notes: item.notes,
          hasNotes: hasNotes,
          isExpanded: isExpanded,
          onToggle: hasNotes ? () => _toggle(item.expenseId) : null,
        );
      },
    );
  }
}

/// Footer button + loading state for marking all as paid
class _ShareOwedMarkPaidButton extends StatelessWidget {
  const _ShareOwedMarkPaidButton({
    required this.isSubmitting,
    required this.isEnabled,
    required this.label,
    required this.accentColor,
    required this.onPressed,
  });

  final bool isSubmitting;
  final bool isEnabled;
  final String label;
  final Color accentColor;
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
    required this.amountLabel,
    required this.hasNotes,
    required this.isExpanded,
    this.notes,
    this.onToggle,
  });

  final String description;
  final String amountLabel;
  final String? notes;
  final bool hasNotes;
  final bool isExpanded;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteText = notes?.trim();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasNotes)
              Icon(
                isExpanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              )
            else
              const SizedBox(width: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(description, style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(width: 12),
            Text(
              amountLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (hasNotes)
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            child:
                isExpanded
                    ? Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 32,
                        top: 8,
                        end: 12,
                      ),
                      child: Text(
                        noteText ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
      ],
    );

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: content,
        ),
      ),
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
