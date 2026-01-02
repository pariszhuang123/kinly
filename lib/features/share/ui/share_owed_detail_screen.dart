import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../share/share.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/share/models.dart';

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
    ShareOwedDetailRegistry.bootstrap();
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final hasItems = widget.owed.items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(s.shareOwedDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: _buildOwedBody(context, spacing, s, hasItems),
        ),
      ),
    );
  }

  /// Bulk pay all owed items for this recipient via expenses_pay_my_due.
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
      await widget.expensesRepository.payMyDue(
        recipientUserId: widget.owed.payerUserId,
      );

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

  Widget _buildOwedBody(
    BuildContext context,
    Spacing spacing,
    S strings,
    bool hasItems,
  ) {
    final actions = ShareOwedDetailSurfaceActions(onMarkAllPaid: _markAllPaid);
    final scope = ShareOwedDetailSurfaceScope(
      context: context,
      owed: widget.owed,
      spacing: spacing,
      strings: strings,
      hasItems: hasItems,
      isSubmitting: _isSubmitting,
      errorMessage: _errorMessage,
      actions: actions,
    );
    final slots = ShareOwedDetailSurfaceSlots(body: _buildOwedSections(scope));
    return slots.body;
  }

  Widget _buildOwedSections(ShareOwedDetailSurfaceScope scope) {
    final entries = ShareOwedDetailRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}
