import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../ui/snackbars/kinly_snackbar.dart';
import '../bloc/auth_bloc.dart';

/// Listens for auth errors and surfaces them via [ScaffoldMessenger].
class AuthErrorListener extends StatelessWidget {
  const AuthErrorListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) => previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final message = state.errorMessage;
        if (message == null || message.isEmpty) {
          return;
        }
        final resolvedMessage = _resolveMessage(context, message);
        KinlySnackBar.showError(context, resolvedMessage);
        context.read<AuthBloc>().add(const AuthErrorCleared());
      },
      child: child,
    );
  }

  String _resolveMessage(BuildContext context, String message) {
    final strings = S.of(context);
    if (message == AuthBloc.membershipLoadFailedKey) {
      return strings.authMembershipLoadFailed;
    }
    return message;
  }
}
