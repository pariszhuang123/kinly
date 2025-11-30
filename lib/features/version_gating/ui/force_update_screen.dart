import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/ui/buttons/kinly_filled_button.dart';
import '../../../generated/l10n.dart';
import '../../splash/ui/widgets/kinly_logo.dart';
import '../bloc/app_version_cubit.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final state = context.watch<AppVersionCubit>().state;
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
                if (state.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: EdgeInsetsDirectional.all(spacing.lg),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.force_update_notes_label,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(state.notes!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                KinlyFilledButton.icon(
                  onPressed: () => _launchStore(),
                  icon: Icons.system_update,
                  label: strings.force_update_button,
                ),
                if (state.clientVersion != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    strings.force_update_version_details(
                      state.clientVersion ?? '-',
                      state.currentVersion ?? '-',
                    ),
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
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
