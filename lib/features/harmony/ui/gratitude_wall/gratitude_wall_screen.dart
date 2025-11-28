// lib/features/gratitude_wall/ui/gratitude_wall_screen.dart
import 'package:flutter/material.dart';

import '../../../../core/share/kinly_share_scaffold.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n.dart';
import 'gratitude_wall_content.dart';

class GratitudeWallScreen extends StatelessWidget {
  const GratitudeWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyShareScaffold(
      fileNamePrefix: 'gratitude_wall',
      logTag: 'GratitudeWallShare',
      appBarTitle: s.gratitudeWallTitle,
      subjectBuilder: (ctx) => s.gratitudeWallShareTitle,
      messageBuilder:
          (ctx, appLink) =>
              s.gratitudeWallShareMessage(appLink).replaceAll(r'\n', '\n'),
      // This builds the content that will be captured & shared.
      childBuilder: (ctx) {
        final theme = Theme.of(ctx);
        final sizes = theme.extension<AppSizes>();
        final spacing = theme.extension<Spacing>()!;

        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = sizes?.maxContentWidth ?? 640.0;
            final width =
                constraints.maxWidth < maxWidth
                    ? constraints.maxWidth
                    : maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Padding(
                  padding: EdgeInsets.all(spacing.lg),
                  child: GratitudeWallContent(maxHeight: constraints.maxHeight),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
