import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/contracts/personal_directory/ports/personal_directory_repository.dart';
import 'package:kinly/contracts/personal_directory/route_args.dart';
import 'package:kinly/core/di/locator.dart';
import 'package:kinly/core/logging/logger.dart';
import 'package:kinly/core/ui/buttons/kinly_filled_button.dart';
import 'package:kinly/core/ui/inputs/kinly_text_field.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/generated/l10n.dart';

class PersonalDirectoryBankScreen extends StatefulWidget {
  const PersonalDirectoryBankScreen({
    super.key,
    required this.repository,
    required this.canEdit,
    this.initial,
  });

  final PersonalDirectoryRepository repository;
  final PersonalDirectoryBankAccount? initial;
  final bool canEdit;

  @override
  State<PersonalDirectoryBankScreen> createState() =>
      _PersonalDirectoryBankScreenState();
}

class _PersonalDirectoryBankScreenState
    extends State<PersonalDirectoryBankScreen> {
  late final TextEditingController _accountHolderController;
  late final TextEditingController _accountNumberController;
  bool _isSaving = false;
  String? _accountHolderError;
  String? _accountNumberError;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _accountHolderController = TextEditingController(
      text: widget.initial?.accountHolderName ?? '',
    );
    _accountNumberController = TextEditingController(
      text: widget.initial?.accountNumber ?? '',
    );
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return KinlyScaffold(
      appBar: KinlyAppBar(
        title: Text(
          widget.canEdit
              ? (_isEditing
                  ? s.personalDirectoryEditBank
                  : s.personalDirectoryAddBank)
              : s.personalDirectoryBankTitle,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
          children: [
            KinlyTextField(
              controller: _accountHolderController,
              enabled: widget.canEdit && !_isSaving,
              labelText: s.personalDirectoryAccountHolderLabel,
              errorText: _accountHolderError,
            ),
            const SizedBox(height: 16),
            KinlyTextField(
              controller: _accountNumberController,
              enabled: widget.canEdit && !_isSaving,
              labelText: s.personalDirectoryAccountNumberLabel,
              errorText: _accountNumberError,
            ),
            if (widget.canEdit) ...[
              const SizedBox(height: 24),
              KinlyFilledButton.text(
                fullWidth: true,
                onPressed: _isSaving ? null : _save,
                label: _isEditing ? s.shoppingSubmitEdit : s.personalDirectorySave,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final s = S.of(context);
    final holder = _accountHolderController.text.trim();
    final number = _accountNumberController.text.trim();
    final isHolderValid = holder.isNotEmpty && holder.length <= 120;
    final isNumberValid = number.isNotEmpty && number.length <= 50;
    setState(() {
      _accountHolderError =
          isHolderValid ? null : s.personalDirectoryBankValidation;
      _accountNumberError =
          isNumberValid ? null : s.personalDirectoryBankValidation;
    });
    if (!isHolderValid || !isNumberValid) return;

    setState(() => _isSaving = true);
    try {
      await widget.repository.upsertOwnBankAccount(
        UpsertPersonalDirectoryBankAccountInput(
          accountHolderName: holder,
          accountNumber: number,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      KinlySnackBar.showError(context, s.personalDirectoryActionFailed);
      return;
    }
    if (!mounted) return;
    _closeWithResult(PersonalDirectoryRouteResult.bankSaved);
  }

  void _closeWithResult(PersonalDirectoryRouteResult result) {
    unawaited(_closeAfterFrame(result));
  }

  Future<void> _closeAfterFrame(PersonalDirectoryRouteResult result) async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    try {
      Navigator.of(context).pop(result);
    } catch (error, stackTrace) {
      sl<Logger>().error(
        'Personal directory bank route pop failed after a successful save.',
        tag: 'Router',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) return;
      GoRouter.of(context).goNamed(AppRouteNames.personalDirectory);
    }
  }
}
