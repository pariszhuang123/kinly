import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/router/app_route_names.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../../core/ui/inputs/kinly_text_field.dart';
import '../../../../../core/ui/kinly_loader.dart';
import '../../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/auth/bloc/auth_bloc.dart';
import '../../bloc/join_home_bloc.dart';
import '../../../../../core/ui/kinly_theme_access.dart';

class JoinHomeForm extends StatefulWidget {
  const JoinHomeForm({super.key, required this.initialCode});

  final String initialCode;

  @override
  State<JoinHomeForm> createState() => _JoinHomeFormState();
}

class _JoinHomeFormState extends State<JoinHomeForm> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<JoinHomeBloc, JoinHomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _handleStatusChange,
      child: Padding(
        padding: EdgeInsetsDirectional.all(
          KinlyThemeAccess.of(context).extension<Spacing>()!.lg,
        ),
        child: BlocBuilder<JoinHomeBloc, JoinHomeState>(
          builder: (context, state) {
            final isSubmitting = state.status == JoinHomeStatus.submitting;
            final spacing = KinlyThemeAccess.of(context).extension<Spacing>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KinlyTextField(
                  controller: _controller,
                  labelText: s.join_hint,
                  inputFormatters: [_UpperCaseTextFormatter()],
                  onChanged:
                      (value) => context.read<JoinHomeBloc>().add(
                        JoinHomeCodeChanged(value),
                      ),
                ),
                SizedBox(height: spacing?.lg ?? 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    KinlyFilledButton.text(
                      fullWidth: true,
                      onPressed:
                          !isSubmitting && state.canSubmit
                              ? () => context.read<JoinHomeBloc>().add(
                                const JoinHomeSubmitted(),
                              )
                              : null,
                      label: s.join_submit,
                    ),
                    if (isSubmitting)
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: KinlyLoader(size: 16),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleStatusChange(BuildContext context, JoinHomeState state) {
    final s = S.of(context);
    switch (state.status) {
      case JoinHomeStatus.success:
        KinlySnackBar.showSuccess(context, s.join_success(state.code));
        context.read<AuthBloc>().add(const AuthMembershipRefreshRequested());
        if (!mounted) return;
        context.goNamed(AppRouteNames.today);
        break;
      case JoinHomeStatus.blocked:
        if (!mounted) return;
        context.goNamed(AppRouteNames.joinBlocked);
        break;
      case JoinHomeStatus.failure:
        final errorText = _resolveErrorText(context, state);
        KinlySnackBar.showError(context, errorText);
        break;
      case JoinHomeStatus.initial:
      case JoinHomeStatus.editing:
      case JoinHomeStatus.submitting:
        break;
    }
  }

  String _resolveErrorText(BuildContext context, JoinHomeState state) {
    final s = S.of(context);
    switch (state.errorType) {
      case JoinHomeErrorType.invalidCode:
        return s.join_error_invalid_code;
      case JoinHomeErrorType.inactiveInvite:
        return s.join_error_inactive_invite;
      case JoinHomeErrorType.alreadyInOtherHome:
        return s.join_error_already_in_other_home;
      case JoinHomeErrorType.paywallLimit:
        return s.join_error_paywall_limit;
      case JoinHomeErrorType.profileDeactivated:
        return s.create_failed_generic;
      case JoinHomeErrorType.unauthorized:
        return s.join_error_unauthorized;
      case JoinHomeErrorType.forbidden:
        return s.join_error_forbidden;
      case JoinHomeErrorType.unknown:
      case null:
        return state.errorMessage ?? s.join_failed_generic;
    }
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
