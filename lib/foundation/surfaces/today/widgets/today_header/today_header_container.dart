import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/today_bloc.dart';
import '../../domain/models.dart';
import 'today_header.dart';
import 'package:kinly/contracts/profile_settings/profile_settings_route_args.dart';
import '../../../../../../app/router/app_route_names.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../core/ui/snackbars/kinly_snackbar.dart';

class TodayHeaderContainer extends StatelessWidget {
  final String partOfDay;

  const TodayHeaderContainer({super.key, required this.partOfDay});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodayBloc, TodayState>(
      buildWhen:
          (previous, current) =>
              previous.profile != current.profile ||
              previous.isLoading != current.isLoading,
      builder: (context, state) {
        return TodayHeader(
          partOfDay: partOfDay,
          profile: state.profile,
          onAvatarTap: () => _openProfileSettings(context, state.profile),
        );
      },
    );
  }

  Future<void> _openProfileSettings(
    BuildContext context,
    TodayUserProfile? profile,
  ) async {
    final homeId = context.read<TodayBloc>().homeId;
    if (homeId.isEmpty) {
      KinlySnackBar.showError(context, S.of(context).profileMissingHomeError);
      return;
    }

    final args = ProfileSettingsRouteArgs(
      homeId: homeId,
      displayName: profile?.username,
      avatarUrl: profile?.avatarUrl,
    );

    await context.pushNamed(AppRouteNames.profileSettings, extra: args);
  }
}

