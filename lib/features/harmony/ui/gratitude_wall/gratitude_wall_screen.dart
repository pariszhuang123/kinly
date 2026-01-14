// lib/features/gratitude_wall/ui/gratitude_wall_screen.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/share/kinly_share_scaffold.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/gratitude_wall_cubit.dart';
import '../../bloc/personal_gratitude_cubit.dart';
import 'gratitude_wall_body.dart';

enum GratitudeTab { house, personal }

class GratitudeWallScreen extends StatefulWidget {
  const GratitudeWallScreen({super.key});

  @override
  State<GratitudeWallScreen> createState() => _GratitudeWallScreenState();
}

class _GratitudeWallScreenState extends State<GratitudeWallScreen> {
  GratitudeTab _selected = GratitudeTab.house;

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
      childBuilder: (ctx) => GratitudeWallBody(
        selected: _selected,
        onSelect: (tab) => setState(() => _selected = tab),
      ),
      onSharePressed: () async {
        if (_selected == GratitudeTab.personal) {
          context.read<PersonalGratitudeCubit>().logShareEvent();
        } else {
          context.read<GratitudeWallCubit>().logShareEvent();
        }
      },
    );
  }
}
