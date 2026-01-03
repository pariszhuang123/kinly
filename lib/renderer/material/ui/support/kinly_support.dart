import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/l10n.dart';
import '../snackbars/kinly_snackbar.dart';
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
    // Build the query manually to keep spaces encoded as %20 instead of +,
    // since some mail clients surface the raw subject text.
    final subjectQuery = 'subject=${Uri.encodeComponent(subject)}';
    return Uri(scheme: 'mailto', path: _supportEmail, query: subjectQuery);
  }

  static Future<bool> launchEmail(
    BuildContext context,
    KinlySupportIntent intent,
  ) async {
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
