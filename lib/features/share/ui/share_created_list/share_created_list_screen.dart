import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/kinly_sections.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/ui/buttons/kinly_fab.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/share_created_list_bloc/share_created_list_bloc.dart';
import '../share_edit_outcome.dart';
import '../share_edit_route_args.dart';
import '../widgets/share_created_list_view.dart';

class ShareCreatedListScreen extends StatelessWidget {
  const ShareCreatedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sections = theme.extension<KinlySections>();
    final shareColors = sections?.share;
    final spacing = theme.extension<Spacing>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: shareColors?.background ?? theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: shareColors?.background,
        title: Text(s.shareCreatedListTitle),
      ),
      floatingActionButton: KinlyFab(
        onPressed: () => _openShareCreate(context),
        heroTag: 'share_created_list_fab',
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing?.lg ?? 16),
          child: BlocBuilder<ShareCreatedListBloc, ShareCreatedListState>(
            builder: (context, state) {
              return ShareCreatedListView(
                state: state,
                shareColors: shareColors,
                onRefreshRequested: () => _handleRefresh(context),
                onCreateTap: () => _openShareCreate(context),
                onEntryTap: (entry) => _openShareEntry(context, entry),
              );
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
    final result = await context.push<bool>(AppRoutes.shareCreate);
    if (result == true && context.mounted) {
      final s = S.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareCreateSuccess)));
      _refreshList(context);
    }
  }

  Future<void> _openShareEntry(
    BuildContext context,
    ShareCreatedListEntry entry,
  ) async {
    final result = await context.push(
      AppRoutes.shareDraftEditPath(entry.expenseId),
      extra: const ShareEditRouteArgs(allowDelete: true),
    );

    if (!context.mounted || result == null) return;

    final s = S.of(context);

    if (result == true || result == ShareEditOutcome.updated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareEditSuccess)));
      _refreshList(context);
    } else if (result == ShareEditOutcome.deleted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(s.shareEditDeleteSuccess)));
      _refreshList(context);
    }
  }
}
