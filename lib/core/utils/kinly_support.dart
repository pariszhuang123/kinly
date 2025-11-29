import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/snackbars/kinly_snackbar.dart';
import '../../generated/l10n.dart';

class KinlySupport {
  static Future<bool> launchEmail(String subject) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@makinglifeeasie.com',
      queryParameters: {'subject': subject},
    );
    return launchUrl(uri);
  }

  static Future<void> contactSupport(BuildContext context) async {
    final s = S.of(context);

    final ok = await launchEmail(s.profileContactEmailSubject);
    if (!context.mounted) return;

    if (!ok) {
      KinlySnackBar.showError(context, s.profileContactLaunchError);
    }
  }
}
