import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_route_names.dart';
import '../../../generated/l10n.dart';
import '../../../core/auth/bloc/auth_bloc.dart';
import '../../../core/auth/widgets/auth_error_listener.dart';
import '../../../core/platform/platform_info.dart';
import '../../../core/ui/snackbars/kinly_snackbar.dart';
import 'welcome_surface_contract.dart';
import 'welcome_surface_registry.dart';
import '../../../core/ui/kinly_scaffold.dart';
import '../../../core/ui/kinly_theme_access.dart';
import '../../../core/ui/inputs/kinly_text_field.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../core/links/join_intent_coordinator.dart';
import '../../../core/di/locator.dart';
import '../../../renderer/material/ui/bottom_sheet/kinly_bottom_sheet.dart';

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
      KinlySnackBar.showInfo(context, s.demoAccessTapHint(_logoTapCount));
    }
  }

  Future<void> _onManualInvite(BuildContext context) async {
    if (!sl.isRegistered<JoinIntentCoordinator>()) return;
    final coordinator = sl<JoinIntentCoordinator>();
    final s = S.of(context);
    final controller = TextEditingController();

    final input = await KinlyBottomSheet.show<String>(
      context: context,
      title: s.manual_invite_cta,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KinlyTextField(
            controller: controller,
            labelText: s.manual_invite_placeholder,
          ),
        ],
      ),
      footer: [
        KinlyFilledButton.text(
          fullWidth: true,
          label: s.join_submit,
          onPressed: () => Navigator.of(context).pop(controller.text.trim()),
        ),
      ],
    );

    if (!mounted || !context.mounted) return;
    if (input == null || input.isEmpty) return;
    final stored = await coordinator.captureManualEntry(input);
    if (!mounted || !context.mounted) return;
    if (stored) {
      KinlySnackBar.showSuccess(context, s.manual_invite_saved);
    } else {
      KinlySnackBar.showError(context, s.join_error_invalid_code);
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
    const supportsManualInvite = false;
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
      onManualInvite: null,
    );
    final scope = WelcomeSurfaceScope(
      context: context,
      strings: strings,
      consented: _consented,
      busy: busy,
      supportsApple: supportsApple,
      supportsManualInvite: supportsManualInvite,
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
