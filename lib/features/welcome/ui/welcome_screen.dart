import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_intents.dart';
import '../../../design_system/kinly_button.dart';
import '../../../generated/l10n.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/widgets/auth_error_listener.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _consented = false;

  static final Uri _termsUri = Uri.parse(
    'https://inky-twill-3ab.notion.site/Service-Term-2a9b40335c2d81a8b297d8c62951d5d1',
  );
  static final Uri _privacyUri = Uri.parse(
    'https://inky-twill-3ab.notion.site/Privacy-Policy-2a9b40335c2d81b3aa13e7739849b40a?pvs=73',
  );

  Future<void> _open(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Optionally show a snackbar; keep silent for now
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final busy = context.select((AuthBloc bloc) => bloc.state.isLoading);
    final supportsApple = Platform.isIOS;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.membershipStatus != current.membershipStatus,
      listener: (context, state) {
        if (!mounted) return;
        final membershipReady =
            state.membershipStatus != AuthMembershipStatus.unknown;
        if (state.status == AuthStatus.authenticated && membershipReady) {
          final pending = NavigationIntents.takePendingJoinCode();
          if (pending != null) {
            context.go('/join/$pending');
            return;
          }
          final nextRoute =
              state.membershipStatus == AuthMembershipStatus.active
                  ? AppRoutes.today
                  : AppRoutes.start;
          context.go(nextRoute);
        }
      },
      child: AuthErrorListener(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Logo/title
                  Text(
                    s.app_title,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.login_tagline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Consent checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _consented,
                        onChanged:
                            (v) => setState(() => _consented = v ?? false),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(s.login_consent_prefix),
                            InkWell(
                              onTap: () => _open(_termsUri),
                              child: Text(
                                s.login_terms,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const Text(' & '),
                            InkWell(
                              onTap: () => _open(_privacyUri),
                              child: Text(
                                s.login_privacy,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Google login button (enabled only when consented)
                  KinlyButton.primary(
                    onPressed:
                        !_consented || busy
                            ? null
                            : () {
                              context.read<AuthBloc>().add(
                                const AuthSignInWithGoogleRequested(),
                              );
                            },
                    label: s.login_with_google,
                  ),
                  if (supportsApple) ...[
                    const SizedBox(height: 12),
                    KinlyButton.primary(
                      onPressed:
                          !_consented || busy
                              ? null
                              : () {
                                context.read<AuthBloc>().add(
                                  const AuthSignInWithAppleRequested(),
                                );
                              },
                      label: s.login_with_apple,
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
