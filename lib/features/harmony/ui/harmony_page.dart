import 'package:flutter/material.dart';

import '../../../core/theme/spacing.dart';
import '../../../generated/l10n.dart';
import 'harmony_screen.dart';

class HarmonyPage extends StatelessWidget {
  final String homeId;

  const HarmonyPage({super.key, required this.homeId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Scaffold(
      // No AppBar → gives full control of header layout
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// -------------------------------------------
              /// Custom Header (Title + Subtitle)
              /// -------------------------------------------
              Text(
                s.harmonyQuestion,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.s),
              Text(
                s.harmonySubtext,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: spacing.xl),

              /// -------------------------------------------
              /// Body (Scrollable)
              /// -------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: spacing.lg),
                  child: HarmonyScreen(homeId: homeId),
                ),
              ),

              /// -------------------------------------------
              /// Footer
              /// -------------------------------------------
              const HarmonySubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
