// lib/features/gratitude_wall/ui/gratitude_wall_screen.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/share/kinly_share_scaffold.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/gratitude_wall_cubit.dart';
import 'gratitude_wall_content.dart';
import '../../../../core/ui/kinly_theme_access.dart';

class GratitudeWallScreen extends StatelessWidget {
  const GratitudeWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return KinlyShareScaffold(
      fileNamePrefix: 'gratitude_wall',
      logTag: 'GratitudeWallShare',
      subjectBuilder: (ctx) => s.gratitudeWallShareTitle,
      messageBuilder:
          (ctx, appLink) =>
              s.gratitudeWallShareMessage(appLink).replaceAll(r'\n', '\n'),
      // This builds the content that will be captured & shared.
      childBuilder: (ctx) {
        final theme = KinlyThemeAccess.of(ctx);
        final spacing = theme.extension<Spacing>()!;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: Padding(
                  padding: EdgeInsetsDirectional.all(spacing.lg),
                  child: GratitudeWallContent(maxHeight: constraints.maxHeight),
                ),
              ),
            );
          },
        );
      },
      onSharePressed:
          () => context.read<GratitudeWallCubit>().logShareEvent(),
    );
  }
}




