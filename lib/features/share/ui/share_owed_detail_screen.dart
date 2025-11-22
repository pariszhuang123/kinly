import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/kinly_sections.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/kinly_circle_avatar.dart';
import '../../../core/ui/kinly_loader.dart';
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
    final s = S.of(context);

    return Row(
      children: [
        KinlyCircleAvatar(avatarUrl: owed.avatarUrl, radius: 28),
        SizedBox(width: spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(owed.displayName, style: theme.textTheme.titleLarge),
              Text(
                s.shareOwedDetailSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          _formatCurrency(owed.totalOwedCents),
          style: theme.textTheme.titleLarge?.copyWith(
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
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// List of all owed items, read-only (no selection)
class _ShareOwedItemsList extends StatelessWidget {
  const _ShareOwedItemsList({required this.items});

  final List<TodayShareOwedItem> items;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<Spacing>()!;

    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final item = items[index];
        return _DetailRow(
          description: item.description,
          amountLabel: _formatCurrency(item.amountCents),
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
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        onPressed: isEnabled ? onPressed : null,
        child:
            isSubmitting
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: KinlyLoader(size: 20),
                )
                : Text(label),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.description, required this.amountLabel});

  final String description;
  final String amountLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(description, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(width: 12),
            Text(
              amountLabel,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
