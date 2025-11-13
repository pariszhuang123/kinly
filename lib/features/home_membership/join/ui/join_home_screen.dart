import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../../auth/widgets/auth_error_listener.dart';
import '../../../auth/widgets/auth_sign_out_button.dart';
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
            actions: const [AuthSignOutButton()],
          ),
          body: _JoinForm(initialCode: initialCode ?? ''),
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
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == JoinHomeStatus.success) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(s.join_success(state.code))));
          context.read<AuthBloc>().add(const AuthMembershipRefreshRequested());
          if (!mounted) return;
          context.go(AppRoutes.today);
        } else if (state.status == JoinHomeStatus.failure) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? s.join_failed_generic),
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<JoinHomeBloc, JoinHomeState>(
          builder: (context, state) {
            final isSubmitting = state.status == JoinHomeStatus.submitting;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: s.join_hint),
                  onChanged:
                      (value) => context.read<JoinHomeBloc>().add(
                        JoinHomeCodeChanged(value),
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      !isSubmitting && state.canSubmit
                          ? () => context.read<JoinHomeBloc>().add(
                            const JoinHomeSubmitted(),
                          )
                          : null,
                  child:
                      isSubmitting
                          ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(s.join_submit),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
