import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route_names.dart';
import '../../../core/auth/bloc/auth_bloc.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/ui/inputs/kinly_text_field.dart';
import '../../../core/ui/kinly_app_bar.dart';
import '../../../core/ui/kinly_icons.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../generated/l10n.dart';
import '../../../renderer/material/kinly_icon_button.dart';

class DemoAccessScreen extends StatefulWidget {
  const DemoAccessScreen({super.key});

  @override
  State<DemoAccessScreen> createState() => _DemoAccessScreenState();
}

class _DemoAccessScreenState extends State<DemoAccessScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _onSubmit() {
    if (!_canSubmit) return;
    context.read<AuthBloc>().add(
      DemoLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final isLoading = context.select((AuthBloc bloc) => bloc.state.isLoading);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyX):
            () => context.goNamed(AppRouteNames.welcome),
      },
      child: Focus(
        autofocus: true,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            context.goNamed(AppRouteNames.welcome);
          },
          child: BlocListener<AuthBloc, AuthState>(
            listenWhen:
                (previous, current) =>
                    previous.status != current.status ||
                    previous.membershipStatus != current.membershipStatus ||
                    previous.errorMessage != current.errorMessage,
            listener: (context, state) {
              if (!mounted) return;
              if (state.errorMessage != null) {
                KinlySnackBar.showError(context, s.demoAccessError);
                context.read<AuthBloc>().add(const AuthErrorCleared());
                return;
              }
              final membershipReady =
                  state.membershipStatus != AuthMembershipStatus.unknown;
              if (state.status == AuthStatus.authenticated && membershipReady) {
                final nextRouteName =
                    state.membershipStatus == AuthMembershipStatus.active
                        ? AppRouteNames.today
                        : AppRouteNames.start;
                context.goNamed(nextRouteName);
              }
            },
            child: KinlyScaffold(
              appBar: KinlyAppBar(
                title: Text(s.demoAccess),
                leading: KinlyIconButton(
                  icon: KinlyIcons.close,
                  onPressed: () => context.goNamed(AppRouteNames.welcome),
                ),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsetsDirectional.all(spacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KinlyTextField(
                        controller: _emailController,
                        labelText: s.demoAccessEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: spacing.l),
                      KinlyTextField(
                        controller: _passwordController,
                        labelText: s.demoAccessPassword,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        enabled: !isLoading,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: spacing.xl),
                      KinlyFilledButton.text(
                        onPressed: _canSubmit && !isLoading ? _onSubmit : null,
                        label: isLoading ? '...' : s.demoAccessSubmit,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
