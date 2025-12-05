import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_intents.dart';
import '../../../core/theme/kinly_theme.dart'; // <- link colors extension
import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/widgets/auth_error_listener.dart';
import '../../splash/ui/widgets/kinly_logo.dart';
import '../../../core/ui/toggles/kinly_checkbox.dart'; // <-- NEW IMPORT

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
    final spacing = theme.extension<Spacing>()!;
    final busy = context.select((AuthBloc bloc) => bloc.state.isLoading);
    final supportsApple = Platform.isIOS;
    final linkColors = theme.extension<KinlyLinkColors>()!;

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
              padding: EdgeInsetsDirectional.all(spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Logo/title
                  const KinlyLogo(),
                  const SizedBox(height: 8),
                  Text(
                    s.login_tagline,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),

                  // Consent checkbox + links
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KinlyCheckbox(
                        value: _consented,
                        onChanged: (v) {
                          setState(() => _consented = v);
                        },
                      ),
                      const SizedBox(width: 8),
                      // Make the whole text block tappable to toggle consent
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() => _consented = !_consented);
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                s.login_consent_prefix,
                                style: theme.textTheme.bodyMedium,
                              ),
                              InkWell(
                                onTap: () => _open(_termsUri),
                                child: Text(
                                  s.login_terms,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: linkColors.link,
                                    decoration: TextDecoration.underline,
                                    decorationColor: linkColors.link,
                                  ),
                                ),
                              ),
                              Text(
                                s.login_consent_connector,
                                style: theme.textTheme.bodyMedium,
                              ),
                              InkWell(
                                onTap: () => _open(_privacyUri),
                                child: Text(
                                  s.login_privacy,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: linkColors.link,
                                    decoration: TextDecoration.underline,
                                    decorationColor: linkColors.link,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Google login button (enabled only when consented & not busy)
                  Builder(
                    builder: (context) {
                      final canPressGoogle = _consented && !busy;
                      return SizedBox(
                        width: double.infinity,
                        child: Opacity(
                          opacity: canPressGoogle ? 1.0 : 0.5,
                          child: IgnorePointer(
                            ignoring: !canPressGoogle,
                            child: SignInButton(
                              Buttons.google,
                              text: s.login_with_google,
                              onPressed: () {
                                if (!canPressGoogle) return;
                                context.read<AuthBloc>().add(
                                  const AuthSignInWithGoogleRequested(),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  if (supportsApple) ...[
                    const SizedBox(height: 12),
                    Builder(
                      builder: (context) {
                        final canPressApple = _consented && !busy;
                        return SizedBox(
                          width: double.infinity,
                          child: Opacity(
                            opacity: canPressApple ? 1.0 : 0.5,
                            child: IgnorePointer(
                              ignoring: !canPressApple,
                              child: SignInButton(
                                Buttons.appleDark,
                                text: s.login_with_apple,
                                onPressed: () {
                                  if (!canPressApple) return;
                                  context.read<AuthBloc>().add(
                                    const AuthSignInWithAppleRequested(),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
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
