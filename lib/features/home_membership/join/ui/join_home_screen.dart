import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/locator.dart';
import '../../../../app/router/app_router.dart';
import '../../../../../features/home/home.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../../core/ui/kinly_loader.dart';
import '../../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/inputs/kinly_text_field.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../bloc/join_home_bloc.dart';

class JoinHomeScreen extends StatelessWidget {
  const JoinHomeScreen({super.key, this.initialCode});

  final String? initialCode;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return AuthErrorListener(
      child: BlocProvider(
        create:
            (_) =>
                JoinHomeBloc(homeRepository: sl<HomeRepository>())
                  ..add(JoinHomeCodeChanged(initialCode ?? '')),
        child: Scaffold(
          appBar: AppBar(
            title: Text(s.join_title, style: theme.textTheme.titleLarge),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.go(AppRoutes.start),
              ),
            ],
          ),
          body: SafeArea(child: _JoinForm(initialCode: initialCode ?? '')),
        ),
      ),
    );
  }
}

class _JoinForm extends StatefulWidget {
  const _JoinForm({required this.initialCode});
  final String initialCode;

  @override
  State<_JoinForm> createState() => _JoinFormState();
}

class _JoinFormState extends State<_JoinForm> {
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
      listener: (context, state) {
        if (state.status == JoinHomeStatus.success) {
          KinlySnackBar.showSuccess(context, s.join_success(state.code));
          context.read<AuthBloc>().add(const AuthMembershipRefreshRequested());
          if (!mounted) return;
          context.go(AppRoutes.today);
        } else if (state.status == JoinHomeStatus.failure) {
          final errorText = _resolveErrorText(context, state);
          KinlySnackBar.showError(context, errorText);
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.all(
          Theme.of(context).extension<Spacing>()!.lg,
        ),
        child: BlocBuilder<JoinHomeBloc, JoinHomeState>(
          builder: (context, state) {
            final isSubmitting = state.status == JoinHomeStatus.submitting;
            final spacing = Theme.of(context).extension<Spacing>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KinlyTextField(
                  controller: _controller,
                  labelText: s.join_hint,
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
