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
  late String? _selectedExpenseId;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedExpenseId =
        widget.owed.items.isNotEmpty ? widget.owed.items.first.expenseId : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.shareOwedDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KinlyCircleAvatar(
                    avatarUrl: widget.owed.avatarUrl,
                    radius: 28,
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.owed.displayName,
                          style: theme.textTheme.titleLarge,
                        ),
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
                    _formatCurrency(widget.owed.totalOwedCents),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.lg),
              if (widget.owed.items.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      s.shareOwedDetailEmpty,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.owed.items.length,
                    separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                    itemBuilder: (context, index) {
                      final item = widget.owed.items[index];
                      final selected = item.expenseId == _selectedExpenseId;
                      return _DetailRow(
                        description: item.description,
                        amountLabel: _formatCurrency(item.amountCents),
                        selected: selected,
                        onTap:
                            () => setState(() {
                              _selectedExpenseId = item.expenseId;
                              _errorMessage = null;
                            }),
                      );
                    },
                  ),
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sections.share.accent,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed:
                      _isSubmitting || _selectedExpenseId == null
                          ? null
                          : _markPaid,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: KinlyLoader(size: 20),
                          )
                          : Text(s.shareOwedDetailPaid),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markPaid() async {
    final strings = S.of(context);
    final expenseId = _selectedExpenseId;
    if (expenseId == null) {
      setState(() {
        _errorMessage = strings.shareOwedDetailSelectionLabel;
      });
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await widget.expensesRepository.markSharePaid(expenseId);
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.description,
    required this.amountLabel,
    required this.selected,
    required this.onTap,
  });

  final String description;
  final String amountLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color:
                    selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}

String _formatCurrency(int amountCents) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(amountCents / 100.0);
}
