import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../../core/theme/kinly_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/toggles/kinly_checkbox.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../welcome_surface_contract.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import 'tappable_kinly_logo.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key, required this.scope});

  final WelcomeSurfaceScope scope;

  @override
  Widget build(BuildContext context) {
    final s = scope.strings;
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;
    final linkColors = theme.extension<KinlyLinkColors>()!;
    final canPressGoogle = scope.consented && !scope.busy;
    final showManualInvite =
        scope.supportsManualInvite && scope.actions.onManualInvite != null;

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          TappableKinlyLogo(onTap: scope.actions.onLogoTap),
          const SizedBox(height: 8),
          Text(
            s.login_tagline,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KinlyCheckbox(
                value: scope.consented,
                onChanged: (v) => scope.actions.onConsentChanged(v),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: KinlyTapTarget(
                  onTap: scope.actions.onToggleConsent,
                  borderRadius: BorderRadius.circular(4),
                  alignment: AlignmentDirectional.centerStart,
                  child: _ConsentLegalText(
                    prefix: s.login_consent_prefix,
                    termsText: s.login_terms,
                    connector: s.login_consent_connector,
                    privacyText: s.login_privacy,
                    baseStyle: theme.textTheme.bodyMedium,
                    linkColor: linkColors.link,
                    onOpenTerms: scope.actions.onOpenTerms,
                    onOpenPrivacy: scope.actions.onOpenPrivacy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Opacity(
              opacity: canPressGoogle ? 1.0 : 0.5,
              child: IgnorePointer(
                ignoring: !canPressGoogle,
                child: SignInButton(
                  scope.googleButtonStyle,
                  text: s.login_with_google,
                  onPressed: () {
                    if (!canPressGoogle) return;
                    scope.actions.onGoogleSignIn();
                  },
                ),
              ),
            ),
          ),
          if (scope.supportsApple) ...[
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final canPressApple = scope.consented && !scope.busy;
                return SizedBox(
                  width: double.infinity,
                  child: Opacity(
                    opacity: canPressApple ? 1.0 : 0.5,
                    child: IgnorePointer(
                      ignoring: !canPressApple,
                      child: SignInButton(
                        scope.appleButtonStyle,
                        text: s.login_with_apple,
                        onPressed: () {
                          if (!canPressApple) return;
                          scope.actions.onAppleSignIn();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          if (showManualInvite) ...[
            const SizedBox(height: 12),
            Center(
              child: KinlyTapTarget(
                onTap: scope.actions.onManualInvite!,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  s.manual_invite_cta,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Local/private widget to keep WelcomeBody tidy and ensure the legal copy
/// wraps like a single sentence (instead of each segment wrapping separately).
class _ConsentLegalText extends StatefulWidget {
  const _ConsentLegalText({
    required this.prefix,
    required this.termsText,
    required this.connector,
    required this.privacyText,
    required this.baseStyle,
    required this.linkColor,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final String prefix;
  final String termsText;
  final String connector;
  final String privacyText;
  final TextStyle? baseStyle;
  final Color linkColor;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  @override
  State<_ConsentLegalText> createState() => _ConsentLegalTextState();
}

class _ConsentLegalTextState extends State<_ConsentLegalText> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = widget.onOpenTerms;
    _privacyTap = TapGestureRecognizer()..onTap = widget.onOpenPrivacy;
  }

  @override
  void didUpdateWidget(covariant _ConsentLegalText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep recognizers wired to the latest callbacks.
    if (oldWidget.onOpenTerms != widget.onOpenTerms) {
      _termsTap.onTap = widget.onOpenTerms;
    }
    if (oldWidget.onOpenPrivacy != widget.onOpenPrivacy) {
      _privacyTap.onTap = widget.onOpenPrivacy;
    }
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = widget.baseStyle?.copyWith(
      color: widget.linkColor,
      decoration: TextDecoration.underline,
      decorationColor: widget.linkColor,
    );

    return Text.rich(
      TextSpan(
        style: widget.baseStyle,
        children: [
          TextSpan(text: widget.prefix),
          TextSpan(
            text: widget.termsText,
            style: linkStyle,
            recognizer: _termsTap,
          ),
          TextSpan(text: widget.connector),
          TextSpan(
            text: widget.privacyText,
            style: linkStyle,
            recognizer: _privacyTap,
          ),
        ],
      ),
      textAlign: TextAlign.start,
      softWrap: true,
    );
  }
}
