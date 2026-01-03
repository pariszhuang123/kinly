import 'package:flutter/widgets.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../../core/theme/kinly_theme.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/toggles/kinly_checkbox.dart';
import '../../../../core/ui/branding/kinly_logo.dart';
import '../../../../core/ui/kinly_tap_target.dart';
import '../welcome_surface_contract.dart';
import '../../../../core/ui/kinly_theme_access.dart';

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

    return Padding(
      padding: EdgeInsetsDirectional.all(spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
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
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        s.login_consent_prefix,
                        style: theme.textTheme.bodyMedium,
                      ),
                      KinlyTapTarget(
                        onTap: scope.actions.onOpenTerms,
                        alignment: AlignmentDirectional.centerStart,
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
                      KinlyTapTarget(
                        onTap: scope.actions.onOpenPrivacy,
                        alignment: AlignmentDirectional.centerStart,
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
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}




