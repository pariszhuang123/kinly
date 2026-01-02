import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../share/share.dart';
import '../../../generated/l10n.dart';
import '../../../contracts/share/models.dart';
import 'share_paid_to_me_detail_models.dart';

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
    SharePaidToMeDetailRegistry.bootstrap();
    final s = S.of(context);
    final spacing = Theme.of(context).extension<Spacing>()!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(title: Text(s.todayShareTabPaidToMe)),
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
      body: SafeArea(child: _buildPaidToMeBody(context, spacing, s)),
    );
  }

  Widget _buildPaidToMeBody(BuildContext context, Spacing spacing, S strings) {
    final scope = SharePaidToMeDetailSurfaceScope(
      context: context,
      entry: widget.entry,
      items: _items,
      spacing: spacing,
      strings: strings,
      isLoading: _isLoading,
      error: _error,
    );
    final slots = SharePaidToMeDetailSurfaceSlots(
      body: _buildPaidToMeSections(scope),
    );
    return slots.body;
  }

  Widget _buildPaidToMeSections(SharePaidToMeDetailSurfaceScope scope) {
    final entries = SharePaidToMeDetailRegistry.bodySections;
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
