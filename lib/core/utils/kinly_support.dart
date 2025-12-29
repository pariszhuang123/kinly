import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../ui/snackbars/kinly_snackbar.dart';
import 'enums/kinly_support_intent.dart';

class KinlySupport {
  static const _supportEmail = 'support@makinglifeeasie.com';

  static Uri buildEmailUri(BuildContext context, KinlySupportIntent intent) {
    final s = S.of(context);
    final subject = switch (intent) {
      KinlySupportIntent.contact => s.profileContactEmailSubject,
      KinlySupportIntent.reactivate => s.profileContactEmailSubject,
      KinlySupportIntent.nps => s.npsEmailSubject,
    };
    return Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': subject},
    );
  }

  static Future<bool> launchEmail(BuildContext context, KinlySupportIntent intent) async {
    final uri = buildEmailUri(context, intent);
    return launchUrl(uri);
  }

  static Future<void> contactSupport(BuildContext context) async {
    final ok = await launchEmail(context, KinlySupportIntent.contact);
    if (!context.mounted) return;
    if (!ok) {
      KinlySnackBar.showError(context, S.of(context).profileContactLaunchError);
    }
  }
}
