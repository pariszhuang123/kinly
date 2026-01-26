import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kinly/contracts/mood/house_pulse_models.dart';
import 'package:kinly/core/theme/kinly_sections.dart';
import 'package:kinly/core/ui/house/house_info_card.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/share/kinly_story_share_scaffold.dart';
import 'package:kinly/foundation/surfaces/today/bloc/today_bloc.dart';

class TodayHousePulseDetailScreen extends StatelessWidget {
  const TodayHousePulseDetailScreen({super.key, required this.pulse});

  final HousePulsePayload pulse;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    final sections = theme.extension<KinlySections>()!;
    final s = S.of(context);

    final data = HouseInfoCardData.fromPulse(
      pulse: pulse,
      palette: sections.pulse,
      strings: s,
    );

    return KinlyStoryShareScaffold(
      fileNamePrefix: 'house_pulse',
      logTag: 'house_pulse',
      appBarTitle: null, // As requested
      fabTooltip: s.housePulseShareCta,
      subjectBuilder: (ctx) => s.housePulseShareTitle,
      messageBuilder: (ctx, appLink) => s.housePulseShareMessage(appLink),
      onSharePressed: () async {
        context.read<TodayBloc>().add(
          const TodayHousePulseShareLogged(channel: 'system_share'),
        );
      },
      child: HouseInfoShareCard(data: data),
    );
  }
}
