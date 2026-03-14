import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kinly/app/router/app_route_names.dart';
import 'package:kinly/core/ui/kinly_app_bar.dart';
import 'package:kinly/core/ui/kinly_loader.dart';
import 'package:kinly/core/ui/kinly_scaffold.dart';
import 'package:kinly/core/ui/kinly_theme_access.dart';
import 'package:kinly/core/ui/snackbars/kinly_snackbar.dart';
import 'package:kinly/features/house_directory/bloc/house_directory_bloc.dart';
import 'package:kinly/features/house_directory/ui/house_directory_forms.dart';
import 'package:kinly/features/house_directory/ui/house_directory_sections.dart';
import 'package:kinly/generated/l10n.dart';

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
                  final cardWidth =
                      useTwoColumns
                          ? (constraints.maxWidth - 12) / 2
                          : constraints.maxWidth;
                  final showWifiCard = state.isOwner || state.wifi != null;
                  final detailsCount =
                      state.rentServices.length +
                      state.utilityServices.length +
                      state.notes.length;
                  final showDetailsCard = state.isOwner || detailsCount > 0;
                  final cards = <Widget>[
                    if (showWifiCard)
                      SizedBox(
                        width: cardWidth,
                        child: HouseDirectorySurfaceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).houseDirectoryWifiTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              HouseDirectoryWifiCardContent(
                                wifi: state.wifi,
                                isOwner: state.isOwner,
                                onEdit:
                                    state.isOwner
                                        ? () => _openWifiDialog(context, state)
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (showDetailsCard)
                      SizedBox(
                        width: cardWidth,
                        child: HouseDirectorySurfaceCard(
                          onTap:
                              () => context.pushNamed(
                                AppRouteNames.houseDirectoryDetails,
                              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).houseDirectoryEmptyTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(S.of(context).houseDirectoryEmptyBody),
                              const SizedBox(height: 12),
                              Text(_detailsSummary(context, state)),
                            ],
                          ),
                        ),
                      ),
                  ];
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: cards,
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

  Future<void> _openWifiDialog(
    BuildContext context,
    HouseDirectoryState state,
  ) async {
    final result = await showHouseDirectoryWifiSheet(
      context,
      homeId: homeId,
      wifi: state.wifi,
    );
    if (result == null || !context.mounted) return;
    context.read<HouseDirectoryBloc>().add(HouseDirectoryWifiSaved(result));
  }

  String _detailsSummary(BuildContext context, HouseDirectoryState state) {
    final s = S.of(context);
    final count =
        state.rentServices.length +
        state.utilityServices.length +
        state.notes.length;
    if (count == 0) {
      return s.houseDirectoryServicesEmpty;
    }
    return '${state.rentServices.length} ${s.houseDirectoryRentTitle.toLowerCase()}, '
        '${state.utilityServices.length} ${s.houseDirectoryServicesTitle.toLowerCase()}, '
        '${state.notes.length} ${s.houseDirectoryNotesTitle.toLowerCase()}';
  }
}
