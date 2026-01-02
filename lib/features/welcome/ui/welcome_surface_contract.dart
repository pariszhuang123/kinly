import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../generated/l10n.dart';

class WelcomeSurfaceSlots {
  const WelcomeSurfaceSlots({
    this.header,
    required this.body,
    this.empty,
    this.footer,
    this.actions,
  });

  final Widget? header;
  final Widget body;
  final Widget? empty;
  final Widget? footer;
  final List<Widget>? actions;
}

class WelcomeSurfaceActions {
  const WelcomeSurfaceActions({
    required this.onConsentChanged,
    required this.onToggleConsent,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final ValueChanged<bool> onConsentChanged;
  final VoidCallback onToggleConsent;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;
}

class WelcomeSurfaceScope {
  const WelcomeSurfaceScope({
    required this.context,
    required this.strings,
    required this.consented,
    required this.busy,
    required this.supportsApple,
    required this.googleButtonStyle,
    required this.appleButtonStyle,
    required this.actions,
  });

  final BuildContext context;
  final S strings;
  final bool consented;
  final bool busy;
  final bool supportsApple;
  final Buttons googleButtonStyle;
  final Buttons appleButtonStyle;
  final WelcomeSurfaceActions actions;
}
