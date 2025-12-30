import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/today_bloc.dart';
import '../../../domain/models.dart';
import 'today_header.dart';
import '../../../../auth/bloc/auth_bloc.dart';
import '../../../../profile_settings/ui/profile_settings_provider.dart';
import '../../../../../../app/router/app_router.dart';
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
    final authBloc = context.read<AuthBloc>();
    final membership = authBloc.state.membership;
    if (membership == null) {
      KinlySnackBar.showError(context, S.of(context).profileMissingHomeError);
      return;
    }

    final args = ProfileSettingsRouteArgs(
      homeId: membership.homeId,
      displayName: profile?.username,
      avatarUrl: profile?.avatarUrl,
    );

    await context.push(AppRoutes.profileSettings, extra: args);
  }
}
