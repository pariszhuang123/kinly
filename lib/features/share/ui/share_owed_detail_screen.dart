import 'package:flutter/widgets.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/supabase/supabase_error_mapper.dart';
import '../../share/share.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/share/models.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_theme_access.dart';

class ShareOwedDetailScreen extends StatefulWidget {
  const ShareOwedDetailScreen({
    super.key,
    required this.owed,
    this.currentUsername,
    required this.expensesRepository,
    required this.personalDirectoryRepository,
  });

  final TodayShareOwed owed;
  final String? currentUsername;
  final ExpensesRepository expensesRepository;
  final PersonalDirectoryRepository personalDirectoryRepository;

  @override
  State<ShareOwedDetailScreen> createState() => _ShareOwedDetailScreenState();
}

class _ShareOwedDetailScreenState extends State<ShareOwedDetailScreen> {
  bool _isSubmitting = false;
  String? _errorMessage;
  PersonalDirectoryBankAccount? _bankAccount;
  bool _isLoadingBank = true;

  @override
  void initState() {
    super.initState();
    _loadBankAccount();
  }

  @override
  Widget build(BuildContext context) {
    ShareOwedDetailRegistry.bootstrap();
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    final hasItems = widget.owed.items.isNotEmpty;

    return KinlyScaffold(
      appBar: KinlyAppBar(title: Text(s.shareOwedDetailTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: _buildOwedBody(
            context,
            spacing,
            s,
            hasItems,
            _bankAccount,
            _isLoadingBank,
          ),
        ),
      ),
    );
  }

  Future<void> _loadBankAccount() async {
    try {
      final bankAccount = await widget.personalDirectoryRepository
          .getMemberBankAccount(targetUserId: widget.owed.payerUserId);
      if (!mounted) return;
      setState(() {
        _bankAccount = bankAccount;
        _isLoadingBank = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingBank = false);
    }
  }

  /// Bulk pay all owed items for this recipient, using unit payments when needed.
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
      var processed = false;
      final unitItems = widget.owed.items.where(
        (item) => (item.unitId ?? '').trim().isNotEmpty,
      );
      for (final item in unitItems) {
        final unitId = item.unitId?.trim() ?? '';
        final amountCents = item.remainingCents ?? item.amountCents;
        if (unitId.isEmpty || amountCents <= 0) {
          continue;
        }
        processed = true;
        await widget.expensesRepository.payUnitDue(
          expenseId: item.expenseId,
          unitId: unitId,
          amountCents: amountCents,
        );
      }

      final hasPersonScopedItems = widget.owed.items.any(
        (item) => (item.unitId ?? '').trim().isEmpty,
      );
      if (hasPersonScopedItems) {
        processed = true;
        await widget.expensesRepository.payMyDue(
          recipientUserId: widget.owed.payerUserId,
        );
      }

      if (!processed) {
        throw const ExpenseException(
          ExpenseErrorCode.unknown,
          'No payable items were found.',
        );
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

  Widget _buildOwedBody(
    BuildContext context,
    Spacing spacing,
    S strings,
    bool hasItems,
    PersonalDirectoryBankAccount? bankAccount,
    bool isLoadingBank,
  ) {
    final actions = ShareOwedDetailSurfaceActions(onMarkAllPaid: _markAllPaid);
    final scope = ShareOwedDetailSurfaceScope(
      context: context,
      owed: widget.owed,
      currentUsername: widget.currentUsername,
      spacing: spacing,
      strings: strings,
      hasItems: hasItems,
      isSubmitting: _isSubmitting,
      errorMessage: _errorMessage,
      paymentBankAccount: bankAccount,
      isLoadingPaymentBankAccount: isLoadingBank,
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
