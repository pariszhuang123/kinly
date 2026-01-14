import 'package:flutter/widgets.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_segmented_control.dart';
import '../../../../generated/l10n.dart';
import 'gratitude_wall_content.dart';
import 'personal_gratitude_wall_content.dart';
import 'gratitude_wall_screen.dart';

class GratitudeWallBody extends StatelessWidget {
  const GratitudeWallBody({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final GratitudeTab selected;
  final ValueChanged<GratitudeTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = KinlyThemeAccess.of(context);
    final spacing = theme.extension<Spacing>()!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Padding(
              padding: EdgeInsetsDirectional.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KinlySegmentedControl<GratitudeTab>(
                    segments: {
                      GratitudeTab.house: s.gratitudeWallHouseTab,
                      GratitudeTab.personal: s.gratitudeWallPersonalTab,
                    },
                    selected: selected,
                    onChanged: onSelect,
                  ),
                  SizedBox(height: spacing.m),
                  Expanded(
                    child:
                        selected == GratitudeTab.house
                            ? GratitudeWallContent(
                              maxHeight: constraints.maxHeight,
                            )
                            : PersonalGratitudeWallContent(
                              maxHeight: constraints.maxHeight,
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
