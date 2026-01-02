import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../generated/l10n.dart';
import '../../../core/ui/branding/kinly_logo.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const KinlyLogo(size: 128),
                const SizedBox(height: 32),
                Text(
                  strings.force_update_title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  strings.force_update_body,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                KinlyFilledButton.icon(
                  onPressed: () => _launchStore(),
                  icon: Icons.system_update,
                  label: strings.force_update_button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchStore() async {
    final url = _storeUrl;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch store URL');
    }
  }

  String get _storeUrl {
    if (Platform.isIOS) return AppConfig.iosStoreUrl;
    if (Platform.isAndroid) return AppConfig.androidStoreUrl;
    return AppConfig.androidStoreUrl.isNotEmpty
        ? AppConfig.androidStoreUrl
        : AppConfig.iosStoreUrl;
  }
}
