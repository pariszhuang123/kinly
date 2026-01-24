import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_route_names.dart';
import '../../../app/router/navigation_intents.dart';
import '../../../generated/l10n.dart';
import '../../../core/auth/bloc/auth_bloc.dart';
import '../../../core/auth/widgets/auth_error_listener.dart';
import '../../../core/platform/platform_info.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import 'welcome_surface_contract.dart';
import 'welcome_surface_registry.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_theme_access.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _consented = false;
  int _logoTapCount = 0;

  static const _requiredTaps = 7;
  static const _revealThreshold = 3;

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

  void _onLogoTap() {
    setState(() {
      _logoTapCount++;
    });
    if (_logoTapCount >= _requiredTaps) {
      setState(() {
        _logoTapCount = 0;
      });
      context.goNamed(AppRouteNames.demoAccess);
      return;
    }
    if (_logoTapCount >= _revealThreshold) {
      final s = S.of(context);
      KinlySnackBar.showInfo(
        context,
        s.demoAccessTapHint(_logoTapCount),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final busy = context.select((AuthBloc bloc) => bloc.state.isLoading);
    final supportsApple = PlatformInfo.isIOS;
    final isDarkMode = theme.brightness == Brightness.dark;
    final googleButtonStyle = isDarkMode ? Buttons.google : Buttons.google;
    final appleButtonStyle = isDarkMode ? Buttons.appleDark : Buttons.apple;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              previous.status != current.status ||
              previous.membershipStatus != current.membershipStatus ||
              previous.isProfileDeactivated != current.isProfileDeactivated,
      listener: (context, state) {
        if (!mounted) return;
        if (state.isProfileDeactivated) {
          KinlySnackBar.showError(context, s.profile_deactivated_message);
        }
        final membershipReady =
            state.membershipStatus != AuthMembershipStatus.unknown;
        if (state.status == AuthStatus.authenticated && membershipReady) {
          final pending = NavigationIntents.takePendingJoinCode();
          if (pending != null) {
            context.goNamed(
              AppRouteNames.joinWithCode,
              pathParameters: {'code': pending},
            );
            return;
          }
          final nextRouteName =
              state.membershipStatus == AuthMembershipStatus.active
                  ? AppRouteNames.today
                  : AppRouteNames.start;
          context.goNamed(nextRouteName);
        }
      },
      child: AuthErrorListener(
        child: KinlyScaffold(
          body: SafeArea(
            child: _buildWelcomeBody(
              context: context,
              strings: s,
              busy: busy,
              supportsApple: supportsApple,
              googleButtonStyle: googleButtonStyle,
              appleButtonStyle: appleButtonStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBody({
    required BuildContext context,
    required S strings,
    required bool busy,
    required bool supportsApple,
    required Buttons googleButtonStyle,
    required Buttons appleButtonStyle,
  }) {
    WelcomeRegistry.bootstrap();
    final actions = WelcomeSurfaceActions(
      onConsentChanged: (value) => setState(() => _consented = value),
      onToggleConsent: () => setState(() => _consented = !_consented),
      onGoogleSignIn: () {
        context.read<AuthBloc>().add(const AuthSignInWithGoogleRequested());
      },
      onAppleSignIn: () {
        context.read<AuthBloc>().add(const AuthSignInWithAppleRequested());
      },
      onOpenTerms: () => _open(_termsUri),
      onOpenPrivacy: () => _open(_privacyUri),
      onLogoTap: _onLogoTap,
    );
    final scope = WelcomeSurfaceScope(
      context: context,
      strings: strings,
      consented: _consented,
      busy: busy,
      supportsApple: supportsApple,
      googleButtonStyle: googleButtonStyle,
      appleButtonStyle: appleButtonStyle,
      actions: actions,
    );
    final slots = WelcomeSurfaceSlots(body: _buildWelcomeSections(scope));
    return slots.body;
  }

  Widget _buildWelcomeSections(WelcomeSurfaceScope scope) {
    final entries = WelcomeRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: entries
          .map((entry) => entry.builder(scope))
          .toList(growable: false),
    );
  }
}
