import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/kinly_theme_access.dart';
import '../../../../core/ui/kinly_segmented_control.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/gratitude_wall_cubit.dart';
import '../../bloc/personal_gratitude_cubit.dart';
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

    final wallState = context.watch<GratitudeWallCubit>().state;
    final personalState = context.watch<PersonalGratitudeCubit>().state;

    final hasHouse =
        !wallState.hasLoaded || (wallState.totalPosts ?? 0) > 0;
    final hasPersonal =
        !personalState.hasLoaded ||
        (personalState.stats?.totalReceived ?? 0) > 0;

    final availableTabs = <GratitudeTab, String>{
      if (hasHouse) GratitudeTab.house: s.gratitudeWallHouseTab,
      if (hasPersonal) GratitudeTab.personal: s.gratitudeWallPersonalTab,
    };

    final effectiveSelected =
        availableTabs.containsKey(selected)
            ? selected
            : availableTabs.keys.first;

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
                  if (availableTabs.length > 1)
                    KinlySegmentedControl<GratitudeTab>(
                      segments: availableTabs,
                      selected: effectiveSelected,
                      onChanged: onSelect,
                    ),
                  if (availableTabs.length > 1) SizedBox(height: spacing.m),
                  Expanded(
                    child:
                        effectiveSelected == GratitudeTab.house
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
