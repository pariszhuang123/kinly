import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/contracts/house_directory/models.dart';
import 'package:kinly/contracts/personal_directory/models.dart';
import 'package:kinly/core/ui/buttons/kinly_outlined_button.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_circle_avatar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_refresh_indicator.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_tap_target.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/scroll/kinly_scroll_fade.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_route_args.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';
import 'package:kinly/renderer/material/kinly_icons.dart';

class HouseDirectoryScreen extends StatelessWidget {
  const HouseDirectoryScreen({super.key, required this.homeId});

  final String homeId;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return BlocListener<HouseDirectoryBloc, HouseDirectoryState>(
      listenWhen: (previous, current) => previous.notice != current.notice,
      listener: _showNotice,
      child: BlocBuilder<HouseDirectoryBloc, HouseDirectoryState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasContent) {
            return const KinlyScaffold(
              body: Center(child: KinlyLoader()),
            );
          }
          return KinlyScaffold(
            appBar: KinlyAppBar(title: Text(S.of(context).houseDirectoryTitle)),
            body: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final useTwoColumns = constraints.maxWidth >= 760;
                  final colors = theme.colorScheme;
                  final cardWidth =
                      useTwoColumns
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth;
                  final showWifiCard = state.isOwner || state.wifi != null;
                  final detailsCount =
                      state.rentServices.length +
                      state.utilityServices.length +
                      state.allNotes.length;
                  final showDetailsCard = state.isOwner || detailsCount > 0;
                  final showMembersCard = state.members.isNotEmpty;
                  final cards = <Widget>[
                    if (showWifiCard)
                      SizedBox(
                        width: cardWidth,
                        child: HouseDirectorySurfaceCard(
                          backgroundColor: colors.surfaceContainerHigh,
                          borderColor: colors.outlineVariant,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      S.of(context).houseDirectoryWifiTitle,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  if (state.isOwner)
                                    KinlyOutlinedButton.text(
                                      onPressed:
                                          () => _openWifiScreen(context, state),
                                      label:
                                          state.wifi == null
                                              ? S.of(context).houseDirectoryAddWifi
                                              : S.of(context).houseDirectoryEdit,
                                      compact: true,
                                      fullWidth: false,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              HouseDirectoryWifiCardContent(
                                wifi: state.wifi,
                                isOwner: state.isOwner,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showDetailsCard)
                      SizedBox(
                        width: cardWidth,
                        child: HouseDirectorySurfaceCard(
                          backgroundColor: colors.surfaceContainerLowest,
                          borderColor: colors.outlineVariant,
                          onTap:
                              () => context.pushNamed(
                                AppRouteNames.houseDirectoryDetails,
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      S.of(context).houseDirectoryEmptyTitle,
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  Icon(
                                    KinlyIcons.chevronRightRounded,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(_detailsSubtitle(context, state)),
                              const SizedBox(height: 12),
                              Text(_detailsSummary(context, state)),
                            ],
                          ),
                        ),
                      ),
                    if (showMembersCard)
                      SizedBox(
                        width: cardWidth,
                        child: HouseDirectorySurfaceCard(
                          backgroundColor: colors.surfaceContainerHigh,
                          borderColor: colors.outlineVariant,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).houseDirectoryMembersTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              ..._buildMemberRows(context, state.members),
                            ],
                          ),
                        ),
                      ),
                  ];
                  return KinlyScrollFade(
                    child: KinlyRefreshIndicator(
                      onRefresh: () => _handleRefresh(context),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: 8,
                            bottom: 8,
                          ),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: cards,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMemberRows(
    BuildContext context,
    List<HouseDirectoryMemberCard> members,
  ) {
    return members
        .map(
          (member) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: _HouseDirectoryMemberRow(
              member: member,
              onTap: () => _openMemberDirectory(context, member),
            ),
          ),
        )
        .toList(growable: false);
  }

  void _openMemberDirectory(
    BuildContext context,
    HouseDirectoryMemberCard member,
  ) {
    context.pushNamed(
      AppRouteNames.personalDirectory,
      extra: PersonalDirectoryMemberSummary(
        userId: member.userId,
        username: member.username,
        avatarUrl: member.avatarUrl,
        avatarStoragePath: member.avatarStoragePath,
        isHomeOwner: member.isOwner,
        hasContent: member.hasPersonalDirectoryContent,
      ),
    );
  }

  void _showNotice(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    final message = switch (state.notice) {
      HouseDirectoryNotice.loadFailed =>
        state.errorMessage ?? s.houseDirectoryLoadError,
      HouseDirectoryNotice.wifiSaved => s.houseDirectoryWifiSaved,
      HouseDirectoryNotice.actionFailed =>
        state.errorMessage ?? s.houseDirectoryActionFailed,
      _ => null,
    };
    if (message == null) return;
    if (state.notice == HouseDirectoryNotice.loadFailed ||
        state.notice == HouseDirectoryNotice.actionFailed) {
      KinlySnackBar.showError(context, message);
      return;
    }
    KinlySnackBar.showSuccess(context, message);
  }

  Future<void> _openWifiScreen(
    BuildContext context,
    HouseDirectoryState state,
  ) async {
    final result = await context.pushNamed<UpsertHouseDirectoryWifiInput>(
      AppRouteNames.houseDirectoryWifi,
      extra: HouseDirectoryWifiRouteArgs(wifi: state.wifi),
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryWifiSaved(result));
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<HouseDirectoryBloc>();
    bloc.add(const HouseDirectoryRefreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
  }

  String _detailsSummary(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    final count =
        state.rentServices.length +
        state.utilityServices.length +
        state.allNotes.length;
    if (count == 0) {
      return s.houseDirectoryServicesEmpty;
    }
    return '${state.rentServices.length} ${s.houseDirectoryRentTitle.toLowerCase()}, '
        '${state.utilityServices.length} ${s.houseDirectoryServicesTitle.toLowerCase()}, '
        '${state.allNotes.length} ${s.houseDirectoryNotesTitle.toLowerCase()}';
  }

  String _detailsSubtitle(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    if (state.isOwner) {
      return s.houseDirectoryOwnerSubtitle;
    }
    return s.houseDirectoryMemberSubtitle;
  }
}

class _HouseDirectoryMemberRow extends StatelessWidget {
  const _HouseDirectoryMemberRow({
    required this.member,
    required this.onTap,
  });

  final HouseDirectoryMemberCard member;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = KinlyThemeAccess.of(context);
    return KinlyTapTarget(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 4,
          vertical: 6,
        ),
        child: Row(
          children: [
            KinlyCircleAvatar(
              avatarUrl: member.avatarUrl,
              radius: 20,
              isOwner: member.isOwner,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                member.username,
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Icon(
              KinlyIcons.chevronRightRounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
