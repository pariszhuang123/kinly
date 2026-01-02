import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route_names.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_fab.dart';
import '../../../../core/ui/snackbars/kinly_snackbar.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';
import '../share_edit_outcome.dart';
import '../share_edit_route_args.dart';
import 'share_created_list_surface_contract.dart';
import 'share_created_list_surface_registry.dart';

class ShareCreatedListScreen extends StatelessWidget {
  const ShareCreatedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShareCreatedListRegistry.bootstrap();
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>()!;
    final shareColors = sections.share;
    final spacing = theme.extension<Spacing>()!;
    final s = S.of(context);

    return Scaffold(
      backgroundColor: shareColors.background,
      appBar: AppBar(
        backgroundColor: shareColors.background,
        title: Text(s.shareCreatedListTitle),
      ),
      floatingActionButton: KinlyFab(
        onPressed: () => _openShareCreate(context),
        heroTag: 'share_created_list_fab',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.all(spacing.lg),
          child: BlocBuilder<ShareCreatedListBloc, ShareCreatedListState>(
            builder: (context, state) {
              final actions = ShareCreatedListSurfaceActions(
                onRefreshRequested: () => _handleRefresh(context),
                onCreateTap: () => _openShareCreate(context),
                onEntryTap: (entry) => _openShareEntry(context, entry),
              );
              final scope = ShareCreatedListSurfaceScope(
                context: context,
                state: state,
                spacing: spacing,
                sections: sections,
                strings: s,
                actions: actions,
              );
              final slots = ShareCreatedListSurfaceSlots(
                body: _buildCreatedListBody(scope),
              );
              return slots.body;
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh(BuildContext context) async {
    final bloc = context.read<ShareCreatedListBloc>();
    final completer = Completer<void>();
    late final StreamSubscription<ShareCreatedListState> sub;

    sub = bloc.stream.listen((state) {
      if (!state.isRefreshing &&
          state.status != ShareCreatedListStatus.loading) {
        completer.complete();
        sub.cancel();
      }
    });

    bloc.add(const ShareCreatedListRefreshed());
    await completer.future;
  }

  void _refreshList(BuildContext context) {
    context.read<ShareCreatedListBloc>().add(const ShareCreatedListRefreshed());
  }

  Future<void> _openShareCreate(BuildContext context) async {
    final s = S.of(context);
    final result = await context.pushNamed<bool>(AppRouteNames.shareCreate);
    if (result == true && context.mounted) {
      final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
      KinlySnackBar.showSuccess(
        context,
        s.shareCreateSuccess,
        accentColor: accent,
      );
      _refreshList(context);
    }
  }

  Future<void> _openShareEntry(
    BuildContext context,
    ShareCreatedListEntry entry,
  ) async {
    final s = S.of(context);
    final result = await context.pushNamed(
      AppRouteNames.shareDraftEdit,
      pathParameters: {'expenseId': entry.expenseId},
      extra: const ShareEditRouteArgs(allowDelete: true),
    );

    if (!context.mounted || result == null) return;

    final accent = Theme.of(context).extension<KinlySections>()?.share.accent;
    if (result == true || result == ShareEditOutcome.updated) {
      KinlySnackBar.showSuccess(
        context,
        s.shareEditSuccess,
        accentColor: accent,
      );
      _refreshList(context);
    } else if (result == ShareEditOutcome.deleted) {
      KinlySnackBar.showSuccess(
        context,
        s.shareEditDeleteSuccess,
        accentColor: accent,
      );
      _refreshList(context);
    }
  }

  Widget _buildCreatedListBody(ShareCreatedListSurfaceScope scope) {
    final entries = ShareCreatedListRegistry.bodySections;
    if (entries.length == 1) {
      return entries.first.builder(scope);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          entries.map((entry) => entry.builder(scope)).toList(growable: false),
    );
  }
}
